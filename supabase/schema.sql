-- UnitedHealthcare Sample Formulary 2025: one row per drug entry.
create table if not exists public.formulary_drugs (
  drug_id             text primary key,
  brand_name          text,
  generic_name        text not null,
  tier                smallint not null check (tier between 1 and 5),
  prior_authorization boolean not null,
  step_therapy        boolean not null,
  quantity_limit      text,          -- null = no quantity limit
  source_page         integer not null
);

create index if not exists formulary_drugs_brand_idx   on public.formulary_drugs (lower(brand_name));
create index if not exists formulary_drugs_generic_idx on public.formulary_drugs (lower(generic_name));

-- Read-only for the public API key; writes go through the database connection only.
alter table public.formulary_drugs enable row level security;
drop policy if exists "formulary is public read" on public.formulary_drugs;
create policy "formulary is public read" on public.formulary_drugs for select using (true);
