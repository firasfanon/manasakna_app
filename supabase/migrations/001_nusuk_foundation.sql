-- Nusuk Foundation Schema for PalWakf / Munasakna
-- ملاحظة: هذه migration تأسيسية قابلة للمراجعة قبل التشغيل على قاعدة الإنتاج.

create schema if not exists nusuk;

create extension if not exists pgcrypto;

-- مواسم الحج والعمرة
create table if not exists nusuk.seasons (
  id uuid primary key default gen_random_uuid(),
  season_code text not null unique,
  name_ar text not null,
  name_en text,
  season_type text not null check (season_type in ('hajj', 'umrah')),
  hijri_year integer,
  gregorian_year integer,
  starts_on date,
  ends_on date,
  status text not null default 'draft' check (status in ('draft', 'open', 'closed', 'archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- شركات/مزودو الخدمة
create table if not exists nusuk.companies (
  id uuid primary key default gen_random_uuid(),
  name_ar text not null,
  name_en text,
  license_no text,
  phone text,
  email text,
  address_ar text,
  status text not null default 'active' check (status in ('active', 'inactive', 'suspended')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- البرامج
create table if not exists nusuk.programs (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references nusuk.seasons(id) on delete restrict,
  company_id uuid references nusuk.companies(id) on delete set null,
  name_ar text not null,
  description_ar text,
  price numeric(12,2),
  currency text default 'JOD',
  capacity integer,
  status text not null default 'draft' check (status in ('draft', 'open', 'closed', 'archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- حسابات الحجاج/المعتمرين المرتبطة بالموبايل، ليست PlatformRole
create table if not exists nusuk.pilgrim_accounts (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique,
  national_id text not null unique,
  phone text,
  email text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ملف الحاج/المعتمر
create table if not exists nusuk.pilgrims (
  id uuid primary key default gen_random_uuid(),
  account_id uuid references nusuk.pilgrim_accounts(id) on delete set null,
  national_id text not null,
  full_name_ar text not null,
  full_name_en text,
  date_of_birth date,
  gender text check (gender in ('male', 'female')),
  phone text,
  emergency_phone text,
  address_ar text,
  passport_no text,
  passport_expiry date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(national_id)
);

-- الطلبات
create table if not exists nusuk.applications (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references nusuk.seasons(id) on delete restrict,
  pilgrim_id uuid not null references nusuk.pilgrims(id) on delete restrict,
  program_id uuid references nusuk.programs(id) on delete set null,
  application_no text not null unique,
  status text not null default 'submitted' check (status in (
    'draft', 'submitted', 'under_review', 'accepted', 'rejected',
    'needs_update', 'confirmed', 'paid', 'ready_to_travel',
    'departed', 'completed', 'cancelled'
  )),
  notes text,
  submitted_at timestamptz default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- الوثائق
create table if not exists nusuk.documents (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references nusuk.applications(id) on delete cascade,
  document_type text not null check (document_type in ('passport', 'photo', 'medical', 'payment', 'other')),
  file_path text,
  file_name text,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected', 'needs_update')),
  review_notes text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz
);

-- الدفعات
create table if not exists nusuk.payments (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references nusuk.applications(id) on delete cascade,
  amount numeric(12,2) not null default 0,
  currency text not null default 'JOD',
  payment_method text,
  payment_ref text,
  status text not null default 'pending' check (status in ('pending', 'verified', 'rejected', 'refunded')),
  paid_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- الشكاوى
create table if not exists nusuk.complaints (
  id uuid primary key default gen_random_uuid(),
  application_id uuid references nusuk.applications(id) on delete set null,
  pilgrim_id uuid references nusuk.pilgrims(id) on delete set null,
  category text not null default 'general',
  title text not null,
  body text not null,
  attachment_path text,
  status text not null default 'open' check (status in ('open', 'in_progress', 'resolved', 'closed', 'rejected')),
  response text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- الاستبيانات
create table if not exists nusuk.surveys (
  id uuid primary key default gen_random_uuid(),
  season_id uuid references nusuk.seasons(id) on delete set null,
  title_ar text not null,
  description_ar text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists nusuk.survey_responses (
  id uuid primary key default gen_random_uuid(),
  survey_id uuid not null references nusuk.surveys(id) on delete cascade,
  pilgrim_id uuid references nusuk.pilgrims(id) on delete set null,
  response_json jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- المحتوى الإرشادي والفتاوى والهواتف والروابط
create table if not exists nusuk.content_items (
  id uuid primary key default gen_random_uuid(),
  content_type text not null check (content_type in ('guidance', 'fatwa', 'useful_link', 'contact', 'notice')),
  title_ar text not null,
  body_ar text,
  url text,
  phone text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- البطاقة الرقمية
create table if not exists nusuk.digital_cards (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references nusuk.applications(id) on delete cascade,
  public_token text not null unique,
  expires_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

-- تسجيلات ميدانية
create table if not exists nusuk.field_checkins (
  id uuid primary key default gen_random_uuid(),
  application_id uuid references nusuk.applications(id) on delete set null,
  checked_by_admin_user_id uuid,
  checkin_type text not null default 'general',
  latitude double precision,
  longitude double precision,
  notes text,
  created_at timestamptz not null default now()
);

-- سجل تدقيق
create table if not exists nusuk.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_type text not null check (actor_type in ('pilgrim', 'admin', 'system')),
  actor_id uuid,
  action text not null,
  entity_table text,
  entity_id uuid,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- RLS baseline
alter table nusuk.seasons enable row level security;
alter table nusuk.companies enable row level security;
alter table nusuk.programs enable row level security;
alter table nusuk.pilgrim_accounts enable row level security;
alter table nusuk.pilgrims enable row level security;
alter table nusuk.applications enable row level security;
alter table nusuk.documents enable row level security;
alter table nusuk.payments enable row level security;
alter table nusuk.complaints enable row level security;
alter table nusuk.surveys enable row level security;
alter table nusuk.survey_responses enable row level security;
alter table nusuk.content_items enable row level security;
alter table nusuk.digital_cards enable row level security;
alter table nusuk.field_checkins enable row level security;
alter table nusuk.audit_logs enable row level security;

-- Public read policies for active guidance content only.
drop policy if exists nusuk_content_public_read_active on nusuk.content_items;
create policy nusuk_content_public_read_active
on nusuk.content_items
for select
using (is_active = true);

drop policy if exists nusuk_surveys_public_read_active on nusuk.surveys;
create policy nusuk_surveys_public_read_active
on nusuk.surveys
for select
using (is_active = true);

-- Pilgrim can read their own account profile if linked to auth.uid().
drop policy if exists nusuk_pilgrim_accounts_own_read on nusuk.pilgrim_accounts;
create policy nusuk_pilgrim_accounts_own_read
on nusuk.pilgrim_accounts
for select
using (auth_user_id = auth.uid());

drop policy if exists nusuk_pilgrims_own_read on nusuk.pilgrims;
create policy nusuk_pilgrims_own_read
on nusuk.pilgrims
for select
using (
  account_id in (
    select id from nusuk.pilgrim_accounts where auth_user_id = auth.uid()
  )
);

drop policy if exists nusuk_applications_own_read on nusuk.applications;
create policy nusuk_applications_own_read
on nusuk.applications
for select
using (
  pilgrim_id in (
    select p.id
    from nusuk.pilgrims p
    join nusuk.pilgrim_accounts a on a.id = p.account_id
    where a.auth_user_id = auth.uid()
  )
);

drop policy if exists nusuk_complaints_own_insert on nusuk.complaints;
create policy nusuk_complaints_own_insert
on nusuk.complaints
for insert
with check (
  pilgrim_id in (
    select p.id
    from nusuk.pilgrims p
    join nusuk.pilgrim_accounts a on a.id = p.account_id
    where a.auth_user_id = auth.uid()
  )
);

-- RPC wrappers: read current user's latest application.
create or replace function public.rpc_munasakna_my_latest_application_v1()
returns table (
  application_id uuid,
  application_no text,
  status text,
  pilgrim_name_ar text,
  season_name_ar text,
  program_name_ar text
)
language sql
security definer
set search_path = public, nusuk
as $$
  select
    a.id,
    a.application_no,
    a.status,
    p.full_name_ar,
    s.name_ar,
    pr.name_ar
  from nusuk.applications a
  join nusuk.pilgrims p on p.id = a.pilgrim_id
  join nusuk.pilgrim_accounts pa on pa.id = p.account_id
  join nusuk.seasons s on s.id = a.season_id
  left join nusuk.programs pr on pr.id = a.program_id
  where pa.auth_user_id = auth.uid()
  order by a.created_at desc
  limit 1;
$$;
