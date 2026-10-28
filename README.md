# ZERO

Drug coverage lookup for the Pilot member app. Every answer comes from the
UnitedHealthcare Medicare Part D Sample Formulary 2025, stored in Supabase with
the page each drug is listed on.

## Lookup output

```
$ npm run lookup -- "Bystolic"
Drug:                Bystolic — nebivolol
Coverage tier:       Tier 4
Prior authorization: No
Step therapy:        Yes
Quantity limit:      no quantity limit
Source page:         33
```

`npm run lookup -- "nebivolol"` (generic name, lowercase) prints the same drug.
A drug that is not on the list prints `"<name>" is not on the UnitedHealthcare Sample Formulary 2025.`

## Data

- Source: [`data/uhc-formulary-2025.csv`](data/uhc-formulary-2025.csv) (80 drugs)
- Table: `public.formulary_drugs` (8 columns), schema in [`supabase/schema.sql`](supabase/schema.sql)

| Column | Meaning |
| --- | --- |
| `drug_id` | Formulary entry ID |
| `brand_name` | Brand name (empty for generic-only entries) |
| `generic_name` | Generic name |
| `tier` | Coverage tier, 1–5 |
| `prior_authorization` | Plan must approve before the pharmacy fills it |
| `step_therapy` | A cheaper drug must be tried first |
| `quantity_limit` | Limit text, or empty if there is no quantity limit |
| `source_page` | Formulary page the entry comes from |

## Setup

```bash
npm install
cp .env.example .env.local   # fill in Supabase URL and publishable key
npm run seed:sql             # writes supabase/seed.sql; run it in the Supabase SQL Editor
npm run lookup -- "Eliquis"
```
