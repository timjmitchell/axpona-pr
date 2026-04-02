# AXPONA Mirror

A **mirror** is a standalone data architecture scaffold for a single company engagement. It contains the domain model, raw data, structured extractions, and analytical outputs needed to evaluate the company — all organized in medallion layers aligned to DDD bounded contexts.

## Why "Mirror"?

The mirror reflects the target company's data architecture as we understand it from the outside. It's not the company's actual systems — it's our model of what those systems contain, built from public signals. The same scaffold (manifest, layers, schemas) transfers across companies and verticals.

See [mirror-architecture pattern](../../docs/domain-patterns/mirror-architecture.md) for the full pattern documentation.

## Structure

```
mirror/
├── manifest.yaml                  # What this mirror represents, layer declarations
├── README.md                      # This file
│
├── strategic-ddd.md               # Strategic DDD — bounded contexts, context map
├── ubiquitous-language.md         # Domain language definitions
├── data-architecture-spec.md      # Data architecture design
├── bizbok-ddd-overlay.md          # BIZBOK-to-DDD derivation for trade shows
├── ddd-derivation-validation.md   # Derivation rule validation
│
├── schemas/                       # Canonical schemas
│   ├── axpona-schema.sql          # Dimensional model (PostgreSQL)
│   └── SCHEMA_REFERENCE.md        # Schema documentation
│
├── domain/                        # Raw ingested data (bronze)
│   ├── README.md                  # Layer documentation
│   ├── manifest.yaml              # Layer manifest — contents, ingestion rules
│   ├── sources.json               # Source manifest — what to crawl, how
│   ├── forum-crawl-research.md    # Forum source research and assessment
│   ├── *-raw.md                   # Raw crawled markdown (site pages, forums)
│   └── ...
│
├── staging/                       # Structured extraction (silver)
│   ├── README.md                  # Layer documentation
│   ├── manifest.yaml              # Layer manifest — pipeline, validation rules
│   ├── structured-extraction.json # Tier 1 regex extraction
│   ├── enriched-extraction.json   # Tier 2 Ollama enrichment
│   ├── sentiment-extraction.json  # Forum sentiment (202 deduplicated records)
│   └── ...
│
├── intermediate/                  # Cross-source joins (planned)
│   ├── README.md                  # Layer documentation
│   └── manifest.yaml              # Layer manifest — join specifications
│
├── marts/                         # Analytical outputs (gold)
│   ├── README.md                  # Layer documentation
│   ├── manifest.yaml              # Layer manifest — synthesis rules
│   └── business-model-synthesis.yaml
│
└── semantic/                      # Metrics layer (planned)
    ├── README.md                  # Layer documentation
    └── manifest.yaml              # 8 priority metrics with formulas
```

## Medallion Layers

| Layer | DDD Analog | Contains | Status |
|-------|-----------|----------|--------|
| **domain/** | Domain events, raw facts | Crawled markdown, source manifests | Active |
| **staging/** | Anti-corruption layer | Parsed/enriched JSON from extraction pipeline | Active |
| **intermediate/** | Domain services | Cross-source joins, entity resolution | Planned |
| **marts/** | Read models | Synthesis outputs, analytical summaries | Active |
| **semantic/** | Query interface | Metric definitions, KPI formulas | Planned |

## Key Files

| File | Purpose |
|------|---------|
| [manifest.yaml](manifest.yaml) | Mirror declaration — target org, system classification, layer refs |
| [strategic-ddd.md](strategic-ddd.md) | 8 bounded contexts for trade show operations |
| [domain/sources.json](domain/sources.json) | 29 crawl targets with signal_source, tags, pagination config |
| [staging/sentiment-extraction.json](staging/sentiment-extraction.json) | 202 community sentiment records from 13 forum threads |
| [marts/business-model-synthesis.yaml](marts/business-model-synthesis.yaml) | Structured business model analysis |
| [schemas/axpona-schema.sql](schemas/axpona-schema.sql) | Canonical dimensional model |

## Related

- [../../docs/domain-patterns/mirror-architecture.md](../../docs/domain-patterns/mirror-architecture.md) — Pattern documentation
- [../../docs/SEARCH_GUIDE.md](../../docs/SEARCH_GUIDE.md) — Query routing for the Qdrant corpus
- [../gap-analysis.md](../gap-analysis.md) — Predicted vs. observed gap analysis
- [../sentiment-summary.md](../sentiment-summary.md) — Community sentiment analysis
