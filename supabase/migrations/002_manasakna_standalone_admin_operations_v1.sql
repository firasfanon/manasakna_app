-- MANASAKNA_STANDALONE_ADMIN_AND_OPERATIONS_V1
-- Repository-first migration. Synthetic/test data only until a separate real-data authorization.
-- Keeps the existing nosok schema untouched and isolates operational state under manasakna.

create extension if not exists pgcrypto;
create schema if not exists manasakna;

create or replace function manasakna.set_updated_at_v1()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create table if not exists manasakna.admin_role_bindings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  role_key text not null check (role_key in ('super_admin','operations_admin','lottery_manager','content_editor','viewer')),
  is_active boolean not null default true,
  created_by uuid,
  created_at timestamptz not null default now(),
  unique(user_id, role_key)
);
create table if not exists manasakna.seasons (
  id uuid primary key default gen_random_uuid(),
  season_code text not null unique,
  title_ar text not null,
  title_en text,
  hijri_year integer,
  gregorian_year integer,
  registration_opens_at timestamptz,
  registration_closes_at timestamptz,
  operations_start_at timestamptz,
  operations_end_at timestamptz,
  status text not null default 'draft' check (status in ('draft','registration_open','registration_closed','lottery','operations','closed','archived')),
  settings jsonb not null default '{}'::jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists manasakna.eligibility_rules (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references manasakna.seasons(id) on delete cascade,
  rule_key text not null,
  title_ar text not null,
  description_ar text,
  rule_kind text not null default 'manual_check' check (rule_kind in ('manual_check','boolean','external_adapter')),
  config jsonb not null default '{}'::jsonb,
  is_required boolean not null default true,
  is_active boolean not null default true,
  display_order integer not null default 0,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(season_id, rule_key)
);

create table if not exists manasakna.lottery_rounds (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references manasakna.seasons(id) on delete restrict,
  round_code text not null,
  title_ar text not null,
  capacity integer not null check (capacity > 0),
  status text not null default 'draft' check (status in ('draft','locked','executed','cancelled')),
  algorithm_version text not null default 'HASH_RANK_V1',
  seed_hash text,
  seed_reveal text,
  executed_at timestamptz,
  executed_by uuid,
  created_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(season_id, round_code)
);

create table if not exists manasakna.lottery_entries (
  id uuid primary key default gen_random_uuid(),
  round_id uuid not null references manasakna.lottery_rounds(id) on delete cascade,
  applicant_ref text not null,
  display_name text,
  is_synthetic boolean not null default true,
  metadata jsonb not null default '{}'::jsonb,
  created_by uuid,
  created_at timestamptz not null default now(),
  unique(round_id, applicant_ref)
);

create table if not exists manasakna.eligibility_checks (
  id uuid primary key default gen_random_uuid(),
  entry_id uuid not null references manasakna.lottery_entries(id) on delete cascade,
  rule_id uuid not null references manasakna.eligibility_rules(id) on delete cascade,
  passed boolean not null,
  reason_code text,
  notes text,
  checked_by uuid,
  checked_at timestamptz not null default now(),
  unique(entry_id, rule_id)
);

create table if not exists manasakna.lottery_results (
  id uuid primary key default gen_random_uuid(),
  round_id uuid not null references manasakna.lottery_rounds(id) on delete cascade,
  entry_id uuid not null references manasakna.lottery_entries(id) on delete cascade,
  rank_no integer,
  outcome text not null check (outcome in ('selected','waitlisted','ineligible')),
  score_hash text,
  created_at timestamptz not null default now(),
  unique(round_id, entry_id)
);
create table if not exists manasakna.campaigns (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references manasakna.seasons(id) on delete restrict,
  campaign_code text not null,
  title_ar text not null,
  description_ar text,
  starts_at timestamptz,
  ends_at timestamptz,
  status text not null default 'draft' check (status in ('draft','active','closed','archived')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(season_id, campaign_code)
);

create table if not exists manasakna.campaign_groups (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references manasakna.campaigns(id) on delete cascade,
  group_code text not null,
  title_ar text not null,
  capacity integer check (capacity is null or capacity > 0),
  supervisor_label text,
  status text not null default 'draft' check (status in ('draft','active','closed')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(campaign_id, group_code)
);
create table if not exists manasakna.group_members (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references manasakna.campaign_groups(id) on delete cascade,
  lottery_entry_id uuid references manasakna.lottery_entries(id) on delete set null,
  applicant_ref text not null,
  display_name text,
  status text not null default 'assigned' check (status in ('assigned','activated','cancelled')),
  created_by uuid,
  created_at timestamptz not null default now(),
  unique(group_id, applicant_ref)
);

create table if not exists manasakna.activation_tokens (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references manasakna.campaigns(id) on delete cascade,
  applicant_ref text not null,
  token_hash text not null unique,
  token_hint text not null,
  status text not null default 'active' check (status in ('active','consumed','revoked','expired')),
  expires_at timestamptz,
  issued_by uuid,
  issued_at timestamptz not null default now(),
  consumed_at timestamptz,
  revoked_at timestamptz
);

create unique index if not exists manasakna_activation_tokens_one_active_per_applicant_idx
on manasakna.activation_tokens(campaign_id, applicant_ref)
where status = 'active';

create table if not exists manasakna.content_items (
  id uuid primary key default gen_random_uuid(),
  season_id uuid references manasakna.seasons(id) on delete set null,
  content_type text not null check (content_type in ('guidance','fatwa','service','contact','banner','faq')),
  slug text not null,
  title_ar text not null,
  body_ar text,
  metadata jsonb not null default '{}'::jsonb,
  status text not null default 'draft' check (status in ('draft','published','archived')),
  published_at timestamptz,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(content_type, slug)
);

create table if not exists manasakna.notifications (
  id uuid primary key default gen_random_uuid(),
  season_id uuid references manasakna.seasons(id) on delete set null,
  title_ar text not null,
  body_ar text not null,
  audience jsonb not null default '{"kind":"all"}'::jsonb,
  status text not null default 'draft' check (status in ('draft','scheduled','published','cancelled')),
  scheduled_for timestamptz,
  published_at timestamptz,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists manasakna.audit_events (
  id bigint generated always as identity primary key,
  actor_user_id uuid,
  action_key text not null,
  entity_type text not null,
  entity_id text,
  before_state jsonb,
  after_state jsonb,
  request_id text,
  created_at timestamptz not null default now()
);

create index if not exists manasakna_lottery_entries_round_idx on manasakna.lottery_entries(round_id);
create index if not exists manasakna_eligibility_checks_entry_idx on manasakna.eligibility_checks(entry_id);
create index if not exists manasakna_lottery_results_round_idx on manasakna.lottery_results(round_id, outcome, rank_no);
create index if not exists manasakna_content_status_idx on manasakna.content_items(status, content_type);
create index if not exists manasakna_notifications_status_idx on manasakna.notifications(status, scheduled_for);
create index if not exists manasakna_audit_created_idx on manasakna.audit_events(created_at desc);

create or replace trigger manasakna_seasons_updated_at
before update on manasakna.seasons for each row execute function manasakna.set_updated_at_v1();
create or replace trigger manasakna_rules_updated_at
before update on manasakna.eligibility_rules for each row execute function manasakna.set_updated_at_v1();
create or replace trigger manasakna_rounds_updated_at
before update on manasakna.lottery_rounds for each row execute function manasakna.set_updated_at_v1();
create or replace trigger manasakna_campaigns_updated_at
before update on manasakna.campaigns for each row execute function manasakna.set_updated_at_v1();
create or replace trigger manasakna_groups_updated_at
before update on manasakna.campaign_groups for each row execute function manasakna.set_updated_at_v1();
create or replace trigger manasakna_content_updated_at
before update on manasakna.content_items for each row execute function manasakna.set_updated_at_v1();
create or replace trigger manasakna_notifications_updated_at
before update on manasakna.notifications for each row execute function manasakna.set_updated_at_v1();
alter table manasakna.admin_role_bindings enable row level security;
alter table manasakna.seasons enable row level security;
alter table manasakna.eligibility_rules enable row level security;
alter table manasakna.lottery_rounds enable row level security;
alter table manasakna.lottery_entries enable row level security;
alter table manasakna.eligibility_checks enable row level security;
alter table manasakna.lottery_results enable row level security;
alter table manasakna.campaigns enable row level security;
alter table manasakna.campaign_groups enable row level security;
alter table manasakna.group_members enable row level security;
alter table manasakna.activation_tokens enable row level security;
alter table manasakna.content_items enable row level security;
alter table manasakna.notifications enable row level security;
alter table manasakna.audit_events enable row level security;

revoke all on schema manasakna from public, anon, authenticated;
revoke all on all tables in schema manasakna from public, anon, authenticated;
grant usage on schema manasakna to authenticated;

create or replace function manasakna.has_permission_v1(p_permission text)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, manasakna, platform_access
as $$
  select auth.uid() is not null and exists (
    select 1 from platform_access.admin_users au
    where au.id = auth.uid() and coalesce(au.is_active, false)
      and (au.is_superuser or exists (
        select 1 from manasakna.admin_role_bindings b
        where b.user_id = auth.uid() and b.is_active and (
          b.role_key = 'super_admin'
          or p_permission = 'view'
          or (b.role_key = 'operations_admin' and p_permission in (
            'manage_seasons','manage_campaigns','manage_activation','manage_content','manage_notifications','view_audit'
          ))
          or (b.role_key = 'lottery_manager' and p_permission in ('manage_eligibility','manage_lottery'))
          or (b.role_key = 'content_editor' and p_permission in ('manage_content','manage_notifications'))
        )
      ))
  );
$$;

create or replace function manasakna.require_permission_v1(p_permission text)
returns void
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
begin
  if not manasakna.has_permission_v1(p_permission) then
    raise exception 'MANASAKNA_FORBIDDEN:%', p_permission using errcode = '42501';
  end if;
end;
$$;

create or replace function manasakna.audit_v1(
  p_action text, p_entity_type text, p_entity_id text,
  p_before jsonb default null, p_after jsonb default null, p_request_id text default null
) returns void
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
begin
  insert into manasakna.audit_events(
    actor_user_id, action_key, entity_type, entity_id,
    before_state, after_state, request_id
  ) values (
    auth.uid(), p_action, p_entity_type, p_entity_id,
    p_before, p_after, p_request_id
  );
end;
$$;

create or replace function public.rpc_manasakna_admin_context_v1()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, manasakna, platform_access
as $$
declare
  v_user platform_access.admin_users%rowtype;
  v_roles text[];
begin
  select * into v_user from platform_access.admin_users
  where id = auth.uid() and coalesce(is_active,false);
  if not found then raise exception 'MANASAKNA_ADMIN_REQUIRED' using errcode='42501'; end if;
  select coalesce(array_agg(role_key order by role_key), '{}'::text[]) into v_roles
  from manasakna.admin_role_bindings where user_id = auth.uid() and is_active;
  return jsonb_build_object(
    'user_id', v_user.id,
    'email', v_user.email,
    'name', v_user.name,
    'is_superuser', v_user.is_superuser,
    'roles', v_roles,
    'permissions', jsonb_build_object(
      'view', manasakna.has_permission_v1('view'),
      'manage_seasons', manasakna.has_permission_v1('manage_seasons'),
      'manage_eligibility', manasakna.has_permission_v1('manage_eligibility'),
      'manage_lottery', manasakna.has_permission_v1('manage_lottery'),
      'manage_campaigns', manasakna.has_permission_v1('manage_campaigns'),
      'manage_activation', manasakna.has_permission_v1('manage_activation'),
      'manage_content', manasakna.has_permission_v1('manage_content'),
      'manage_notifications', manasakna.has_permission_v1('manage_notifications'),
      'view_audit', manasakna.has_permission_v1('view_audit')
    )
  );
end;
$$;

create or replace function public.rpc_manasakna_dashboard_v1()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return jsonb_build_object(
    'seasons', (select count(*) from manasakna.seasons),
    'lottery_rounds', (select count(*) from manasakna.lottery_rounds),
    'campaigns', (select count(*) from manasakna.campaigns),
    'published_content', (select count(*) from manasakna.content_items where status='published'),
    'pending_notifications', (select count(*) from manasakna.notifications where status in ('draft','scheduled')),
    'audit_events', (select count(*) from manasakna.audit_events)
  );
end;
$$;

create or replace function public.rpc_manasakna_seasons_v1()
returns setof manasakna.seasons
language plpgsql
stable
security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query select * from manasakna.seasons order by created_at desc;
end;
$$;

create or replace function public.rpc_manasakna_season_upsert_v1(p_payload jsonb)
returns manasakna.seasons
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_id uuid := nullif(p_payload->>'id','')::uuid;
  v_before jsonb;
  v_row manasakna.seasons%rowtype;
begin
  perform manasakna.require_permission_v1('manage_seasons');
  if nullif(p_payload->>'season_code','') is null or nullif(p_payload->>'title_ar','') is null then
    raise exception 'MANASAKNA_SEASON_CODE_AND_TITLE_REQUIRED';
  end if;
  if v_id is null then
    insert into manasakna.seasons(
      season_code,title_ar,title_en,hijri_year,gregorian_year,status,settings,created_by,updated_by
    ) values (
      p_payload->>'season_code',p_payload->>'title_ar',nullif(p_payload->>'title_en',''),
      nullif(p_payload->>'hijri_year','')::integer,nullif(p_payload->>'gregorian_year','')::integer,
      coalesce(nullif(p_payload->>'status',''),'draft'),coalesce(p_payload->'settings','{}'::jsonb),
      auth.uid(),auth.uid()
    )
    on conflict (season_code) do update set
      title_ar=excluded.title_ar,
      title_en=excluded.title_en,
      hijri_year=coalesce(excluded.hijri_year,manasakna.seasons.hijri_year),
      gregorian_year=coalesce(excluded.gregorian_year,manasakna.seasons.gregorian_year),
      status=excluded.status,
      settings=excluded.settings,
      updated_by=auth.uid()
    returning * into v_row;
  else
    select to_jsonb(s.*) into v_before from manasakna.seasons s where s.id=v_id;
    update manasakna.seasons s set
      season_code=coalesce(nullif(p_payload->>'season_code',''),s.season_code),
      title_ar=coalesce(nullif(p_payload->>'title_ar',''),s.title_ar),
      title_en=case when p_payload ? 'title_en' then nullif(p_payload->>'title_en','') else s.title_en end,
      hijri_year=coalesce(nullif(p_payload->>'hijri_year','')::integer,s.hijri_year),
      gregorian_year=coalesce(nullif(p_payload->>'gregorian_year','')::integer,s.gregorian_year),
      status=coalesce(nullif(p_payload->>'status',''),s.status),
      settings=coalesce(p_payload->'settings',s.settings),updated_by=auth.uid()
    where s.id=v_id returning * into v_row;
  end if;
  perform manasakna.audit_v1('season_upsert','season',v_row.id::text,v_before,to_jsonb(v_row));
  return v_row;
end;
$$;
create or replace function public.rpc_manasakna_eligibility_rules_v1(p_season_id uuid)
returns setof manasakna.eligibility_rules
language plpgsql
stable
security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query select * from manasakna.eligibility_rules
  where season_id=p_season_id order by display_order, rule_key;
end;
$$;

create or replace function public.rpc_manasakna_eligibility_rule_upsert_v1(p_payload jsonb)
returns manasakna.eligibility_rules
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_id uuid := nullif(p_payload->>'id','')::uuid;
  v_row manasakna.eligibility_rules%rowtype;
begin
  perform manasakna.require_permission_v1('manage_eligibility');
  if v_id is null then
    insert into manasakna.eligibility_rules(
      season_id,rule_key,title_ar,description_ar,rule_kind,config,is_required,is_active,display_order,created_by,updated_by
    ) values (
      (p_payload->>'season_id')::uuid,p_payload->>'rule_key',p_payload->>'title_ar',p_payload->>'description_ar',
      coalesce(nullif(p_payload->>'rule_kind',''),'manual_check'),coalesce(p_payload->'config','{}'::jsonb),
      coalesce((p_payload->>'is_required')::boolean,true),coalesce((p_payload->>'is_active')::boolean,true),
      coalesce((p_payload->>'display_order')::integer,0),auth.uid(),auth.uid()
    ) returning * into v_row;
  else
    update manasakna.eligibility_rules r set
      rule_key=coalesce(nullif(p_payload->>'rule_key',''),r.rule_key),
      title_ar=coalesce(nullif(p_payload->>'title_ar',''),r.title_ar),
      description_ar=case when p_payload ? 'description_ar' then p_payload->>'description_ar' else r.description_ar end,
      rule_kind=coalesce(nullif(p_payload->>'rule_kind',''),r.rule_kind),
      config=coalesce(p_payload->'config',r.config),
      is_required=coalesce((p_payload->>'is_required')::boolean,r.is_required),
      is_active=coalesce((p_payload->>'is_active')::boolean,r.is_active),
      display_order=coalesce((p_payload->>'display_order')::integer,r.display_order),updated_by=auth.uid()
    where r.id=v_id returning * into v_row;
  end if;
  perform manasakna.audit_v1('eligibility_rule_upsert','eligibility_rule',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;

create or replace function public.rpc_manasakna_lottery_rounds_v1(p_season_id uuid default null)
returns table(
  id uuid, season_id uuid, round_code text, title_ar text, capacity integer, status text,
  algorithm_version text, seed_hash text, executed_at timestamptz, total_entries bigint,
  selected_count bigint, waitlisted_count bigint, ineligible_count bigint
)
language plpgsql stable security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query
  select r.id,r.season_id,r.round_code,r.title_ar,r.capacity,r.status,r.algorithm_version,r.seed_hash,r.executed_at,
    count(distinct e.id) as total_entries,
    count(distinct lr.entry_id) filter (where lr.outcome='selected') as selected_count,
    count(distinct lr.entry_id) filter (where lr.outcome='waitlisted') as waitlisted_count,
    count(distinct lr.entry_id) filter (where lr.outcome='ineligible') as ineligible_count
  from manasakna.lottery_rounds r
  left join manasakna.lottery_entries e on e.round_id=r.id
  left join manasakna.lottery_results lr on lr.round_id=r.id
  where p_season_id is null or r.season_id=p_season_id
  group by r.id
  order by r.created_at desc;
end;
$$;

create or replace function public.rpc_manasakna_lottery_round_upsert_v1(p_payload jsonb)
returns manasakna.lottery_rounds
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_id uuid := nullif(p_payload->>'id','')::uuid;
  v_row manasakna.lottery_rounds%rowtype;
begin
  perform manasakna.require_permission_v1('manage_lottery');
  if v_id is null then
    insert into manasakna.lottery_rounds(season_id,round_code,title_ar,capacity,status,created_by)
    values ((p_payload->>'season_id')::uuid,p_payload->>'round_code',p_payload->>'title_ar',
      (p_payload->>'capacity')::integer,coalesce(nullif(p_payload->>'status',''),'draft'),auth.uid())
    returning * into v_row;
  else
    if exists(select 1 from manasakna.lottery_rounds where id=v_id and status='executed') then
      raise exception 'MANASAKNA_EXECUTED_ROUND_IMMUTABLE';
    end if;
    update manasakna.lottery_rounds r set
      round_code=coalesce(nullif(p_payload->>'round_code',''),r.round_code),
      title_ar=coalesce(nullif(p_payload->>'title_ar',''),r.title_ar),
      capacity=coalesce((p_payload->>'capacity')::integer,r.capacity),
      status=coalesce(nullif(p_payload->>'status',''),r.status)
    where r.id=v_id returning * into v_row;
  end if;
  perform manasakna.audit_v1('lottery_round_upsert','lottery_round',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;

create or replace function public.rpc_manasakna_lottery_entry_upsert_v1(p_payload jsonb)
returns manasakna.lottery_entries
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare v_row manasakna.lottery_entries%rowtype;
begin
  perform manasakna.require_permission_v1('manage_lottery');
  if not coalesce((p_payload->>'is_synthetic')::boolean,true) then
    raise exception 'MANASAKNA_REAL_DATA_NOT_AUTHORIZED';
  end if;
  insert into manasakna.lottery_entries(round_id,applicant_ref,display_name,is_synthetic,metadata,created_by)
  values ((p_payload->>'round_id')::uuid,p_payload->>'applicant_ref',nullif(p_payload->>'display_name',''),
    true,coalesce(p_payload->'metadata','{}'::jsonb),auth.uid())
  on conflict (round_id,applicant_ref) do update set
    display_name=excluded.display_name,metadata=excluded.metadata
  returning * into v_row;
  perform manasakna.audit_v1('lottery_entry_upsert','lottery_entry',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;

create or replace function public.rpc_manasakna_eligibility_check_set_v1(p_payload jsonb)
returns manasakna.eligibility_checks
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare v_row manasakna.eligibility_checks%rowtype;
begin
  perform manasakna.require_permission_v1('manage_eligibility');
  insert into manasakna.eligibility_checks(entry_id,rule_id,passed,reason_code,notes,checked_by)
  values ((p_payload->>'entry_id')::uuid,(p_payload->>'rule_id')::uuid,(p_payload->>'passed')::boolean,
    nullif(p_payload->>'reason_code',''),nullif(p_payload->>'notes',''),auth.uid())
  on conflict (entry_id,rule_id) do update set
    passed=excluded.passed,reason_code=excluded.reason_code,notes=excluded.notes,
    checked_by=auth.uid(),checked_at=now()
  returning * into v_row;
  perform manasakna.audit_v1('eligibility_check_set','eligibility_check',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;
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
      encode(digest(p_seed || ':' || e.id::text, 'sha256'),'hex') as score_hash
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
    status='executed', seed_hash=encode(digest(p_seed,'sha256'),'hex'),
    seed_reveal=p_seed, executed_at=now(), executed_by=auth.uid()
  where id=p_round_id;
  select count(*) into v_selected from manasakna.lottery_results where round_id=p_round_id and outcome='selected';
  select count(*) into v_waitlisted from manasakna.lottery_results where round_id=p_round_id and outcome='waitlisted';
  select count(*) into v_ineligible from manasakna.lottery_results where round_id=p_round_id and outcome='ineligible';
  perform manasakna.audit_v1('lottery_execute','lottery_round',p_round_id::text,null,
    jsonb_build_object('selected',v_selected,'waitlisted',v_waitlisted,'ineligible',v_ineligible,
      'seed_hash',encode(digest(p_seed,'sha256'),'hex')));
  return jsonb_build_object(
    'round_id',p_round_id,'algorithm','HASH_RANK_V1','selected',v_selected,
    'waitlisted',v_waitlisted,'ineligible',v_ineligible,
    'seed_hash',encode(digest(p_seed,'sha256'),'hex')
  );
end;
$$;

create or replace function public.rpc_manasakna_lottery_results_v1(p_round_id uuid)
returns table(entry_id uuid,applicant_ref text,display_name text,outcome text,rank_no integer,score_hash text)
language plpgsql stable security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query select e.id,e.applicant_ref,e.display_name,r.outcome,r.rank_no,r.score_hash
  from manasakna.lottery_results r join manasakna.lottery_entries e on e.id=r.entry_id
  where r.round_id=p_round_id
  order by case r.outcome when 'selected' then 1 when 'waitlisted' then 2 else 3 end,
    r.rank_no nulls last,e.applicant_ref;
end;
$$;
create or replace function public.rpc_manasakna_seed_synthetic_lottery_fixture_v1()
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, manasakna, public
as $$
declare
  v_suffix text := to_char(clock_timestamp(),'YYYYMMDDHH24MISSMS');
  v_season_id uuid;
  v_round_id uuid;
  v_rule_a uuid;
  v_rule_b uuid;
  v_entry_id uuid;
  v_i integer;
  v_run jsonb;
begin
  perform manasakna.require_permission_v1('manage_lottery');
  perform manasakna.require_permission_v1('manage_eligibility');
  insert into manasakna.seasons(
    season_code,title_ar,hijri_year,gregorian_year,status,settings,created_by,updated_by
  ) values (
    'SYNTH-'||v_suffix,'موسم تجريبي اصطناعي',1448,2027,'lottery',
    jsonb_build_object('synthetic_fixture',true,'real_data',false),auth.uid(),auth.uid()
  ) returning id into v_season_id;

  insert into manasakna.eligibility_rules(
    season_id,rule_key,title_ar,rule_kind,is_required,is_active,display_order,created_by,updated_by
  ) values
    (v_season_id,'synthetic_identity','تحقق هوية اصطناعي','manual_check',true,true,10,auth.uid(),auth.uid())
  returning id into v_rule_a;
  insert into manasakna.eligibility_rules(
    season_id,rule_key,title_ar,rule_kind,is_required,is_active,display_order,created_by,updated_by
  ) values (
    v_season_id,'synthetic_clearance','تحقق أهلية اصطناعي','manual_check',true,true,20,auth.uid(),auth.uid()
  ) returning id into v_rule_b;

  insert into manasakna.lottery_rounds(
    season_id,round_code,title_ar,capacity,status,created_by
  ) values (
    v_season_id,'SYNTH-ROUND-01','قرعة اصطناعية — 12 حالة',5,'draft',auth.uid()
  ) returning id into v_round_id;

  for v_i in 1..12 loop
    insert into manasakna.lottery_entries(
      round_id,applicant_ref,display_name,is_synthetic,metadata,created_by
    ) values (
      v_round_id,'SYNTH-'||lpad(v_i::text,2,'0'),'متقدم اصطناعي '||lpad(v_i::text,2,'0'),true,
      jsonb_build_object('fixture_case',v_i,'contains_real_pii',false),auth.uid()
    ) returning id into v_entry_id;

    insert into manasakna.eligibility_checks(entry_id,rule_id,passed,reason_code,checked_by)
    values (v_entry_id,v_rule_a,v_i not in (9,10),
      case when v_i in (9,10) then 'SYNTH_IDENTITY_FAIL' else 'SYNTH_PASS' end,auth.uid());
    insert into manasakna.eligibility_checks(entry_id,rule_id,passed,reason_code,checked_by)
    values (v_entry_id,v_rule_b,v_i not in (11,12),
      case when v_i in (11,12) then 'SYNTH_CLEARANCE_FAIL' else 'SYNTH_PASS' end,auth.uid());
  end loop;
  v_run := public.rpc_manasakna_run_lottery_v1(
    v_round_id,'MANASAKNA-SYNTHETIC-SEED-'||v_suffix
  );
  perform manasakna.audit_v1('synthetic_fixture_create','lottery_round',v_round_id::text,null,
    jsonb_build_object('season_id',v_season_id,'cases',12,'real_data',false));
  return jsonb_build_object(
    'season_id',v_season_id,'round_id',v_round_id,'cases',12,
    'expected_eligible',8,'expected_ineligible',4,'capacity',5,'result',v_run
  );
end;
$$;

create or replace function public.rpc_manasakna_campaigns_v1(p_season_id uuid default null)
returns table(
  id uuid,season_id uuid,campaign_code text,title_ar text,description_ar text,
  starts_at timestamptz,ends_at timestamptz,status text,group_count bigint
)
language plpgsql stable security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query select c.id,c.season_id,c.campaign_code,c.title_ar,c.description_ar,
    c.starts_at,c.ends_at,c.status,count(g.id)
  from manasakna.campaigns c left join manasakna.campaign_groups g on g.campaign_id=c.id
  where p_season_id is null or c.season_id=p_season_id
  group by c.id order by c.created_at desc;
end;
$$;
create or replace function public.rpc_manasakna_campaign_upsert_v1(p_payload jsonb)
returns manasakna.campaigns
language plpgsql security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_id uuid := nullif(p_payload->>'id','')::uuid;
  v_row manasakna.campaigns%rowtype;
begin
  perform manasakna.require_permission_v1('manage_campaigns');
  if v_id is null then
    insert into manasakna.campaigns(
      season_id,campaign_code,title_ar,description_ar,starts_at,ends_at,status,created_by,updated_by
    ) values (
      (p_payload->>'season_id')::uuid,p_payload->>'campaign_code',p_payload->>'title_ar',
      nullif(p_payload->>'description_ar',''),nullif(p_payload->>'starts_at','')::timestamptz,
      nullif(p_payload->>'ends_at','')::timestamptz,coalesce(nullif(p_payload->>'status',''),'draft'),
      auth.uid(),auth.uid()
    ) returning * into v_row;
  else
    update manasakna.campaigns c set
      campaign_code=coalesce(nullif(p_payload->>'campaign_code',''),c.campaign_code),
      title_ar=coalesce(nullif(p_payload->>'title_ar',''),c.title_ar),
      description_ar=case when p_payload ? 'description_ar' then p_payload->>'description_ar' else c.description_ar end,
      starts_at=coalesce(nullif(p_payload->>'starts_at','')::timestamptz,c.starts_at),
      ends_at=coalesce(nullif(p_payload->>'ends_at','')::timestamptz,c.ends_at),
      status=coalesce(nullif(p_payload->>'status',''),c.status),updated_by=auth.uid()
    where c.id=v_id returning * into v_row;
  end if;
  perform manasakna.audit_v1('campaign_upsert','campaign',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;

create or replace function public.rpc_manasakna_group_upsert_v1(p_payload jsonb)
returns manasakna.campaign_groups
language plpgsql security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_id uuid := nullif(p_payload->>'id','')::uuid;
  v_row manasakna.campaign_groups%rowtype;
begin
  perform manasakna.require_permission_v1('manage_campaigns');
  if v_id is null then
    insert into manasakna.campaign_groups(
      campaign_id,group_code,title_ar,capacity,supervisor_label,status,created_by,updated_by
    ) values (
      (p_payload->>'campaign_id')::uuid,p_payload->>'group_code',p_payload->>'title_ar',
      nullif(p_payload->>'capacity','')::integer,nullif(p_payload->>'supervisor_label',''),
      coalesce(nullif(p_payload->>'status',''),'draft'),auth.uid(),auth.uid()
    ) returning * into v_row;
  else
    update manasakna.campaign_groups g set
      group_code=coalesce(nullif(p_payload->>'group_code',''),g.group_code),
      title_ar=coalesce(nullif(p_payload->>'title_ar',''),g.title_ar),
      capacity=coalesce(nullif(p_payload->>'capacity','')::integer,g.capacity),
      supervisor_label=case when p_payload ? 'supervisor_label' then p_payload->>'supervisor_label' else g.supervisor_label end,
      status=coalesce(nullif(p_payload->>'status',''),g.status),updated_by=auth.uid()
    where g.id=v_id returning * into v_row;
  end if;
  perform manasakna.audit_v1('group_upsert','campaign_group',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;

create or replace function public.rpc_manasakna_campaign_groups_v1(p_campaign_id uuid default null)
returns table(
  id uuid,campaign_id uuid,group_code text,title_ar text,capacity integer,
  supervisor_label text,status text,member_count bigint
)
language plpgsql stable security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query select g.id,g.campaign_id,g.group_code,g.title_ar,g.capacity,
    g.supervisor_label,g.status,count(m.id)
  from manasakna.campaign_groups g
  left join manasakna.group_members m on m.group_id=g.id and m.status<>'cancelled'
  where p_campaign_id is null or g.campaign_id=p_campaign_id
  group by g.id order by g.created_at desc;
end;
$$;

create or replace function public.rpc_manasakna_group_members_v1(p_group_id uuid)
returns table(
  id uuid,group_id uuid,lottery_entry_id uuid,applicant_ref text,
  display_name text,status text,lottery_outcome text
)
language plpgsql stable security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query
  select m.id,m.group_id,m.lottery_entry_id,m.applicant_ref,m.display_name,m.status,r.outcome
  from manasakna.group_members m
  left join manasakna.lottery_results r on r.entry_id=m.lottery_entry_id
  where m.group_id=p_group_id
  order by m.created_at;
end;
$$;

create or replace function public.rpc_manasakna_group_member_assign_v1(
  p_group_id uuid, p_lottery_entry_id uuid
) returns manasakna.group_members
language plpgsql security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_campaign_id uuid;
  v_season_id uuid;
  v_capacity integer;
  v_applicant_ref text;
  v_display_name text;
  v_row manasakna.group_members%rowtype;
begin
  perform manasakna.require_permission_v1('manage_campaigns');
  select g.campaign_id,c.season_id,g.capacity,e.applicant_ref,e.display_name
  into v_campaign_id,v_season_id,v_capacity,v_applicant_ref,v_display_name
  from manasakna.campaign_groups g
  join manasakna.campaigns c on c.id=g.campaign_id
  join manasakna.lottery_entries e on e.id=p_lottery_entry_id
  join manasakna.lottery_rounds lrnd on lrnd.id=e.round_id and lrnd.season_id=c.season_id
  join manasakna.lottery_results lres on lres.round_id=lrnd.id and lres.entry_id=e.id
  where g.id=p_group_id
    and g.status in ('draft','active')
    and c.status in ('draft','active')
    and lres.outcome='selected';
  if not found then
    raise exception 'MANASAKNA_ONLY_SELECTED_PILGRIM_ASSIGNABLE';
  end if;
  if exists (
    select 1 from manasakna.group_members m
    join manasakna.campaign_groups og on og.id=m.group_id
    where og.campaign_id=v_campaign_id and m.applicant_ref=v_applicant_ref
      and m.group_id<>p_group_id and m.status<>'cancelled'
  ) then
    raise exception 'MANASAKNA_ALREADY_ASSIGNED_TO_CAMPAIGN';
  end if;
  if v_capacity is not null and not exists (
    select 1 from manasakna.group_members m
    where m.group_id=p_group_id and m.applicant_ref=v_applicant_ref and m.status<>'cancelled'
  ) and (
    select count(*) from manasakna.group_members m
    where m.group_id=p_group_id and m.status<>'cancelled'
  ) >= v_capacity then
    raise exception 'MANASAKNA_GROUP_CAPACITY_REACHED';
  end if;
  insert into manasakna.group_members(
    group_id,lottery_entry_id,applicant_ref,display_name,status,created_by
  ) values (
    p_group_id,p_lottery_entry_id,v_applicant_ref,v_display_name,'assigned',auth.uid()
  )
  on conflict (group_id,applicant_ref) do update set
    lottery_entry_id=excluded.lottery_entry_id,
    display_name=excluded.display_name,
    status='assigned'
  returning * into v_row;
  perform manasakna.audit_v1(
    'group_member_assign','group_member',v_row.id::text,null,to_jsonb(v_row)
  );
  return v_row;
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
  v_token := encode(gen_random_bytes(24),'hex');
  v_hash := encode(digest(v_token,'sha256'),'hex');
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
create or replace function public.rpc_manasakna_activation_revoke_v1(p_activation_id uuid)
returns boolean
language plpgsql security definer
set search_path = pg_catalog, manasakna
as $$
declare v_changed boolean;
begin
  perform manasakna.require_permission_v1('manage_activation');
  update manasakna.activation_tokens set status='revoked',revoked_at=now()
  where id=p_activation_id and status='active';
  v_changed := found;
  if v_changed then
    perform manasakna.audit_v1('activation_revoke','activation_token',p_activation_id::text);
  end if;
  return v_changed;
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
  where token_hash=encode(digest(p_token,'sha256'),'hex')
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
create or replace function public.rpc_manasakna_admin_role_set_v1(
  p_user_id uuid, p_role_key text, p_is_active boolean default true
) returns jsonb
language plpgsql security definer
set search_path = pg_catalog, manasakna, platform_access
as $$
declare v_id uuid;
begin
  perform manasakna.require_permission_v1('manage_roles');
  if not exists(select 1 from platform_access.admin_users where id=p_user_id and coalesce(is_active,false)) then
    raise exception 'MANASAKNA_TARGET_ADMIN_NOT_ACTIVE';
  end if;
  if p_role_key not in ('super_admin','operations_admin','lottery_manager','content_editor','viewer') then
    raise exception 'MANASAKNA_INVALID_ROLE';
  end if;
  insert into manasakna.admin_role_bindings(user_id,role_key,is_active,created_by)
  values (p_user_id,p_role_key,p_is_active,auth.uid())
  on conflict (user_id,role_key) do update set is_active=excluded.is_active
  returning id into v_id;
  perform manasakna.audit_v1('admin_role_set','admin_role_binding',v_id::text,null,
    jsonb_build_object('user_id',p_user_id,'role_key',p_role_key,'is_active',p_is_active));
  return jsonb_build_object('id',v_id,'user_id',p_user_id,'role_key',p_role_key,'is_active',p_is_active);
end;
$$;

create or replace function public.rpc_manasakna_content_v1(p_content_type text default null)
returns setof manasakna.content_items
language plpgsql stable security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query select * from manasakna.content_items
  where p_content_type is null or content_type=p_content_type
  order by updated_at desc;
end;
$$;

create or replace function public.rpc_manasakna_content_upsert_v1(p_payload jsonb)
returns manasakna.content_items
language plpgsql security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_id uuid := nullif(p_payload->>'id','')::uuid;
  v_season_id uuid := nullif(p_payload->>'season_id','')::uuid;
  v_row manasakna.content_items%rowtype;
begin
  perform manasakna.require_permission_v1('manage_content');
  if v_season_id is null and nullif(p_payload->>'season_code','') is not null then
    select id into v_season_id from manasakna.seasons
    where season_code=p_payload->>'season_code';
    if v_season_id is null then raise exception 'MANASAKNA_SEASON_NOT_FOUND'; end if;
  end if;
  if v_id is null then
    insert into manasakna.content_items(
      season_id,content_type,slug,title_ar,body_ar,metadata,status,published_at,created_by,updated_by
    ) values (
      v_season_id,p_payload->>'content_type',p_payload->>'slug',p_payload->>'title_ar',
      p_payload->>'body_ar',coalesce(p_payload->'metadata','{}'::jsonb),
      coalesce(nullif(p_payload->>'status',''),'draft'),
      case when p_payload->>'status'='published' then now() else null end,
      auth.uid(),auth.uid()
    ) returning * into v_row;
  else
    update manasakna.content_items c set
      season_id=case when p_payload ? 'season_id' or p_payload ? 'season_code' then v_season_id else c.season_id end,
      content_type=coalesce(nullif(p_payload->>'content_type',''),c.content_type),
      slug=coalesce(nullif(p_payload->>'slug',''),c.slug),
      title_ar=coalesce(nullif(p_payload->>'title_ar',''),c.title_ar),
      body_ar=case when p_payload ? 'body_ar' then p_payload->>'body_ar' else c.body_ar end,
      metadata=coalesce(p_payload->'metadata',c.metadata),
      status=coalesce(nullif(p_payload->>'status',''),c.status),
      published_at=case when coalesce(nullif(p_payload->>'status',''),c.status)='published'
        then coalesce(c.published_at,now()) else null end,
      updated_by=auth.uid()
    where c.id=v_id returning * into v_row;
  end if;
  perform manasakna.audit_v1('content_upsert','content_item',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;

create or replace function public.rpc_manasakna_notifications_v1()
returns setof manasakna.notifications
language plpgsql stable security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view');
  return query select * from manasakna.notifications order by created_at desc;
end;
$$;

create or replace function public.rpc_manasakna_notification_upsert_v1(p_payload jsonb)
returns manasakna.notifications
language plpgsql security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_id uuid := nullif(p_payload->>'id','')::uuid;
  v_season_id uuid := nullif(p_payload->>'season_id','')::uuid;
  v_row manasakna.notifications%rowtype;
begin
  perform manasakna.require_permission_v1('manage_notifications');
  if v_season_id is null and nullif(p_payload->>'season_code','') is not null then
    select id into v_season_id from manasakna.seasons
    where season_code=p_payload->>'season_code';
    if v_season_id is null then raise exception 'MANASAKNA_SEASON_NOT_FOUND'; end if;
  end if;
  if v_id is null then
    insert into manasakna.notifications(
      season_id,title_ar,body_ar,audience,status,scheduled_for,published_at,created_by,updated_by
    ) values (
      v_season_id,p_payload->>'title_ar',p_payload->>'body_ar',
      coalesce(p_payload->'audience','{"kind":"all"}'::jsonb),
      coalesce(nullif(p_payload->>'status',''),'draft'),
      nullif(p_payload->>'scheduled_for','')::timestamptz,
      case when p_payload->>'status'='published' then now() else null end,
      auth.uid(),auth.uid()
    ) returning * into v_row;
  else
    update manasakna.notifications n set
      season_id=case when p_payload ? 'season_id' or p_payload ? 'season_code' then v_season_id else n.season_id end,
      title_ar=coalesce(nullif(p_payload->>'title_ar',''),n.title_ar),
      body_ar=coalesce(nullif(p_payload->>'body_ar',''),n.body_ar),
      audience=coalesce(p_payload->'audience',n.audience),
      status=coalesce(nullif(p_payload->>'status',''),n.status),
      scheduled_for=case when p_payload ? 'scheduled_for'
        then nullif(p_payload->>'scheduled_for','')::timestamptz else n.scheduled_for end,
      published_at=case when coalesce(nullif(p_payload->>'status',''),n.status)='published'
        then coalesce(n.published_at,now()) else n.published_at end,
      updated_by=auth.uid()
    where n.id=v_id returning * into v_row;
  end if;
  perform manasakna.audit_v1('notification_upsert','notification',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;

create or replace function public.rpc_manasakna_audit_v1(p_limit integer default 100)
returns setof manasakna.audit_events
language plpgsql stable security definer
set search_path = pg_catalog, manasakna
as $$
begin
  perform manasakna.require_permission_v1('view_audit');
  return query select * from manasakna.audit_events order by created_at desc limit greatest(1,least(coalesce(p_limit,100),500));
end;
$$;
create or replace function public.rpc_manasakna_synthetic_e2e_v1()
returns jsonb
language plpgsql security definer
set search_path = pg_catalog, manasakna, public
as $$
declare
  v_fixture jsonb;
  v_season_id uuid;
  v_round_id uuid;
  v_selected_entry uuid;
  v_selected_ref text;
  v_waitlisted_entry uuid;
  v_waitlisted_ref text;
  v_ineligible_ref text;
  v_campaign_id uuid;
  v_group_id uuid;
  v_member_id uuid;
  v_a1 jsonb;
  v_a2 jsonb;
  v_a3 jsonb;
  v_activate jsonb;
  v_replay jsonb;
  v_selected_count integer;
  v_waitlisted_count integer;
  v_ineligible_count integer;
  v_revoked_count integer;
  v_consumed_count integer;
  v_active_count integer;
  v_member_status text;
  v_waitlisted_assign_rejected boolean := false;
  v_waitlisted_activation_rejected boolean := false;
  v_ineligible_activation_rejected boolean := false;
  v_suffix text := to_char(clock_timestamp(),'YYYYMMDDHH24MISSMS');
  v_pass boolean;
begin
  perform manasakna.require_permission_v1('manage_lottery');
  perform manasakna.require_permission_v1('manage_eligibility');
  perform manasakna.require_permission_v1('manage_campaigns');
  perform manasakna.require_permission_v1('manage_activation');
  v_fixture := public.rpc_manasakna_seed_synthetic_lottery_fixture_v1();
  v_season_id := (v_fixture->>'season_id')::uuid;
  v_round_id := (v_fixture->>'round_id')::uuid;

  select r.entry_id,e.applicant_ref
  into v_selected_entry,v_selected_ref
  from manasakna.lottery_results r
  join manasakna.lottery_entries e on e.id=r.entry_id
  where r.round_id=v_round_id and r.outcome='selected'
  order by r.rank_no limit 1;

  select r.entry_id,e.applicant_ref
  into v_waitlisted_entry,v_waitlisted_ref
  from manasakna.lottery_results r
  join manasakna.lottery_entries e on e.id=r.entry_id
  where r.round_id=v_round_id and r.outcome='waitlisted'
  order by r.rank_no limit 1;

  select e.applicant_ref
  into v_ineligible_ref
  from manasakna.lottery_results r
  join manasakna.lottery_entries e on e.id=r.entry_id
  where r.round_id=v_round_id and r.outcome='ineligible'
  order by e.applicant_ref limit 1;

  if v_selected_entry is null or v_waitlisted_entry is null or v_ineligible_ref is null then
    raise exception 'MANASAKNA_SYNTHETIC_E2E_FIXTURE_INCOMPLETE';
  end if;

  select id into v_campaign_id
  from public.rpc_manasakna_campaign_upsert_v1(jsonb_build_object(
    'season_id',v_season_id::text,'campaign_code','SYNTH-CAMP-'||v_suffix,
    'title_ar','حملة اصطناعية E2E','status','active'
  ));
  select id into v_group_id
  from public.rpc_manasakna_group_upsert_v1(jsonb_build_object(
    'campaign_id',v_campaign_id::text,'group_code','SYNTH-GROUP-01',
    'title_ar','مجموعة اصطناعية E2E','capacity',10,'status','active'
  ));

  select id into v_member_id
  from public.rpc_manasakna_group_member_assign_v1(v_group_id,v_selected_entry);

  begin
    perform public.rpc_manasakna_group_member_assign_v1(v_group_id,v_waitlisted_entry);
    v_waitlisted_assign_rejected := false;
  exception when others then
    v_waitlisted_assign_rejected := position('MANASAKNA_ONLY_SELECTED_PILGRIM_ASSIGNABLE' in sqlerrm) > 0;
  end;

  v_a1 := public.rpc_manasakna_issue_activation_v1(v_campaign_id,v_selected_ref,null);
  perform public.rpc_manasakna_activation_revoke_v1((v_a1->>'activation_id')::uuid);
  v_a2 := public.rpc_manasakna_issue_activation_v1(v_campaign_id,v_selected_ref,null);
  perform public.rpc_manasakna_activation_revoke_v1((v_a2->>'activation_id')::uuid);
  v_a3 := public.rpc_manasakna_issue_activation_v1(v_campaign_id,v_selected_ref,null);
  v_activate := public.rpc_manasakna_activate_v1(v_a3->>'token');
  v_replay := public.rpc_manasakna_activate_v1(v_a3->>'token');

  begin
    perform public.rpc_manasakna_issue_activation_v1(v_campaign_id,v_waitlisted_ref,null);
    v_waitlisted_activation_rejected := false;
  exception when others then
    v_waitlisted_activation_rejected :=
      position('MANASAKNA_ACTIVATION_REQUIRES_SELECTED_ASSIGNED_PILGRIM' in sqlerrm) > 0;
  end;
  begin
    perform public.rpc_manasakna_issue_activation_v1(v_campaign_id,v_ineligible_ref,null);
    v_ineligible_activation_rejected := false;
  exception when others then
    v_ineligible_activation_rejected :=
      position('MANASAKNA_ACTIVATION_REQUIRES_SELECTED_ASSIGNED_PILGRIM' in sqlerrm) > 0;
  end;

  select count(*) filter (where outcome='selected'),
         count(*) filter (where outcome='waitlisted'),
         count(*) filter (where outcome='ineligible')
  into v_selected_count,v_waitlisted_count,v_ineligible_count
  from manasakna.lottery_results where round_id=v_round_id;

  select count(*) filter (where status='revoked'),
         count(*) filter (where status='consumed'),
         count(*) filter (where status='active')
  into v_revoked_count,v_consumed_count,v_active_count
  from manasakna.activation_tokens
  where campaign_id=v_campaign_id and applicant_ref=v_selected_ref;

  select status into v_member_status
  from manasakna.group_members where id=v_member_id;

  v_pass := v_selected_count=5 and v_waitlisted_count=3 and v_ineligible_count=4
    and v_waitlisted_assign_rejected
    and v_waitlisted_activation_rejected
    and v_ineligible_activation_rejected
    and coalesce((v_activate->>'success')::boolean,false)
    and not coalesce((v_replay->>'success')::boolean,true)
    and v_revoked_count=2 and v_consumed_count=1 and v_active_count=0
    and v_member_status='activated';
  perform manasakna.audit_v1(
    'synthetic_e2e','synthetic_e2e',v_round_id::text,null,
    jsonb_build_object('pass',v_pass,'campaign_id',v_campaign_id,'group_id',v_group_id)
  );

  return jsonb_build_object(
    'pass',v_pass,
    'season_id',v_season_id,
    'round_id',v_round_id,
    'campaign_id',v_campaign_id,
    'group_id',v_group_id,
    'selected',v_selected_count,
    'waitlisted',v_waitlisted_count,
    'ineligible',v_ineligible_count,
    'waitlisted_assignment_rejected',v_waitlisted_assign_rejected,
    'waitlisted_activation_rejected',v_waitlisted_activation_rejected,
    'ineligible_activation_rejected',v_ineligible_activation_rejected,
    'selected_activation_success',coalesce((v_activate->>'success')::boolean,false),
    'activation_replay_rejected',not coalesce((v_replay->>'success')::boolean,true),
    'activation_history_revoked',v_revoked_count,
    'activation_history_consumed',v_consumed_count,
    'activation_history_active',v_active_count,
    'member_status',v_member_status,
    'real_data',false
  );
end;
$$;

-- V1 hard stop: no real pilgrim/lottery identities are accepted by this migration.
alter table manasakna.lottery_entries
  drop constraint if exists manasakna_lottery_entries_synthetic_only_v1;
alter table manasakna.lottery_entries
  add constraint manasakna_lottery_entries_synthetic_only_v1
  check (is_synthetic = true and applicant_ref like 'SYNTH-%');
alter table manasakna.group_members
  drop constraint if exists manasakna_group_members_synthetic_only_v1;
alter table manasakna.group_members
  add constraint manasakna_group_members_synthetic_only_v1
  check (applicant_ref like 'SYNTH-%');
alter table manasakna.activation_tokens
  drop constraint if exists manasakna_activation_tokens_synthetic_only_v1;
alter table manasakna.activation_tokens
  add constraint manasakna_activation_tokens_synthetic_only_v1
  check (applicant_ref like 'SYNTH-%');

create or replace function public.rpc_manasakna_public_content_v1(
  p_content_type text default null, p_season_code text default null
) returns table(
  content_type text,slug text,title_ar text,body_ar text,metadata jsonb,published_at timestamptz
)
language sql stable security definer
set search_path = pg_catalog, manasakna
as $$
  select c.content_type,c.slug,c.title_ar,c.body_ar,c.metadata,c.published_at
  from manasakna.content_items c
  left join manasakna.seasons s on s.id=c.season_id
  where c.status='published'
    and (p_content_type is null or c.content_type=p_content_type)
    and (p_season_code is null or s.season_code=p_season_code)
  order by c.content_type,c.slug;
$$;

create or replace function public.rpc_manasakna_public_notifications_v1(p_season_code text default null)
returns table(id uuid,title_ar text,body_ar text,audience jsonb,published_at timestamptz)
language sql stable security definer
set search_path = pg_catalog, manasakna
as $$
  select n.id,n.title_ar,n.body_ar,n.audience,n.published_at
  from manasakna.notifications n
  left join manasakna.seasons s on s.id=n.season_id
  where n.status='published' and n.published_at is not null
    and (p_season_code is null or s.season_code=p_season_code)
  order by n.published_at desc;
$$;

revoke execute on all functions in schema manasakna from public, anon, authenticated;

do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as signature
    from pg_proc p join pg_namespace n on n.oid=p.pronamespace
    where n.nspname='public' and p.proname like 'rpc_manasakna_%'
  loop
    execute format('revoke all on function %s from public, anon', r.signature);
    execute format('grant execute on function %s to authenticated', r.signature);
  end loop;
end;
$$;
grant execute on function public.rpc_manasakna_public_content_v1(text,text) to anon, authenticated;
grant execute on function public.rpc_manasakna_public_notifications_v1(text) to anon, authenticated;
grant execute on function public.rpc_manasakna_activate_v1(text) to anon, authenticated;

comment on schema manasakna is
  'Standalone Manasakna Admin/Operations V1. Synthetic data only; Nusuk, production, and real pilgrim data remain disabled.';
comment on function public.rpc_manasakna_run_lottery_v1(uuid,text) is
  'Auditable deterministic HASH_RANK_V1 lottery. Eligibility is explicit rule-check based; V1 data is synthetic only.';
comment on function public.rpc_manasakna_seed_synthetic_lottery_fixture_v1() is
  'Creates and executes a 12-case synthetic fixture: 8 eligible, 4 ineligible, capacity 5.';
