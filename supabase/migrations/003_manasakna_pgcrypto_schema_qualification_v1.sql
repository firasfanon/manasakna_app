-- MANASAKNA_PGCRYPTO_SCHEMA_QUALIFICATION_V1
-- Runtime repair after Supabase E2E exposed pgcrypto in the extensions schema.
-- No data model expansion; preserves synthetic-only and standalone boundaries.

create or replace function public.rpc_manasakna_run_lottery_v1(p_round_id uuid, p_seed text)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, manasakna, public
as $$
declare
  v_round manasakna.lottery_rounds%rowtype;
  v_selected integer;
  v_waitlisted integer;
  v_ineligible integer;
begin
  perform manasakna.require_permission_v1('manage_lottery');
  if length(coalesce(p_seed,'')) < 16 then
    raise exception 'MANASAKNA_LOTTERY_SEED_MIN_16_CHARS';
  end if;
  select * into v_round from manasakna.lottery_rounds where id=p_round_id for update;
  if not found then raise exception 'MANASAKNA_LOTTERY_ROUND_NOT_FOUND'; end if;
  if v_round.status in ('executed','cancelled') then
    raise exception 'MANASAKNA_LOTTERY_ROUND_NOT_RUNNABLE:%', v_round.status;
  end if;
  delete from manasakna.lottery_results where round_id=p_round_id;

  insert into manasakna.lottery_results(round_id,entry_id,outcome)
  select p_round_id,e.id,'ineligible'
  from manasakna.lottery_entries e
  where e.round_id=p_round_id and exists (
    select 1 from manasakna.eligibility_rules r
    where r.season_id=v_round.season_id and r.is_active and r.is_required
      and not exists (
        select 1 from manasakna.eligibility_checks c
        where c.entry_id=e.id and c.rule_id=r.id and c.passed
      )
  );

  with eligible as (
    select e.id,
      encode(extensions.digest(p_seed || ':' || e.id::text, 'sha256'),'hex') as score_hash
    from manasakna.lottery_entries e
    where e.round_id=p_round_id and not exists (
      select 1 from manasakna.eligibility_rules r
      where r.season_id=v_round.season_id and r.is_active and r.is_required
        and not exists (
          select 1 from manasakna.eligibility_checks c
          where c.entry_id=e.id and c.rule_id=r.id and c.passed
        )
    )
  ), ranked as (
    select id,score_hash,row_number() over(order by score_hash,id) as rank_no from eligible
  )
  insert into manasakna.lottery_results(round_id,entry_id,rank_no,outcome,score_hash)
  select p_round_id,id,rank_no,
    case when rank_no <= v_round.capacity then 'selected' else 'waitlisted' end,
    score_hash
  from ranked;

  update manasakna.lottery_rounds set
    status='executed', seed_hash=encode(extensions.digest(p_seed,'sha256'),'hex'),
    seed_reveal=p_seed, executed_at=now(), executed_by=auth.uid()
  where id=p_round_id;
  select count(*) into v_selected from manasakna.lottery_results where round_id=p_round_id and outcome='selected';
  select count(*) into v_waitlisted from manasakna.lottery_results where round_id=p_round_id and outcome='waitlisted';
  select count(*) into v_ineligible from manasakna.lottery_results where round_id=p_round_id and outcome='ineligible';
  perform manasakna.audit_v1('lottery_execute','lottery_round',p_round_id::text,null,
    jsonb_build_object('selected',v_selected,'waitlisted',v_waitlisted,'ineligible',v_ineligible,
      'seed_hash',encode(extensions.digest(p_seed,'sha256'),'hex')));
  return jsonb_build_object(
    'round_id',p_round_id,'algorithm','HASH_RANK_V1','selected',v_selected,
    'waitlisted',v_waitlisted,'ineligible',v_ineligible,
    'seed_hash',encode(extensions.digest(p_seed,'sha256'),'hex')
  );
end;
$$;

create or replace function public.rpc_manasakna_issue_activation_v1(
  p_campaign_id uuid, p_applicant_ref text, p_expires_at timestamptz default null
) returns jsonb
language plpgsql security definer
set search_path = pg_catalog, manasakna, public
as $$
declare
  v_token text;
  v_hash text;
  v_id uuid;
begin
  perform manasakna.require_permission_v1('manage_activation');
  if nullif(p_applicant_ref,'') is null then
    raise exception 'MANASAKNA_APPLICANT_REF_REQUIRED';
  end if;
  if not exists (
    select 1
    from manasakna.group_members gm
    join manasakna.campaign_groups g on g.id=gm.group_id
    join manasakna.campaigns c on c.id=g.campaign_id
    join manasakna.lottery_entries e on e.id=gm.lottery_entry_id
    join manasakna.lottery_rounds lrnd on lrnd.id=e.round_id and lrnd.season_id=c.season_id
    join manasakna.lottery_results lres on lres.round_id=lrnd.id and lres.entry_id=e.id
    where g.campaign_id=p_campaign_id and gm.applicant_ref=p_applicant_ref
      and gm.status in ('assigned','activated')
      and g.status in ('draft','active') and c.status in ('draft','active')
      and lres.outcome='selected'
  ) then
    raise exception 'MANASAKNA_ACTIVATION_REQUIRES_SELECTED_ASSIGNED_PILGRIM';
  end if;
  update manasakna.activation_tokens
  set status='revoked',revoked_at=now()
  where campaign_id=p_campaign_id and applicant_ref=p_applicant_ref and status='active';
  v_token := encode(extensions.gen_random_bytes(24),'hex');
  v_hash := encode(extensions.digest(v_token,'sha256'),'hex');
  insert into manasakna.activation_tokens(
    campaign_id,applicant_ref,token_hash,token_hint,expires_at,issued_by
  ) values (
    p_campaign_id,p_applicant_ref,v_hash,left(v_token,6)||'…',p_expires_at,auth.uid()
  ) returning id into v_id;
  perform manasakna.audit_v1(
    'activation_issue','activation_token',v_id::text,null,
    jsonb_build_object(
      'campaign_id',p_campaign_id,'applicant_ref',p_applicant_ref,
      'token_hint',left(v_token,6)||'…'
    )
  );
  return jsonb_build_object(
    'activation_id',v_id,'token',v_token,
    'token_hint',left(v_token,6)||'…','shown_once',true
  );
end;
$$;

create or replace function public.rpc_manasakna_activate_v1(p_token text)
returns jsonb
language plpgsql security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_row manasakna.activation_tokens%rowtype;
  v_group_id uuid;
begin
  select * into v_row
  from manasakna.activation_tokens
  where token_hash=encode(extensions.digest(p_token,'sha256'),'hex')
    and status='active'
    and (expires_at is null or expires_at > now())
  for update;
  if not found then
    return jsonb_build_object('success',false,'code','INVALID_OR_EXPIRED');
  end if;
  select gm.group_id into v_group_id
  from manasakna.group_members gm
  join manasakna.campaign_groups g on g.id=gm.group_id
  join manasakna.campaigns c on c.id=g.campaign_id
  join manasakna.lottery_entries e on e.id=gm.lottery_entry_id
  join manasakna.lottery_rounds lrnd on lrnd.id=e.round_id and lrnd.season_id=c.season_id
  join manasakna.lottery_results lres on lres.round_id=lrnd.id and lres.entry_id=e.id
  where g.campaign_id=v_row.campaign_id
    and gm.applicant_ref=v_row.applicant_ref
    and gm.status in ('assigned','activated')
    and g.status in ('draft','active') and c.status in ('draft','active')
    and lres.outcome='selected'
  limit 1;
  if v_group_id is null then
    return jsonb_build_object('success',false,'code','NOT_CURRENTLY_ELIGIBLE');
  end if;
  update manasakna.activation_tokens
  set status='consumed',consumed_at=now()
  where id=v_row.id;
  update manasakna.group_members
  set status='activated'
  where group_id=v_group_id and applicant_ref=v_row.applicant_ref and status='assigned';
  perform manasakna.audit_v1(
    'activation_consume','activation_token',v_row.id::text,null,
    jsonb_build_object('group_id',v_group_id,'applicant_ref',v_row.applicant_ref)
  );
  return jsonb_build_object(
    'success',true,
    'campaign_id',v_row.campaign_id,
    'group_id',v_group_id,
    'applicant_ref',v_row.applicant_ref
  );
end;
$$;
