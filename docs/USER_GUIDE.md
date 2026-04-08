# User Guide — AXPONA

> **Engagement:** axpona-pr
> **Stack:** Agentic Explicit-Enterprise (PostgreSQL + Qdrant + Neo4j + Agent Runtime)
> **Issue:** [#3](https://github.com/timjmitchell/axpona-pr/issues/3)

## Quick Start

```bash
# 1. Start the data layer
docker compose up -d postgres qdrant neo4j

# 2. Load the domain model into Neo4j
python scripts/load_axpona_graph.py

# 3. Open Neo4j Browser
open http://localhost:7476
```

PostgreSQL initializes with the 26-table schema automatically from `mirror/infrastructure/schemas/axpona-schema.sql`.

## Services

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| PostgreSQL | 5440 | `postgresql://localhost:5440/axpona` | Domain model — all 8 bounded contexts |
| Qdrant | 6340 (REST), 6341 (gRPC) | `http://localhost:6340` | Corpus — forum crawls, due diligence, sentiment |
| Neo4j | 7476 (HTTP), 7689 (Bolt) | `http://localhost:7476` | Domain model graph visualization |
| Agent Runtime | 8200 | `http://localhost:8200` | Agent execution (38 capabilities) |
| API | 8280 | `http://localhost:8280` | Registration, portals, dashboards |

Start individual services or groups:

```bash
docker compose up -d postgres qdrant neo4j    # Data layer only
docker compose up -d                          # All persistent services
docker compose --profile pipeline run pipeline bronze  # Run pipeline stage
```

## Neo4j Browser — Exploring the Domain Model

Open `http://localhost:7476` after loading the graph. No authentication required.

### Useful Queries

**See everything:**
```cypher
MATCH (n) RETURN n LIMIT 200
```

**Bounded contexts with domain typing:**
```cypher
MATCH (n:BoundedContext) RETURN n ORDER BY n.weight DESC
```

**Context map — how contexts interact:**
```cypher
MATCH (a:BoundedContext)-[r]->(b:BoundedContext)
RETURN a, r, b
```

**Full pattern chain (context → pattern → capability):**
```cypher
MATCH (c:BoundedContext)-[:IMPLEMENTS]->(p:Pattern)-[:DELIVERS]->(cap:Capability)
RETURN c, p, cap
```

**CORE contexts only:**
```cypher
MATCH (c:BoundedContext {ddd_type: 'CORE'})-[:IMPLEMENTS]->(p:Pattern)-[:DELIVERS]->(cap:Capability)
RETURN c, p, cap
```

**Which systems serve which contexts:**
```cypher
MATCH (s:System)-[:SERVES]->(c:BoundedContext)
RETURN s, c
```

**Value stream flow (annual edition cycle):**
```cypher
MATCH (a:Stage)-[:FLOWS_TO]->(b:Stage)
RETURN a, b
```

**Domain events and what metrics they produce:**
```cypher
MATCH (e:DomainEvent)-[:PRODUCES]->(m:Metric)
RETURN e, m
```

**Agent prescriptions — what they unlock:**
```cypher
MATCH (rx:Prescription)-[:UNLOCKS]->(cap:Capability)
RETURN rx, cap
```

**Corpus sources — what informs each context:**
```cypher
MATCH (src:CorpusSource)-[:INFORMS]->(ctx:BoundedContext)
RETURN src, ctx
```

**Goal patterns and what they measure:**
```cypher
MATCH (g:Goal)-[:MEASURES]->(p:Pattern)
RETURN g, p
```

**Everything connected to the Exhibitor context:**
```cypher
MATCH (c:BoundedContext {id: 'exhibitor'})-[r]-(n)
RETURN c, r, n
```

### Graph Reload

After modifying any mirror YAML files, reload the graph:

```bash
python scripts/load_axpona_graph.py --clear    # Clear and reload
python scripts/load_axpona_graph.py             # Additive load (merge)
python scripts/load_axpona_graph.py --dry-run   # Preview without writing
```

## PostgreSQL — Domain Model

Connect with any PostgreSQL client:

```bash
psql -h localhost -p 5440 -U axpona -d axpona
```

Default credentials (from `.env` or docker-compose defaults):
- **User:** `axpona`
- **Password:** `axpona_dev`
- **Database:** `axpona`

### Key Views (pre-built analytics)

```sql
-- Exhibitor rebooking rate by edition (THE leading indicator)
SELECT * FROM v_rebooking_rate;

-- Floor plan fill percentage
SELECT * FROM v_floor_plan_fill;

-- Sponsorship sell-through by category
SELECT * FROM v_sponsorship_sell_through;

-- Attendee growth year-over-year
SELECT * FROM v_attendee_growth;

-- Services attach rate per exhibitor
SELECT * FROM v_services_attach_rate;

-- Edition P&L summary
SELECT * FROM v_edition_summary;

-- Exhibitor retention cohorts
SELECT * FROM v_exhibitor_retention;
```

### Schema Overview

8 bounded contexts → 26 tables:

| Context | Tables | Key Table |
|---------|--------|-----------|
| Shared | `dim_edition` | The conformed dimension — join key across everything |
| Exhibitor (CORE) | `dim_exhibitor`, `fct_exhibitor_edition`, `exhibitor_service_order`, `exhibitor_rebooking` | `fct_exhibitor_edition` |
| Sponsorship (CORE) | `dim_sponsor`, `fct_sponsorship_delivery`, `sponsorship_package` | `fct_sponsorship_delivery` |
| Exhibition Space (CORE) | `dim_space`, `fct_space_assignment` | `fct_space_assignment` |
| Event (CORE) | `event`, `event_session`, `event_speaker`, `session_speaker`, `fct_edition_pnl` | `fct_edition_pnl` |
| Attendee (SUPPORTING) | `dim_attendee`, `fct_registration` | `fct_registration` |
| Interaction (SUPPORTING) | `dim_interaction`, `fct_lead_capture` | `fct_lead_capture` |
| Agreement (GENERIC) | `agreement`, `agreement_term` | `agreement` |
| Finance (GENERIC) | `dim_account`, `fct_transaction` | `fct_transaction` |
| Cross-Context | `context_edge` | Typed relationships between entities |

## Data Pipeline

The bronze → silver → gold pipeline runs as on-demand Docker jobs:

```bash
# Run individual stages
docker compose --profile pipeline run pipeline bronze
docker compose --profile pipeline run pipeline silver
docker compose --profile pipeline run pipeline gold

# Run full post-show pipeline (all stages + reports)
docker compose --profile pipeline run pipeline post_show
```

Pipeline manifests are in `mirror/infrastructure/data/`:

| Layer | Manifest | What It Does |
|-------|----------|-------------|
| Bronze | `bronze/manifest.yaml` | 9 extraction contracts — pull raw data from sources |
| Silver | `silver/manifest.yaml` | 7 transforms — conform to domain model (ACL boundary) |
| Gold | `gold/manifest.yaml` | 6 fact tables, 16 metrics — analytical output |
| Governance | `governance/manifest.yaml` | 8 DQ rules, 4 coherence targets |

## Project Structure

```
axpona-pr/
├── mirror/
│   ├── domain/
│   │   ├── outside-in/          # Pipeline outputs (classification → business model → DDD)
│   │   │   ├── STRATEGIC_DDD.md      # 8 bounded contexts, context map, sagas
│   │   │   ├── UBIQUITOUS_LANGUAGE.md # Domain vocabulary
│   │   │   ├── business-model.yaml    # Investment thesis + domain typing
│   │   │   ├── classification.yaml    # Business classification
│   │   │   ├── reference-model.yaml   # Predicted entities + system mix
│   │   │   ├── engagement.yaml        # 3P/1P boundary
│   │   │   ├── context.md             # 1P intelligence brief
│   │   │   ├── system-inventory.yaml  # Confirmed + predicted systems
│   │   │   ├── system-classification.yaml
│   │   │   ├── value-stream-map.yaml  # 3 value streams
│   │   │   ├── information-map.yaml   # Entity state machines + relationships
│   │   │   └── capability-vs-crossmap.yaml
│   │   ├── patterns/
│   │   │   ├── registry.yaml          # 17 patterns, 72 capabilities
│   │   │   ├── domain/                # 7 domain pattern files
│   │   │   ├── analytics/             # 7 analytics pattern files
│   │   │   └── process/               # 6 process catalogs (19 processes)
│   │   └── coherence/                 # Pipeline coherence analysis
│   ├── application/
│   │   └── agents/
│   │       └── prescriptions.yaml     # 7 agent prescriptions from scale gaps
│   ├── infrastructure/
│   │   ├── schemas/
│   │   │   └── axpona-schema.sql      # 26 tables, 36 indexes, 8 views
│   │   ├── data/                      # Pipeline manifests (bronze/silver/gold/governance)
│   │   ├── corpus/
│   │   │   └── graph.yaml             # 37 typed edges for Neo4j
│   │   └── topology/
│   │       ├── repos.yaml             # 2-repo topology (domain + data)
│   │       └── DERIVATION.md          # How topology was derived from DDD
│   └── presentation/                  # Client-facing deliverables
├── projection/                        # K8s scale projection manifests
│   ├── analysis/                      # Dated analysis documents
│   ├── postgres.yaml, qdrant.yaml, neo4j (in docker-compose)
│   ├── agent-runtime.yaml, api.yaml, pipeline-jobs.yaml
│   └── README.md
├── pre-pipeline/                      # Snapshot of hand-built artifacts (1P baseline)
├── docs/
│   ├── ARCHITECTURE.md
│   ├── GAPS.md                        # Scale projection gaps (25 Clean, 7 Concerning)
│   ├── engagement-logs/axpona/        # Pipeline reasoning logs
│   ├── purchase/                      # Due diligence documents
│   └── session-notes/
├── scripts/
│   └── load_axpona_graph.py           # Load domain model into Neo4j
├── docker-compose.yaml                # Full agentic stack
└── CLAUDE.md                          # Claude Code instructions
```

## Key Concepts

**Edition** — The conformed dimension. Every metric, every query, every cross-context analysis is organized by edition. AXPONA 2026 is the 17th edition. `dim_edition` is the join key.

**Rebooking Rate** — THE leading indicator. 80% of exhibitors rebook within 30 days of show close. If this drops, everything follows. Query: `SELECT * FROM v_rebooking_rate;`

**Revenue per Sqft** — Core value measure for Exhibition Space. $110/sqft (2025). 213 listening rooms at the venue capacity ceiling means growth comes from pricing, not capacity.

**Domain Typing** — CORE (build custom, competitive advantage), SUPPORTING (buy and adapt), GENERIC (buy commodity). Drives investment priority and agent prescription phasing.

## Environment Variables

Create `.env` from the template:

```bash
cp .env.example .env
```

| Variable | Default | Required For |
|----------|---------|-------------|
| `POSTGRES_USER` | `axpona` | PostgreSQL |
| `POSTGRES_PASSWORD` | `axpona_dev` | PostgreSQL |
| `ANTHROPIC_API_KEY` | — | Agent Runtime, Pipeline |
