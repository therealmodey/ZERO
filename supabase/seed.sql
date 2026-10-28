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

insert into public.formulary_drugs
  (drug_id, brand_name, generic_name, tier, prior_authorization, step_therapy, quantity_limit, source_page)
values
  ('UHC-F25-0001', 'Breo Ellipta', 'fluticasone furoate/vilanterol', 3, false, false, '1 inhaler (30 blisters) per 30 days', 12),
  ('UHC-F25-0002', 'Breo Ellipta', 'fluticasone furoate/vilanterol', 3, false, false, '1 inhaler (30 blisters) per 30 days', 12),
  ('UHC-F25-0003', 'Symbicort', 'budesonide/formoterol', 3, false, false, '1 inhaler (10.2 g, 120 actuations) per 30 days', 13),
  ('UHC-F25-0004', 'Breyna', 'budesonide/formoterol', 2, false, false, '1 inhaler (10.2 g, 120 actuations) per 30 days', 13),
  ('UHC-F25-0005', 'Advair Diskus', 'fluticasone propionate/salmeterol', 4, false, true, '1 inhaler (60 blisters) per 30 days', 14),
  ('UHC-F25-0006', 'Wixela Inhub', 'fluticasone propionate/salmeterol', 2, false, false, '1 inhaler (60 blisters) per 30 days', 14),
  ('UHC-F25-0007', 'Trelegy Ellipta', 'fluticasone furoate/umeclidinium/vilanterol', 3, false, true, '1 inhaler (30 blisters) per 30 days', 15),
  ('UHC-F25-0008', 'Dulera', 'mometasone furoate/formoterol', 4, false, true, '1 inhaler (120 actuations) per 30 days', 15),
  ('UHC-F25-0009', 'ProAir HFA', 'albuterol sulfate', 3, false, false, '2 inhalers (8.5 g each) per 30 days', 16),
  ('UHC-F25-0010', 'Ventolin HFA', 'albuterol sulfate', 3, false, false, '2 inhalers (18 g each) per 30 days', 16),
  ('UHC-F25-0011', null, 'albuterol sulfate', 1, false, false, '2 inhalers per 30 days', 16),
  ('UHC-F25-0012', 'Xopenex HFA', 'levalbuterol tartrate', 4, false, true, '2 inhalers per 30 days', 17),
  ('UHC-F25-0013', null, 'levalbuterol tartrate', 2, false, false, null, 17),
  ('UHC-F25-0014', null, 'tiotropium bromide', 2, false, false, '30 capsules per 30 days', 18),
  ('UHC-F25-0015', 'Spiriva Respimat', 'tiotropium bromide', 3, false, false, '1 cartridge (60 actuations) per 30 days', 18),
  ('UHC-F25-0016', 'Anoro Ellipta', 'umeclidinium/vilanterol', 3, false, false, '1 inhaler (30 blisters) per 30 days', 19),
  ('UHC-F25-0017', 'Incruse Ellipta', 'umeclidinium', 4, false, false, null, 19),
  ('UHC-F25-0018', 'Serevent Diskus', 'salmeterol xinafoate', 4, false, false, null, 20),
  ('UHC-F25-0019', 'Ozempic', 'semaglutide', 3, true, false, '1 pen (3 mL) per 28 days', 21),
  ('UHC-F25-0020', 'Ozempic', 'semaglutide', 3, true, false, '1 pen (3 mL) per 28 days, maximum 2 mg per week', 21),
  ('UHC-F25-0021', 'Trulicity', 'dulaglutide', 3, true, false, '4 pens (2 mL) per 28 days', 22),
  ('UHC-F25-0022', 'Mounjaro', 'tirzepatide', 3, true, false, '4 pens (2 mL) per 28 days', 22),
  ('UHC-F25-0023', 'Victoza', 'liraglutide', 4, true, true, '3 pens (9 mL) per 30 days', 23),
  ('UHC-F25-0024', 'Rybelsus', 'semaglutide', 3, true, false, '30 tablets per 30 days', 23),
  ('UHC-F25-0025', 'Lantus SoloStar', 'insulin glargine', 3, false, false, '5 pens (15 mL) per 30 days', 24),
  ('UHC-F25-0026', 'Semglee', 'insulin glargine-yfgn', 2, false, false, '5 pens (15 mL) per 30 days', 24),
  ('UHC-F25-0027', 'Basaglar KwikPen', 'insulin glargine', 3, false, true, '5 pens (15 mL) per 30 days', 25),
  ('UHC-F25-0028', 'Humalog', 'insulin lispro', 3, false, false, '2 vials (20 mL) per 30 days', 25),
  ('UHC-F25-0029', null, 'insulin lispro', 2, false, false, '5 pens (15 mL) per 30 days', 26),
  ('UHC-F25-0030', 'Tresiba FlexTouch', 'insulin degludec', 4, true, true, '5 pens (15 mL) per 30 days', 26),
  ('UHC-F25-0031', null, 'metformin hydrochloride', 1, false, false, null, 27),
  ('UHC-F25-0032', 'Glucophage XR', 'metformin hydrochloride ER', 2, false, false, null, 27),
  ('UHC-F25-0033', 'Jardiance', 'empagliflozin', 3, false, true, '30 tablets per 30 days', 28),
  ('UHC-F25-0034', 'Farxiga', 'dapagliflozin', 3, false, true, '30 tablets per 30 days', 28),
  ('UHC-F25-0035', 'Januvia', 'sitagliptin', 4, false, true, '30 tablets per 30 days', 29),
  ('UHC-F25-0036', null, 'glipizide', 1, false, false, null, 29),
  ('UHC-F25-0037', null, 'glimepiride', 1, false, false, null, 29),
  ('UHC-F25-0038', null, 'lisinopril', 1, false, false, null, 30),
  ('UHC-F25-0039', null, 'lisinopril/hydrochlorothiazide', 1, false, false, null, 30),
  ('UHC-F25-0040', null, 'amlodipine besylate', 1, false, false, null, 31),
  ('UHC-F25-0041', null, 'losartan potassium', 1, false, false, null, 31),
  ('UHC-F25-0042', null, 'metoprolol succinate ER', 2, false, false, null, 32),
  ('UHC-F25-0043', null, 'carvedilol', 1, false, false, null, 32),
  ('UHC-F25-0044', 'Entresto', 'sacubitril/valsartan', 4, true, true, '60 tablets per 30 days', 33),
  ('UHC-F25-0045', 'Bystolic', 'nebivolol', 4, false, true, null, 33),
  ('UHC-F25-0046', null, 'hydrochlorothiazide', 1, false, false, null, 34),
  ('UHC-F25-0047', null, 'atorvastatin calcium', 1, false, false, null, 35),
  ('UHC-F25-0048', 'Lipitor', 'atorvastatin calcium', 3, false, true, null, 35),
  ('UHC-F25-0049', null, 'rosuvastatin calcium', 1, false, false, null, 36),
  ('UHC-F25-0050', null, 'simvastatin', 1, false, false, null, 36),
  ('UHC-F25-0051', null, 'pravastatin sodium', 1, false, false, null, 37),
  ('UHC-F25-0052', null, 'ezetimibe/simvastatin', 2, false, false, null, 37),
  ('UHC-F25-0053', 'Repatha SureClick', 'evolocumab', 5, true, true, '2 syringes (2 mL) per 28 days', 38),
  ('UHC-F25-0054', 'Eliquis', 'apixaban', 3, false, false, '60 tablets per 30 days', 40),
  ('UHC-F25-0055', 'Xarelto', 'rivaroxaban', 3, false, false, '30 tablets per 30 days', 40),
  ('UHC-F25-0056', null, 'warfarin sodium', 1, false, false, null, 41),
  ('UHC-F25-0057', null, 'clopidogrel bisulfate', 1, false, false, null, 41),
  ('UHC-F25-0058', 'Brilinta', 'ticagrelor', 4, false, true, '60 tablets per 30 days', 42),
  ('UHC-F25-0059', null, 'sertraline hydrochloride', 1, false, false, null, 44),
  ('UHC-F25-0060', null, 'escitalopram oxalate', 1, false, false, null, 44),
  ('UHC-F25-0061', null, 'fluoxetine hydrochloride', 1, false, false, null, 45),
  ('UHC-F25-0062', null, 'bupropion hydrochloride XL', 2, false, false, '30 tablets per 30 days', 45),
  ('UHC-F25-0063', null, 'venlafaxine hydrochloride ER', 2, false, false, null, 46),
  ('UHC-F25-0064', null, 'duloxetine hydrochloride', 2, false, false, null, 46),
  ('UHC-F25-0065', null, 'mirtazapine', 1, false, false, null, 47),
  ('UHC-F25-0066', 'Trintellix', 'vortioxetine', 4, false, true, '30 tablets per 30 days', 47),
  ('UHC-F25-0067', 'Pristiq', 'desvenlafaxine ER', 4, false, true, null, 48),
  ('UHC-F25-0068', 'Auvelity', 'dextromethorphan/bupropion', 5, true, true, '60 tablets per 30 days', 48),
  ('UHC-F25-0069', null, 'omeprazole', 1, false, false, '30 capsules per 30 days', 49),
  ('UHC-F25-0070', null, 'pantoprazole sodium', 1, false, false, '30 tablets per 30 days', 49),
  ('UHC-F25-0071', 'Dexilant', 'dexlansoprazole', 4, false, true, '30 capsules per 30 days', 50),
  ('UHC-F25-0072', null, 'famotidine', 1, false, false, null, 50),
  ('UHC-F25-0073', null, 'sucralfate', 2, false, false, null, 51),
  ('UHC-F25-0074', 'Linzess', 'linaclotide', 3, false, true, '30 capsules per 30 days', 51),
  ('UHC-F25-0075', 'Xifaxan', 'rifaximin', 5, true, false, '60 tablets per 30 days', 52),
  ('UHC-F25-0076', 'Humira', 'adalimumab', 5, true, false, '2 syringes per 28 days', 53),
  ('UHC-F25-0077', 'Hyrimoz', 'adalimumab-adaz', 5, true, false, '2 syringes per 28 days', 54),
  ('UHC-F25-0078', 'Enbrel SureClick', 'etanercept', 5, true, true, '4 syringes (4 mL) per 28 days', 55),
  ('UHC-F25-0079', 'Stelara', 'ustekinumab', 5, true, true, '1 syringe per 84 days', 56),
  ('UHC-F25-0080', 'Xeljanz', 'tofacitinib', 5, true, true, '60 tablets per 30 days', 58)
on conflict (drug_id) do update set
  brand_name = excluded.brand_name, generic_name = excluded.generic_name, tier = excluded.tier,
  prior_authorization = excluded.prior_authorization, step_therapy = excluded.step_therapy,
  quantity_limit = excluded.quantity_limit, source_page = excluded.source_page;

select count(*) as rows_loaded from public.formulary_drugs;
