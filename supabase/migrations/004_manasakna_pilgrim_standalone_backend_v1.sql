-- Manasakna Pilgrim Standalone Backend V1.
-- Repository-first, synthetic data only. No Nusuk, real pilgrim data, or production authorization.

create table if not exists manasakna.campaign_operational_packs (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null unique references manasakna.campaign_groups(id) on delete cascade,
  schema_version integer not null default 1 check (schema_version = 1),
  status text not null default 'draft' check (status in ('draft','published','archived')),
  supervisor jsonb,
  hotel_name_ar text,
  hotel_address_ar text,
  transport_label_ar text,
  mina_camp_ar text,
  arafat_camp_ar text,
  meeting_points jsonb not null default '[]'::jsonb,
  schedule jsonb not null default '[]'::jsonb,
  emergency_contacts jsonb not null default '[]'::jsonb,
  source_revision text not null,
  provenance_reference text not null,
  issued_at timestamptz not null default now(),
  expires_at timestamptz,
  update_sequence integer not null default 1 check (update_sequence > 0),
  integrity_digest text,
  signature_reference text,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (source_revision like 'synthetic-%'),
  check (provenance_reference like 'synthetic://%')
);

create table if not exists manasakna.pilgrim_sessions (
  id uuid primary key default gen_random_uuid(),
  group_member_id uuid not null references manasakna.group_members(id) on delete cascade,
  activation_id uuid references manasakna.activation_tokens(id) on delete set null,
  session_token_hash text not null unique,
  token_hint text not null,
  status text not null default 'active' check (status in ('active','revoked','expired')),
  issued_at timestamptz not null default now(),
  expires_at timestamptz not null,
  last_validated_at timestamptz,
  revoked_at timestamptz,
  check (expires_at > issued_at)
);

create unique index if not exists manasakna_pilgrim_sessions_one_active_per_member_idx
on manasakna.pilgrim_sessions(group_member_id)
where status='active';

create index if not exists manasakna_pilgrim_sessions_hash_idx
on manasakna.pilgrim_sessions(session_token_hash);

create or replace trigger manasakna_operational_packs_updated_at
before update on manasakna.campaign_operational_packs
for each row execute function manasakna.set_updated_at_v1();

alter table manasakna.campaign_operational_packs enable row level security;
alter table manasakna.pilgrim_sessions enable row level security;
revoke all on manasakna.campaign_operational_packs from public, anon, authenticated;
revoke all on manasakna.pilgrim_sessions from public, anon, authenticated;

create or replace function manasakna.pilgrim_context_v1(p_group_member_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v record;
  v_pack manasakna.campaign_operational_packs%rowtype;
  v_digest text;
  v_source_authority constant text := 'manasakna.standalone.synthetic';
begin
  select gm.id member_id, gm.applicant_ref,
    coalesce(nullif(gm.display_name,''),nullif(e.display_name,''),'حاج تجريبي') display_name,
    g.id group_id,g.group_code,g.title_ar group_title,
    c.id campaign_id,c.campaign_code,c.title_ar campaign_title,c.updated_at campaign_updated_at,
    s.id season_id,s.season_code,s.title_ar season_title,s.status season_status,
    s.hijri_year,s.gregorian_year,s.settings,
    e.id entry_id,lres.created_at result_created_at
  into v
  from manasakna.group_members gm
  join manasakna.campaign_groups g on g.id=gm.group_id
  join manasakna.campaigns c on c.id=g.campaign_id
  join manasakna.seasons s on s.id=c.season_id
  join manasakna.lottery_entries e on e.id=gm.lottery_entry_id
  join manasakna.lottery_rounds lr on lr.id=e.round_id and lr.season_id=s.id
  join manasakna.lottery_results lres on lres.round_id=lr.id and lres.entry_id=e.id
  where gm.id=p_group_member_id and gm.status in ('assigned','activated')
    and g.status in ('draft','active') and c.status in ('draft','active')
    and e.is_synthetic=true and e.applicant_ref like 'SYNTH-%'
    and lres.outcome='selected'
  limit 1;
  if not found then return null; end if;

  select * into v_pack
  from manasakna.campaign_operational_packs
  where group_id=v.group_id and status='published'
    and issued_at <= now() and (expires_at is null or expires_at > now());
  if not found then return null; end if;

  v_digest := coalesce(
    nullif(v_pack.integrity_digest,''),
    encode(extensions.digest(
      jsonb_build_object(
        'group_id',v_pack.group_id,'schema_version',v_pack.schema_version,
        'supervisor',v_pack.supervisor,'hotel_name_ar',v_pack.hotel_name_ar,
        'hotel_address_ar',v_pack.hotel_address_ar,'transport_label_ar',v_pack.transport_label_ar,
        'mina_camp_ar',v_pack.mina_camp_ar,'arafat_camp_ar',v_pack.arafat_camp_ar,
        'meeting_points',v_pack.meeting_points,'schedule',v_pack.schedule,
        'emergency_contacts',v_pack.emergency_contacts,'source_revision',v_pack.source_revision,
        'update_sequence',v_pack.update_sequence
      )::text,'sha256'
    ),'hex')
  );

  return jsonb_build_object(
    'realData',false,
    'season',jsonb_build_object(
      'id',v.season_id,'seasonCode',v.season_code,'titleAr',v.season_title,
      'status',v.season_status,'hijriYear',v.hijri_year,'gregorianYear',v.gregorian_year,
      'settings',v.settings
    ),
    'campaign',jsonb_build_object(
      'id',v.campaign_id,'campaignCode',v.campaign_code,'titleAr',v.campaign_title
    ),
    'group',jsonb_build_object(
      'id',v.group_id,'groupCode',v.group_code,'titleAr',v.group_title
    ),
    'profile',jsonb_build_object(
      'officialReference',v.applicant_ref,
      'fullNameAr',v.display_name,
      'acceptanceStatus','approved',
      'sourceAuthority',v_source_authority,
      'sourceRevision','synthetic-standalone-pilgrim-r1',
      'effectiveAt',v.result_created_at,
      'campaignReference',v.campaign_code,
      'groupReference',v.group_code,
      'contractMetadata',jsonb_build_object(
        'contractVersion','official-pilgrim-seed.v1',
        'authorityModel','OFFICIAL_HAJJ_SYSTEM',
        'sourceAuthority',v_source_authority,
        'sourceRevision','synthetic-standalone-pilgrim-r1',
        'provenanceReference','synthetic://manasakna/pilgrim/'||v.member_id::text,
        'dataClass','syntheticFixture',
        'approvalState','approvedForFixtureUse',
        'issuedAt',least(v.result_created_at,now()),
        'expiresAt',null,
        'revoked',false,
        'updateSequence',1
      )
    ),
    'operationalPack',jsonb_build_object(
      'packId',v_pack.id::text,
      'schemaVersion',v_pack.schema_version,
      'campaignReference',v.campaign_code,
      'campaignNameAr',v.campaign_title,
      'updatedAt',v_pack.updated_at,
      'groupReference',v.group_code,
      'supervisor',v_pack.supervisor,
      'hotelNameAr',v_pack.hotel_name_ar,
      'hotelAddressAr',v_pack.hotel_address_ar,
      'transportLabelAr',v_pack.transport_label_ar,
      'minaCampAr',v_pack.mina_camp_ar,
      'arafatCampAr',v_pack.arafat_camp_ar,
      'meetingPoints',v_pack.meeting_points,
      'schedule',v_pack.schedule,
      'emergencyContacts',v_pack.emergency_contacts,
      'contractMetadata',jsonb_build_object(
        'contractVersion','campaign-operational-pack.v1',
        'authorityModel','OFFICIAL_HAJJ_SYSTEM',
        'sourceAuthority',v_source_authority,
        'sourceRevision',v_pack.source_revision,
        'provenanceReference',v_pack.provenance_reference,
        'dataClass','syntheticFixture',
        'approvalState','approvedForFixtureUse',
        'issuedAt',v_pack.issued_at,
        'expiresAt',v_pack.expires_at,
        'revoked',false,
        'updateSequence',v_pack.update_sequence,
        'integrityAlgorithm','SHA-256',
        'integrityDigest',v_digest,
        'signatureReference',coalesce(
          nullif(v_pack.signature_reference,''),
          'synthetic://manasakna/signature/operational-pack/'||v_pack.id::text
        )
      )
    )
  );
end;
$$;

create or replace function public.rpc_manasakna_public_current_season_v1()
returns jsonb
language sql
stable
security definer
set search_path = pg_catalog, manasakna
as $$
  select coalesce((
    select jsonb_build_object(
      'id',s.id,'seasonCode',s.season_code,'titleAr',s.title_ar,
      'titleEn',s.title_en,'hijriYear',s.hijri_year,'gregorianYear',s.gregorian_year,
      'status',s.status,'settings',s.settings,
      'operationsStartAt',s.operations_start_at,'operationsEndAt',s.operations_end_at
    )
    from manasakna.seasons s
    where s.status not in ('closed','archived')
    order by case s.status when 'operations' then 1 when 'lottery' then 2
      when 'registration_open' then 3 when 'registration_closed' then 4 else 5 end,
      s.updated_at desc
    limit 1
  ),'null'::jsonb);
$$;

create or replace function public.rpc_manasakna_operational_pack_upsert_v1(p_payload jsonb)
returns manasakna.campaign_operational_packs
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_group_id uuid := nullif(p_payload->>'group_id','')::uuid;
  v_row manasakna.campaign_operational_packs%rowtype;
  v_source_revision text := coalesce(nullif(p_payload->>'source_revision',''),'synthetic-admin-r1');
  v_provenance text := coalesce(nullif(p_payload->>'provenance_reference',''),
    'synthetic://manasakna/admin/operational-pack/'||v_group_id::text);
begin
  perform manasakna.require_permission_v1('manage_campaigns');
  if v_group_id is null then raise exception 'MANASAKNA_GROUP_REQUIRED'; end if;
  if v_source_revision not like 'synthetic-%' or v_provenance not like 'synthetic://%' then
    raise exception 'MANASAKNA_V1_SYNTHETIC_ONLY';
  end if;

  insert into manasakna.campaign_operational_packs(
    group_id,status,supervisor,hotel_name_ar,hotel_address_ar,transport_label_ar,
    mina_camp_ar,arafat_camp_ar,meeting_points,schedule,emergency_contacts,
    source_revision,provenance_reference,issued_at,expires_at,update_sequence,
    integrity_digest,signature_reference,created_by,updated_by
  ) values (
    v_group_id,coalesce(nullif(p_payload->>'status',''),'draft'),p_payload->'supervisor',
    p_payload->>'hotel_name_ar',p_payload->>'hotel_address_ar',p_payload->>'transport_label_ar',
    p_payload->>'mina_camp_ar',p_payload->>'arafat_camp_ar',
    coalesce(p_payload->'meeting_points','[]'::jsonb),coalesce(p_payload->'schedule','[]'::jsonb),
    coalesce(p_payload->'emergency_contacts','[]'::jsonb),v_source_revision,v_provenance,
    coalesce(nullif(p_payload->>'issued_at','')::timestamptz,now()),
    nullif(p_payload->>'expires_at','')::timestamptz,
    coalesce(nullif(p_payload->>'update_sequence','')::integer,1),
    nullif(p_payload->>'integrity_digest',''),nullif(p_payload->>'signature_reference',''),
    auth.uid(),auth.uid()
  )
  on conflict (group_id) do update set
    status=excluded.status,supervisor=excluded.supervisor,hotel_name_ar=excluded.hotel_name_ar,
    hotel_address_ar=excluded.hotel_address_ar,transport_label_ar=excluded.transport_label_ar,
    mina_camp_ar=excluded.mina_camp_ar,arafat_camp_ar=excluded.arafat_camp_ar,
    meeting_points=excluded.meeting_points,schedule=excluded.schedule,
    emergency_contacts=excluded.emergency_contacts,source_revision=excluded.source_revision,
    provenance_reference=excluded.provenance_reference,issued_at=excluded.issued_at,
    expires_at=excluded.expires_at,update_sequence=excluded.update_sequence,
    integrity_digest=excluded.integrity_digest,signature_reference=excluded.signature_reference,
    updated_by=auth.uid()
  returning * into v_row;
  perform manasakna.audit_v1('operational_pack_upsert','campaign_operational_pack',v_row.id::text,null,to_jsonb(v_row));
  return v_row;
end;
$$;

create or replace function public.rpc_manasakna_activate_pilgrim_v2(p_token text)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_activation manasakna.activation_tokens%rowtype;
  v_member_id uuid;
  v_session_token text;
  v_session_hash text;
  v_session_id uuid;
  v_session_expires_at timestamptz;
  v_context jsonb;
begin
  if nullif(trim(p_token),'') is null then
    return jsonb_build_object('success',false,'code','TOKEN_REQUIRED');
  end if;

  select * into v_activation
  from manasakna.activation_tokens
  where token_hash=encode(extensions.digest(trim(p_token),'sha256'),'hex')
    and status='active'
    and (expires_at is null or expires_at > now())
  for update;
  if not found then
    return jsonb_build_object('success',false,'code','INVALID_OR_EXPIRED');
  end if;

  select gm.id into v_member_id
  from manasakna.group_members gm
  join manasakna.campaign_groups g on g.id=gm.group_id
  where g.campaign_id=v_activation.campaign_id
    and gm.applicant_ref=v_activation.applicant_ref
    and gm.status in ('assigned','activated')
  limit 1;
  if v_member_id is null then
    return jsonb_build_object('success',false,'code','NOT_CURRENTLY_ELIGIBLE');
  end if;

  v_context := manasakna.pilgrim_context_v1(v_member_id);
  if v_context is null then
    return jsonb_build_object('success',false,'code','OPERATIONAL_CONTEXT_UNAVAILABLE');
  end if;

  update manasakna.activation_tokens
  set status='consumed',consumed_at=now()
  where id=v_activation.id;

  update manasakna.group_members
  set status='activated'
  where id=v_member_id and status='assigned';

  update manasakna.pilgrim_sessions
  set status='revoked',revoked_at=now()
  where group_member_id=v_member_id and status='active';

  v_session_token := encode(extensions.gen_random_bytes(32),'hex');
  v_session_hash := encode(extensions.digest(v_session_token,'sha256'),'hex');
  v_session_expires_at := least(
    coalesce(v_activation.expires_at,now()+interval '90 days'),
    now()+interval '90 days'
  );

  insert into manasakna.pilgrim_sessions(
    group_member_id,activation_id,session_token_hash,token_hint,expires_at,last_validated_at
  ) values (
    v_member_id,v_activation.id,v_session_hash,left(v_session_token,8)||'…',
    v_session_expires_at,now()
  ) returning id into v_session_id;

  perform manasakna.audit_v1(
    'pilgrim_session_activate','pilgrim_session',v_session_id::text,null,
    jsonb_build_object(
      'group_member_id',v_member_id,'activation_id',v_activation.id,
      'real_data',false
    )
  );

  return v_context || jsonb_build_object(
    'success',true,
    'sessionId',v_session_id,
    'sessionToken',v_session_token,
    'sessionExpiresAt',v_session_expires_at
  );
end;
$$;

create or replace function public.rpc_manasakna_pilgrim_session_context_v1(p_session_token text)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare
  v_session manasakna.pilgrim_sessions%rowtype;
  v_context jsonb;
begin
  if nullif(trim(p_session_token),'') is null then
    return jsonb_build_object('success',false,'code','SESSION_TOKEN_REQUIRED');
  end if;
  select * into v_session
  from manasakna.pilgrim_sessions
  where session_token_hash=encode(extensions.digest(trim(p_session_token),'sha256'),'hex')
    and status='active'
  for update;

  if not found then
    return jsonb_build_object('success',false,'code','SESSION_INVALID');
  end if;

  if v_session.expires_at <= now() then
    update manasakna.pilgrim_sessions
    set status='expired'
    where id=v_session.id;
    return jsonb_build_object('success',false,'code','SESSION_EXPIRED');
  end if;

  v_context := manasakna.pilgrim_context_v1(v_session.group_member_id);
  if v_context is null then
    update manasakna.pilgrim_sessions
    set status='revoked',revoked_at=now()
    where id=v_session.id;
    return jsonb_build_object('success',false,'code','NOT_CURRENTLY_ELIGIBLE');
  end if;

  update manasakna.pilgrim_sessions
  set last_validated_at=now()
  where id=v_session.id;

  return v_context || jsonb_build_object(
    'success',true,
    'sessionId',v_session.id,
    'sessionExpiresAt',v_session.expires_at
  );
end;
$$;

create or replace function public.rpc_manasakna_revoke_pilgrim_session_v1(p_group_member_id uuid)
returns integer
language plpgsql
security definer
set search_path = pg_catalog, manasakna
as $$
declare v_changed integer;
begin
  perform manasakna.require_permission_v1('manage_activation');
  update manasakna.pilgrim_sessions
  set status='revoked',revoked_at=now()
  where group_member_id=p_group_member_id and status='active';
  get diagnostics v_changed = row_count;
  if v_changed > 0 then
    perform manasakna.audit_v1(
      'pilgrim_session_revoke','group_member',p_group_member_id::text,null,
      jsonb_build_object('revoked_sessions',v_changed)
    );
  end if;
  return v_changed;
end;
$$;

create or replace function public.rpc_manasakna_seed_pilgrim_backend_fixture_v1()
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, manasakna, public
as $$
declare
  v_suffix text := to_char(clock_timestamp(),'YYYYMMDDHH24MISSMS');
  v_fixture jsonb;
  v_season_id uuid;
  v_round_id uuid;
  v_season_code text;
  v_entry_id uuid;
  v_applicant_ref text;
  v_display_name text;
  v_campaign_id uuid;
  v_group_id uuid;
  v_member_id uuid;
  v_activation jsonb;
begin
  perform manasakna.require_permission_v1('manage_lottery');
  perform manasakna.require_permission_v1('manage_eligibility');
  perform manasakna.require_permission_v1('manage_campaigns');
  perform manasakna.require_permission_v1('manage_activation');
  perform manasakna.require_permission_v1('manage_content');
  perform manasakna.require_permission_v1('manage_notifications');

  v_fixture := public.rpc_manasakna_seed_synthetic_lottery_fixture_v1();
  v_season_id := (v_fixture->>'season_id')::uuid;
  v_round_id := (v_fixture->>'round_id')::uuid;

  update manasakna.seasons
  set title_ar='موسم مناسكنا 1448 — E2E اصطناعي',status='operations',updated_by=auth.uid()
  where id=v_season_id
  returning season_code into v_season_code;

  select e.id,e.applicant_ref,e.display_name
  into v_entry_id,v_applicant_ref,v_display_name
  from manasakna.lottery_results r
  join manasakna.lottery_entries e on e.id=r.entry_id
  where r.round_id=v_round_id and r.outcome='selected'
  order by r.rank_no nulls last,e.applicant_ref
  limit 1;

  insert into manasakna.campaigns(
    season_id,campaign_code,title_ar,description_ar,status,created_by,updated_by
  ) values (
    v_season_id,'SYNTH-PILGRIM-'||v_suffix,'حملة مناسكنا التجريبية',
    'حملة اصطناعية لاختبار ربط تطبيق الحاج','active',auth.uid(),auth.uid()
  ) returning id into v_campaign_id;

  insert into manasakna.campaign_groups(
    campaign_id,group_code,title_ar,capacity,supervisor_label,status,created_by,updated_by
  ) values (
    v_campaign_id,'SYNTH-GROUP-A-'||v_suffix,'المجموعة التجريبية A',50,
    'مشرف تجريبي','active',auth.uid(),auth.uid()
  ) returning id into v_group_id;

  insert into manasakna.group_members(
    group_id,lottery_entry_id,applicant_ref,display_name,status,created_by
  ) values (
    v_group_id,v_entry_id,v_applicant_ref,v_display_name,'assigned',auth.uid()
  ) returning id into v_member_id;

  insert into manasakna.campaign_operational_packs(
    group_id,status,supervisor,hotel_name_ar,hotel_address_ar,transport_label_ar,
    mina_camp_ar,arafat_camp_ar,meeting_points,schedule,emergency_contacts,
    source_revision,provenance_reference,issued_at,expires_at,signature_reference,
    created_by,updated_by
  ) values (
    v_group_id,'published',
    jsonb_build_object('roleAr','مشرف المجموعة','nameAr','مشرف تجريبي','phone','+0000001000'),
    'سكن مناسكنا التجريبي — مكة','عنوان اصطناعي للاختبار',
    'حافلة المجموعة A — تجريبية','مخيم منى التجريبي A','مخيم عرفات التجريبي A',
    jsonb_build_array(
      jsonb_build_object('id','hotel-lobby','labelAr','ردهة السكن','descriptionAr','نقطة تجمع تجريبية','latitude',21.4225,'longitude',39.8262),
      jsonb_build_object('id','bus-zone','labelAr','منطقة الحافلة','descriptionAr','نقطة تحرك تجريبية','latitude',21.4187,'longitude',39.8253)
    ),
    jsonb_build_array(
      jsonb_build_object('id','orientation','titleAr','لقاء المجموعة التعريفي','startsAt',(now()+interval '2 hours'),'endsAt',(now()+interval '3 hours'),'meetingPointId','hotel-lobby','notesAr','موعد اصطناعي'),
      jsonb_build_object('id','movement','titleAr','الاستعداد للتحرك','startsAt',(now()+interval '1 day'),'meetingPointId','bus-zone','notesAr','تحقق من تحديث الحملة')
    ),
    jsonb_build_array(
      jsonb_build_object('roleAr','طوارئ الحملة','nameAr','اتصال تجريبي','phone','+0000001001'),
      jsonb_build_object('roleAr','دعم المجموعة','nameAr','مساندة تجريبية','phone','+0000001002')
    ),
    'synthetic-pilgrim-backend-r1','synthetic://manasakna/pilgrim-backend/'||v_group_id::text,
    now(),now()+interval '90 days',
    'synthetic://manasakna/signature/pilgrim-backend/'||v_group_id::text,
    auth.uid(),auth.uid()
  );

  insert into manasakna.content_items(
    season_id,content_type,slug,title_ar,body_ar,metadata,status,published_at,created_by,updated_by
  ) values
    (v_season_id,'guidance','pilgrim-e2e-guidance-'||v_suffix,
      'إرشاد موسمي تجريبي','هذا محتوى منشور من لوحة مناسكنا المستقلة لاختبار تطبيق الحاج.',
      jsonb_build_object('phase','E2E','tags',jsonb_build_array('تجريبي','موسم 1448')),
      'published',now(),auth.uid(),auth.uid()),
    (v_season_id,'fatwa','pilgrim-e2e-fatwa-'||v_suffix,
      'سؤال شرعي تجريبي','هذه مادة إرشادية اصطناعية وليست فتوى حقيقية؛ تُستخدم فقط لإثبات مسار النشر.',
      jsonb_build_object('category','اختبار','critical',false,'sourceAuthority','synthetic'),
      'published',now(),auth.uid(),auth.uid()),
    (v_season_id,'service','pilgrim-e2e-service-season-'||v_suffix,
      'رحلتي 1448','الدخول إلى سياق الرحلة المرتبط بالحملة.',
      jsonb_build_object('route','/season-1448','order',10,'gold',true,'enabled',true),
      'published',now(),auth.uid(),auth.uid()),
    (v_season_id,'service','pilgrim-e2e-service-fatwa-'||v_suffix,
      'اللجنة الشرعية والفتاوى','المحتوى الشرعي المنشور من الإدارة.',
      jsonb_build_object('route','/fatwa','order',20,'gold',false,'enabled',true),
      'published',now(),auth.uid(),auth.uid()),
    (v_season_id,'service','pilgrim-e2e-service-notifications-'||v_suffix,
      'الإشعارات والتنبيهات','تنبيهات الموسم المنشورة من الإدارة.',
      jsonb_build_object('route','/notifications','order',30,'gold',true,'enabled',true),
      'published',now(),auth.uid(),auth.uid());

  insert into manasakna.notifications(
    season_id,title_ar,body_ar,audience,status,published_at,created_by,updated_by
  ) values (
    v_season_id,'تنبيه موسم 1448 التجريبي',
    'تنبيه اصطناعي منشور من Backend لاختبار وصوله إلى تطبيق الحاج.',
    jsonb_build_object('kind','all','synthetic',true),
    'published',now(),auth.uid(),auth.uid()
  );

  v_activation := public.rpc_manasakna_issue_activation_v1(
    v_campaign_id,v_applicant_ref,now()+interval '7 days'
  );

  perform manasakna.audit_v1(
    'pilgrim_backend_fixture_create','group_member',v_member_id::text,null,
    jsonb_build_object('season_id',v_season_id,'campaign_id',v_campaign_id,'real_data',false)
  );

  return jsonb_build_object(
    'season_id',v_season_id,'season_code',v_season_code,'round_id',v_round_id,
    'campaign_id',v_campaign_id,'group_id',v_group_id,'group_member_id',v_member_id,
    'applicant_ref',v_applicant_ref,'activation_token',v_activation->>'token',
    'activation_id',v_activation->>'activation_id','real_data',false
  );
end;
$$;

revoke all on function manasakna.pilgrim_context_v1(uuid) from public, anon, authenticated;
revoke all on function public.rpc_manasakna_public_current_season_v1() from public, anon, authenticated;
revoke all on function public.rpc_manasakna_operational_pack_upsert_v1(jsonb) from public, anon, authenticated;
revoke all on function public.rpc_manasakna_activate_pilgrim_v2(text) from public, anon, authenticated;
revoke all on function public.rpc_manasakna_pilgrim_session_context_v1(text) from public, anon, authenticated;
revoke all on function public.rpc_manasakna_revoke_pilgrim_session_v1(uuid) from public, anon, authenticated;
revoke all on function public.rpc_manasakna_seed_pilgrim_backend_fixture_v1() from public, anon, authenticated;

grant execute on function public.rpc_manasakna_public_current_season_v1() to anon, authenticated;
grant execute on function public.rpc_manasakna_activate_pilgrim_v2(text) to anon, authenticated;
grant execute on function public.rpc_manasakna_pilgrim_session_context_v1(text) to anon, authenticated;
grant execute on function public.rpc_manasakna_operational_pack_upsert_v1(jsonb) to authenticated;
grant execute on function public.rpc_manasakna_revoke_pilgrim_session_v1(uuid) to authenticated;
grant execute on function public.rpc_manasakna_seed_pilgrim_backend_fixture_v1() to authenticated;

comment on table manasakna.campaign_operational_packs is
  'Synthetic-only operational packs for standalone Manasakna Pilgrim Backend V1.';
comment on table manasakna.pilgrim_sessions is
  'Opaque synthetic pilgrim sessions issued after single-use activation. Real pilgrim data remains prohibited.';
comment on function public.rpc_manasakna_activate_pilgrim_v2(text) is
  'Consumes a synthetic activation token and returns a bounded standalone pilgrim session plus governed profile/campaign context.';
comment on function public.rpc_manasakna_pilgrim_session_context_v1(text) is
  'Revalidates current eligibility/campaign/group/operational-pack context for an existing synthetic pilgrim session.';
comment on function public.rpc_manasakna_seed_pilgrim_backend_fixture_v1() is
  'Creates a full synthetic season→lottery→campaign/group→operational pack→activation fixture for controlled pilgrim E2E only.';
