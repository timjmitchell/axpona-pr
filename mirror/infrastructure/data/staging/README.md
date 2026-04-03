# Staging Layer — Structured Extraction

**Status:** Active
**DDD Analog:** Anti-corruption layer
**Medallion:** Silver

## What Belongs Here

Structured data extracted from domain-layer raw sources via the three-tier extraction pipeline:

- **Tier 1 (regex)** — Pattern-based extraction of entities, pricing, and inventory
- **Tier 2 (Ollama)** — LLM-enriched extraction adding classification and confidence scores
- **Tier 3 (Claude)** — High-fidelity synthesis for complex extraction tasks (e.g., sentiment)

## Rules

1. **Source attribution** — every extracted entity traces back to a domain-layer source file
2. **Confidence scores** — extractions include confidence metadata (min threshold: 0.6)
3. **Deduplication** — cross-extraction dedup by entity name + source
4. **No raw data** — raw captures belong in `domain/`, not here

## Key Files

| File | Pipeline | Description |
|------|----------|-------------|
| `structured-extraction.json` | Tier 1 regex | Spaces, sponsorship, tickets, demographics |
| `enriched-extraction.json` | Tier 2 Ollama | Entity classification and relationship detection |
| `exhibitor-extraction-test.json` | Tier 2 test | Exhibitor directory subset (validation run) |
| `sentiment-extraction.json` | Tier 3 Claude | 202 forum sentiment records from 13 threads |
| `manifest.yaml` | — | Layer manifest with pipeline and validation rules |
