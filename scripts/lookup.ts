// Looks up a drug by brand or generic name (case-insensitive) in Supabase.
// Usage: npm run lookup -- "Ozempic"
import { createClient } from "@supabase/supabase-js";

type Drug = {
  drug_id: string;
  brand_name: string | null;
  generic_name: string;
  tier: number;
  prior_authorization: boolean;
  step_therapy: boolean;
  quantity_limit: string | null;
  source_page: number;
};

const yesNo = (v: boolean) => (v ? "Yes" : "No");

function format(d: Drug): string {
  return [
    `Drug:                ${d.brand_name ?? "(generic)"} — ${d.generic_name}`,
    `Coverage tier:       Tier ${d.tier}`,
    `Prior authorization: ${yesNo(d.prior_authorization)}`,
    `Step therapy:        ${yesNo(d.step_therapy)}`,
    `Quantity limit:      ${d.quantity_limit ?? "no quantity limit"}`,
    `Source page:         ${d.source_page}`,
  ].join("\n");
}

async function main() {
  const name = process.argv.slice(2).join(" ").trim();
  if (!name) {
    console.error('Usage: npm run lookup -- "<brand or generic name>"');
    process.exit(1);
  }

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
  if (!url || !key) throw new Error("Supabase URL or publishable key is missing from .env.local");

  // Escape characters that PostgREST filters treat specially, then match exactly (ilike = case-insensitive).
  const term = name.replace(/[%_,()\\]/g, (c) => `\\${c}`);
  const { data, error } = await createClient(url, key)
    .from("formulary_drugs")
    .select("*")
    .or(`brand_name.ilike.${term},generic_name.ilike.${term}`)
    .order("drug_id");
  if (error) throw new Error(error.message);

  if (!data?.length) {
    console.log(`"${name}" is not on the UnitedHealthcare Sample Formulary 2025.`);
    return;
  }
  console.log((data as Drug[]).map(format).join("\n\n"));
}

main().catch((err) => {
  console.error(err.message ?? err);
  process.exit(1);
});
