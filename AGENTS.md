# Instructions for AI agents

This repository is a private, source-backed parameter dictionary. Use exact evidence and retain uncertainty.

- Start with `README.md`; use `data/competitor-public-pools.json` for machine retrieval and the matching `sources/*.json` plus `sources/*-labels.txt` for evidence.
- Treat IDs as strings. Do not derive standard brand IDs, category IDs, item IDs, or behavior codes from crowd names.
- A model is reusable only when its full category/item, brand, behavior, channel, date, price/title/frequency and operator conditions match the request. Do not copy a near-match without describing the differences.
- Prefer exact source payloads and platform-verified labels. If user corrections, source JSON, workbook evidence, and labels conflict, mark the entry `needs-review` and explain the conflict. Never silently select one.
- Do not reinterpret missing, censored, pending, or ambiguous values as zero or as a valid code.
- Do not put credentials, cookies, tokens, personal information, or raw unrelated audience lists in this repository.
- This knowledge base documents parameters. It does not itself authorize creating, editing, saving, publishing, or pushing an audience; follow the relevant platform skill and action-time confirmation rules.
