# Pre-Pipeline Snapshot

Snapshot of all hand-built artifacts taken **2026-04-07** before running the
standardized research-pr pipeline (Issue #3).

**Purpose:** After the pipeline produces canonical artifacts, diff against this
snapshot to verify nothing was lost and to identify content that becomes 1P
(first-party) intellectual property vs. pipeline-derived output.

## Contents

| Directory | Files | What |
|-----------|-------|------|
| `bronze/forums/` | 18 | Raw forum crawls (AudioKarma, Hi-Fi+, Head-Fi) |
| `bronze/on-site/` | 35 | On-site data captures (exhibitor directory, spaces, sponsors, demographics, pricing) |
| `staging/` | 4+meta | Structured extractions (regex + Ollama + Claude 3-tier pipeline) |
| `schemas/` | 2 | `axpona-schema.sql` (707-line dimensional model) + `SCHEMA_REFERENCE.md` |
| `domain/` | 7 | Strategic DDD, ubiquitous language, BizBok overlay, business model synthesis, validation |
| `docs/` | 5 | Classification, gap analysis, executive briefing, sentiment summary, signal patterns |
| `docs/purchase/` | 12 | Due diligence: offering memo, APA, legal research, partnership agreement |
| `presentation/` | 1 | Show timing & location research (84K) |
| `governance/` | 1 | Catalog lineage YAML |
| `marts/` | 2+meta | Business model synthesis mart definition |
| `scripts/` | 2 | Haiku extraction test, tier-3 synthesis script |
| `sources.json` | 1 | Source registry with reliability scores |
| `data-architecture-spec.md` | 1 | Full data pipeline specification |

**Total:** 96 files, 6.5 MB

## Post-Pipeline Reconciliation Checklist

- [ ] Every domain concept in `domain/strategic-ddd.md` appears in pipeline DDD output
- [ ] Schema tables in `schemas/axpona-schema.sql` have pipeline equivalents
- [ ] Business model in `domain/business-model-synthesis.md` reconciled with `business-model.yaml`
- [ ] Classification in `docs/classification.md` reconciled with `classification.yaml`
- [ ] Gap analysis findings in `docs/gap-analysis.md` covered by `/scale-project` output
- [ ] Ubiquitous language terms preserved in pipeline artifacts
- [ ] BizBok overlay mappings reflected in capability crossmaps
- [ ] Sentiment/signal analysis referenced or superseded
- [ ] Purchase due diligence unchanged (should not be touched by pipeline)
- [ ] Extraction scripts archived or superseded by pipeline tooling
