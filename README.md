# DataBank Parameter Knowledge

Machine-readable, source-backed reference for Tmall Databank and related crowd parameters. Keep the repository private because brand mappings and audience-model metadata are business working materials.

## For AI readers

1. Read `AGENTS.md` and this file first.
2. Query `data/competitor-public-pools.json` for exact source models, `data/category-id-translations.csv` for category IDs, and `data/brand-ids.json` for exact standard-brand names and IDs.
3. Follow each record's `labelsFile` and the corresponding original JSON under `sources/` to inspect evidence.
4. Preserve status and provenance. Never infer a brand ID from a crowd name or silently replace an ambiguous code.

## Data layout

- `data/competitor-public-pools.json`: normalized 95-row index from the 2026-11-04 deposit.
- `data/brand-ids.json`: normalized index of the user-provided full brand-name/ID table.
- `data/category-id-translations.csv`: category ID/name/path/evidence table from the 2026-11-04 deposit.
- `competitor-public-codes.csv`: source table; one row per pool/card, with original field values.
- `sources/`: 41 original crowd models and their label text. The source JSON is authoritative for exact payloads.
- `sources/DEPOSIT_README.md`: source-specific notes and known uncertainty from the 2026-11-04 deposit.
- `sources/brand-id-master.tsv`: original brand ID table supplied by the user.
- `source-archives/`: original ZIP archive for exact provenance.
- `scripts/build-index.ps1`: repeatable CSV-to-JSON normalization.

## Parameter matching

Match on the full parameter tuple, not a label alone: platform surface (`PUBLIC_CATE_BHV` or `PUBLIC_ITEM_BHV`), category or item IDs, standard brand IDs, behavior codes, date type/value, channel, price/frequency bounds, title terms, and pool operator. Keep identifiers as strings. Preserve array order when copying a source model.

## Evidence levels

- `user-confirmed`: explicit user correction or confirmation.
- `source-payload`: copied from an exact source JSON/model.
- `ui-verified`: visible selector or platform evidence independently confirms the mapping.
- `inferred`: association is suggested by a name or neighboring data only; never use as an executable parameter.
- `needs-review`: sources conflict or the mapping is incomplete.

Current source-specific brand-code caveats are in `sources/DEPOSIT_README.md`. In particular, a candidate code is not a confirmed code until its platform label or source payload supports that association.

The user-provided brand master confirms `YSL/圣罗兰` as `20112` and `CARSLAN/卡姿兰` as `48830`. Do not use `48830` for YSL. See `data/brand-corrections.json` for the machine-readable correction.

## Updating

Keep the original archive/export unchanged under `source-archives/` when adding a new deposit, record its date and source, then regenerate the normalized indexes:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/build-index.ps1
```

Review record counts, parse validity, duplicate source keys, and changes in `git diff` before committing. Never store cookies, access tokens, browser profiles, or unrelated audience exports here.
