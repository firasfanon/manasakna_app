-- MANASAKNA_SECURITY_CLOSURE_V1
-- Forward-only H3 hardening. Source mutation only in this stage; do not apply without separate authority.
-- Preserves synthetic-only and no-real-data boundaries.

-- Fail closed if the runtime has drifted into real pilgrim-shaped data before this migration is applied.
do $$
begin
  if exists (
    select 1 from manasakna.lottery_entries
    where not is_synthetic or applicant_ref not like 'SYNTH-%'
  ) then
    raise exception 'MANASAKNA_H3_REAL_DATA_DRIFT:lottery_entries';
  end if;
  if exists (
    select 1 from manasakna.group_members
    where applicant_ref not like 'SYNTH-%'
  ) then
    raise exception 'MANASAKNA_H3_REAL_DATA_DRIFT:group_members';
  end if;
  if exists (
    select 1 from manasakna.activation_tokens
    where applicant_ref not like 'SYNTH-%'
  ) then
    raise exception 'MANASAKNA_H3_REAL_DATA_DRIFT:activation_tokens';
  end if;
end;
$$;

-- Normalize legacy synthetic terminal activations before tightening the column.
update manasakna.activation_tokens
set expires_at = issued_at + interval '7 days'
where expires_at is null;

alter table manasakna.activation_tokens
  alter column expires_at set not null;

alter table manasakna.activation_tokens
  add constraint manasakna_activation_expiry_bounded_ck
  check (
    expires_at > issued_at
    and expires_at <= issued_at + interval '7 days'
  );

alter table manasakna.lottery_entries
  add constraint manasakna_lottery_entries_synthetic_only_ck
  check (is_synthetic and applicant_ref like 'SYNTH-%');

alter table manasakna.group_members
  add constraint manasakna_group_members_synthetic_only_ck
  check (applicant_ref like 'SYNTH-%');

alter table manasakna.activation_tokens
  add constraint manasakna_activation_tokens_synthetic_only_ck
  check (applicant_ref like 'SYNTH-%');

alter table manasakna.pilgrim_sessions
  add constraint manasakna_pilgrim_sessions_max_90d_ck
  check (expires_at <= issued_at + interval '90 days');

create or replace function public.rpc_manasakna_issue_activation_v1(
  p_campaign_id uuid,
  p_applicant_ref text,
  p_expires_at timestamptz default null
) returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, manasakna, public
as $$
declare
  v_now timestamptz := clock_timestamp();
  v_expiry timestamptz;
  v_applicant_ref text := trim(coalesce(p_applicant_ref, ''));
  v_token text;
  v_hash text;
  v_id uuid;
begin
  perform manasakna.require_permission_v1('manage_activation');
  if v_applicant_ref = '' then
    raise exception 'MANASAKNA_APPLICANT_REF_REQUIRED';
  end if;
  if v_applicant_ref not like 'SYNTH-%' then
    raise exception 'MANASAKNA_V1_SYNTHETIC_ONLY';
  end if;

  v_expiry := coalesce(p_expires_at, v_now + interval '7 days');
  if v_expiry <= v_now then
    raise exception 'MANASAKNA_ACTIVATION_EXPIRY_NOT_FUTURE';
  end if;
  if v_expiry > v_now + interval '7 days' then
    raise exception 'MANASAKNA_ACTIVATION_EXPIRY_TOO_FAR';
  end if;

  if not exists (
    select 1
    from manasakna.group_members gm
    join manasakna.campaign_groups g on g.id=gm.group_id
    join manasakna.campaigns c on c.id=g.campaign_id
    join manasakna.lottery_entries e on e.id=gm.lottery_entry_id
    join manasakna.lottery_rounds lrnd on lrnd.id=e.round_id and lrnd.season_id=c.season_id
    join manasakna.lottery_results lres on lres.round_id=lrnd.id and lres.entry_id=e.id
    where g.campaign_id=p_campaign_id
      and gm.applicant_ref=v_applicant_ref
      and gm.status in ('assigned','activated')
      and g.status in ('draft','active')
      and c.status in ('draft','active')
      and e.is_synthetic=true
      and e.applicant_ref like 'SYNTH-%'
      and lres.outcome='selected'
  ) then
    raise exception 'MANASAKNA_ACTIVATION_REQUIRES_SELECTED_ASSIGNED_SYNTHETIC_PILGRIM';
  end if;

  update manasakna.activation_tokens
  set status='revoked',revoked_at=v_now
  where campaign_id=p_campaign_id
    and applicant_ref=v_applicant_ref
    and status='active';

  v_token := encode(extensions.gen_random_bytes(24),'hex');
  v_hash := encode(extensions.digest(v_token,'sha256'),'hex');
  insert into manasakna.activation_tokens(
    campaign_id,applicant_ref,token_hash,token_hint,expires_at,issued_by,issued_at
  ) values (
    p_campaign_id,v_applicant_ref,v_hash,left(v_token,6)||'…',v_expiry,auth.uid(),v_now
  ) returning id into v_id;

  perform manasakna.audit_v1(
    'activation_issue','activation_token',v_id::text,null,
    jsonb_build_object(
      'campaign_id',p_campaign_id,
      'applicant_ref',v_applicant_ref,
      'token_hint',left(v_token,6)||'…',
      'expires_at',v_expiry,
      'real_data',false
    )
  );

  return jsonb_build_object(
    'activation_id',v_id,'token',v_token,
    'token_hint',left(v_token,6)||'…','shown_once',true,'expires_at',v_expiry
  );
end;
$$;

-- Legacy activation RPC is retained only for historical compatibility inside owner-controlled SQL.
-- It is no longer externally executable after H3.
revoke all on function public.rpc_manasakna_activate_v1(text)
  from public, anon, authenticated, service_role;

-- H3.1: synthetic fixture/test entrypoints are owner-only. They remain in source
-- for controlled database-owner test execution, but are not exposed through
-- PostgREST/Data API roles in hardened environments.
revoke all on function public.rpc_manasakna_seed_synthetic_lottery_fixture_v1()
  from public, anon, authenticated, service_role;
revoke all on function public.rpc_manasakna_synthetic_e2e_v1()
  from public, anon, authenticated, service_role;
revoke all on function public.rpc_manasakna_seed_pilgrim_backend_fixture_v1()
  from public, anon, authenticated, service_role;

-- Fail the migration if any external API role still inherits EXECUTE.
do $$
begin
  if has_function_privilege('anon', 'public.rpc_manasakna_seed_synthetic_lottery_fixture_v1()', 'EXECUTE')
     or has_function_privilege('authenticated', 'public.rpc_manasakna_seed_synthetic_lottery_fixture_v1()', 'EXECUTE')
     or has_function_privilege('service_role', 'public.rpc_manasakna_seed_synthetic_lottery_fixture_v1()', 'EXECUTE')
     or has_function_privilege('anon', 'public.rpc_manasakna_synthetic_e2e_v1()', 'EXECUTE')
     or has_function_privilege('authenticated', 'public.rpc_manasakna_synthetic_e2e_v1()', 'EXECUTE')
     or has_function_privilege('service_role', 'public.rpc_manasakna_synthetic_e2e_v1()', 'EXECUTE')
     or has_function_privilege('anon', 'public.rpc_manasakna_seed_pilgrim_backend_fixture_v1()', 'EXECUTE')
     or has_function_privilege('authenticated', 'public.rpc_manasakna_seed_pilgrim_backend_fixture_v1()', 'EXECUTE')
     or has_function_privilege('service_role', 'public.rpc_manasakna_seed_pilgrim_backend_fixture_v1()', 'EXECUTE') then
    raise exception 'MANASAKNA_H3_SYNTHETIC_RPC_EXTERNAL_EXECUTE_REMAINS';
  end if;
end;
$$;

grant execute on function public.rpc_manasakna_issue_activation_v1(uuid,text,timestamptz)
  to authenticated;

create or replace function manasakna.expire_credentials_v1()
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_now timestamptz := clock_timestamp();
  v_activations integer := 0;
  v_sessions integer := 0;
begin
  with expired as (
    update manasakna.activation_tokens
    set status='expired'
    where status='active' and expires_at <= v_now
    returning id
  )
  select count(*) into v_activations from expired;

  with expired as (
    update manasakna.pilgrim_sessions
    set status='expired'
    where status='active' and expires_at <= v_now
    returning id
  )
  select count(*) into v_sessions from expired;

  return jsonb_build_object(
    'expired_activations',v_activations,
    'expired_sessions',v_sessions,
    'swept_at',v_now
  );
end;
$$;

revoke all on function manasakna.expire_credentials_v1()
  from public, anon, authenticated, service_role;

-- Schedule only where pg_cron is already present. This does not install or enable extensions.
do $$
declare
  v_job_id bigint;
begin
  if to_regclass('cron.job') is not null then
    for v_job_id in select jobid from cron.job where jobname='manasakna-expire-credentials-v1'
    loop
      perform cron.unschedule(v_job_id);
    end loop;
    perform cron.schedule(
      'manasakna-expire-credentials-v1',
      '*/15 * * * *',
      'select manasakna.expire_credentials_v1();'
    );
  end if;
end;
$$;

comment on function manasakna.expire_credentials_v1() is
  'H3 internal credential lifecycle sweep. External execution is revoked.';

comment on function public.rpc_manasakna_issue_activation_v1(uuid,text,timestamptz) is
  'H3 synthetic-only activation issuance with server-derived expiry and seven-day maximum lifetime.';

comment on function public.rpc_manasakna_seed_synthetic_lottery_fixture_v1() is
  'H3.1 owner-only synthetic lottery fixture. External API execution is revoked.';
comment on function public.rpc_manasakna_synthetic_e2e_v1() is
  'H3.1 owner-only synthetic E2E harness. External API execution is revoked.';
comment on function public.rpc_manasakna_seed_pilgrim_backend_fixture_v1() is
  'H3.1 owner-only synthetic pilgrim fixture. External API execution is revoked.';

comment on constraint manasakna_activation_expiry_bounded_ck
  on manasakna.activation_tokens is
  'Activation credentials must expire after issuance and no later than seven days after issuance.';

comment on constraint manasakna_pilgrim_sessions_max_90d_ck
  on manasakna.pilgrim_sessions is
  'Pilgrim sessions remain bounded to at most ninety days from issuance.';
