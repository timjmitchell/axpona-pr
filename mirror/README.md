# AXPONA Mirror

A **mirror** is a standalone data architecture scaffold for a single company engagement. It contains the domain model, raw data, structured extractions, and analytical outputs needed to evaluate the company — organized in DDD-aligned layers matching the [Ridgeline reference architecture](https://github.com/timjmitchell/ridgeline-demo/tree/main/mirror).

## Why "Mirror"?

The mirror reflects the target company's data architecture as we understand it from the outside. It's not the company's actual systems — it's our model of what those systems contain, built from public signals. The same scaffold (manifest, layers, schemas) transfers across companies and verticals.

## Structure

```text
mirror/
├── manifest.yaml                          # What this mirror represents, layer declarations
├── README.md                              # This file
│
├── domain/                                # Business architecture
│   ├── outside-in/                        # Strategic DDD, UL, business model
│   │   ├── strategic-ddd.md               # 8 bounded contexts for trade show operations
│   │   ├── ubiquitous-language.md         # Domain language definitions
│   │   ├── bizbok-ddd-overlay.md          # BIZBOK-to-DDD derivation for trade shows
│   │   ├── business-model-synthesis.md    # Business model analysis
│   │   ├── ddd-derivation-validation.md   # Derivation rule validation
│   │   └── forum-crawl-research.md        # Forum source research and assessment
│   ├── patterns/                          # Domain pattern registry (future)
│   └── coherence/                         # Coherence scoring (future)
│
├── application/                           # Client-specific solutions
│   ├── EXPLORATION_GUIDE.md               # How to use Evidence dashboards + Neo4j Browser
│   ├── evidence-app/                      # Evidence.dev dashboards (16 gold metrics)
│   ├── agents/                            # Agent prescriptions
│   ├── intake/                            # Problem evaluations (future)
│   └── issues/                            # Engagement issue tracking (future)
│
├── infrastructure/                        # Data pipeline + corpus
│   ├── data-architecture-spec.md          # Data architecture design
│   ├── data/                              # Medallion layers (bronze → silver → gold → governance)
│   │   ├── sources.json                   # Source manifest — what to crawl, how
│   │   ├── bronze/                        # Raw crawl data
│   │   │   ├── forums/                    # Forum crawls (18 threads)
│   │   │   └── on-site/                   # On-site page crawls (30+ pages)
│   │   ├── staging/                       # Structured extraction
│   │   │   ├── structured-extraction.json # Tier 1 regex extraction
│   │   │   ├── enriched-extraction.json   # Tier 2 Ollama enrichment
│   │   │   └── sentiment-extraction.json  # Forum sentiment (202 deduplicated records)
│   │   ├── intermediate/                  # Cross-source joins (planned)
│   │   ├── marts/                         # Analytical outputs
│   │   │   └── business-model-synthesis.yaml
│   │   ├── semantic/                      # Metrics layer (planned)
│   │   └── governance/                    # Lineage catalog
│   │       └── catalog-lineage.yaml
│   ├── schemas/                           # Canonical schemas
│   │   ├── axpona-schema.sql              # Dimensional model (PostgreSQL)
│   │   └── SCHEMA_REFERENCE.md            # Schema documentation
│   └── corpus/                            # Knowledge surfaces (future)
│
└── presentation/                          # Client-facing deliverables
    ├── show-timing-location-research.md   # Venue/timing analysis
    ├── diagrams/                          # Visual outputs (future)
    └── gaps/                              # Gap analysis (future)
```

## 4-Layer Model

| Layer | Purpose | Contains | Status |
|-------|---------|----------|--------|
| **domain/** | Business architecture | Strategic DDD, UL, business model, BIZBOK overlay | Active |
| **application/** | Client-specific solutions | Agent prescriptions, intake evaluations | Scaffolded |
| **infrastructure/** | Data pipeline + corpus | Medallion data layers, schemas, source manifests | Active |
| **presentation/** | Client-facing deliverables | Diagrams, gap analysis, research outputs | Active |

## Key Files

| File | Purpose |
|------|---------|
| [manifest.yaml](manifest.yaml) | Mirror declaration — target org, system classification, layer refs |
| [application/EXPLORATION_GUIDE.md](application/EXPLORATION_GUIDE.md) | How to use Evidence dashboards and Neo4j Browser |
| [application/evidence-app/](application/evidence-app/) | Evidence.dev dashboards — 8 pages, 16 gold metrics |
| [domain/outside-in/strategic-ddd.md](domain/outside-in/strategic-ddd.md) | 8 bounded contexts for trade show operations |
| [infrastructure/data/sources.json](infrastructure/data/sources.json) | 29 crawl targets with signal_source, tags, pagination config |
| [infrastructure/data/staging/sentiment-extraction.json](infrastructure/data/staging/sentiment-extraction.json) | 202 community sentiment records from 13 forum threads |
| [infrastructure/data/marts/business-model-synthesis.yaml](infrastructure/data/marts/business-model-synthesis.yaml) | Structured business model analysis |
| [infrastructure/schemas/axpona-schema.sql](infrastructure/schemas/axpona-schema.sql) | Canonical dimensional model (SQLite — see supabase/migrations/ for PostgreSQL) |

## Reference

- [Ridgeline mirror](https://github.com/timjmitchell/ridgeline-demo/tree/main/mirror) — 4-layer reference architecture
