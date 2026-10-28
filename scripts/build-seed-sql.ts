// Builds supabase/seed.sql: the formulary_drugs table plus every drug from the CSV export.
// Usage: npm run seed:sql, then run supabase/seed.sql in the Supabase SQL Editor.
import { readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { parse } from "csv-parse/sync";

type Row = Record<string, string>;

const root = join(__dirname, "..");
const rows: Row[] = parse(readFileSync(join(root, "data", "uhc-formulary-2025.csv")), {
  columns: true,
  skip_empty_lines: true,
});

const text = (v: string | null) => (v ? `'${v.replace(/'/g, "''")}'` : "null");

const values = rows.map((r) =>
  `  (${[
    text(r.drug_id),
    text(r.brand_name),
    text(r.generic_name),
    Number(r.tier),
    r.prior_authorization === "Y",
    r.step_therapy === "Y",
    text(r.quantity_limit === "Y" ? r.quantity_limit_detail || "Yes" : null),
    Number(r.source_page),
  ].join(", ")})`,
);

const sql = `${readFileSync(join(root, "supabase", "schema.sql"), "utf8")}
insert into public.formulary_drugs
  (drug_id, brand_name, generic_name, tier, prior_authorization, step_therapy, quantity_limit, source_page)
values
${values.join(",\n")}
on conflict (drug_id) do update set
  brand_name = excluded.brand_name, generic_name = excluded.generic_name, tier = excluded.tier,
  prior_authorization = excluded.prior_authorization, step_therapy = excluded.step_therapy,
  quantity_limit = excluded.quantity_limit, source_page = excluded.source_page;

select count(*) as rows_loaded from public.formulary_drugs;
`;

writeFileSync(join(root, "supabase", "seed.sql"), sql);
console.log(`Wrote supabase/seed.sql with ${rows.length} drugs.`);
