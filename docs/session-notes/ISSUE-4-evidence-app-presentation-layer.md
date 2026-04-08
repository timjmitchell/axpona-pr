# Issue #4: Evidence app: presentation layer for 16 gold metrics

> **Issue:** [axpona-pr#4](https://github.com/timjmitchell/axpona-pr/issues/4)
> **Status:** Complete

## 2026-04-08
<!-- @appended by /issue on 2026-04-08T00:00:00Z -->

### Context

Issue #3 produced the full pipeline through Phase 4, including 16 gold-layer metrics with formulas, fact tables, and benchmarks in `mirror/infrastructure/data/gold/manifest.yaml`. The schema has 26 tables and 8 analytical views. What's missing is a presentation layer that renders these metrics as dashboards.

Decided against the three options originally proposed (SQL views, Streamlit, agent-served). Instead, followed the ridgeline-demo infrastructure pattern: **Evidence.dev** for dashboards, **Supabase** for the data layer.

Key design decisions:

- **Supabase replaces raw Docker PostgreSQL** — gives us PostgreSQL + pgvector + REST API + Studio with `npx supabase start`
- **Evidence.dev connects directly to Supabase PostgreSQL** — no DuckDB intermediary (eliminates schema translation friction)
- **Schema migrated from SQLite to PostgreSQL-native** — proper types (TIMESTAMPTZ, BOOLEAN, NUMERIC, JSONB, SERIAL), `FILTER (WHERE ...)` syntax in views
- **pgvector enabled** — corpus embeddings can move from Qdrant to Supabase (future)
- **Per-engagement port allocation** — DB: 5440, API: 5450, Studio: 5460 (index 0)

### Work Done

- Initialized Supabase (`supabase/config.toml`) with minimal services (API + Studio + DB only — auth, storage, realtime, edge runtime disabled)
- Created PostgreSQL-native migration (`supabase/migrations/20260408000000_initial_schema.sql`) — v2.0.0 of the schema with all 26 tables, 36 indexes, 7 views, pgvector extension
- Set up Evidence.dev app at `mirror/application/evidence-app/` following ridgeline-demo structure
- Created 8 dashboard pages: index + 7 analytics pattern pages (exhibitor-retention, sponsorship-yield, space-utilization, edition-performance, attendee-demand, lead-effectiveness, financial-health)
- Created seed data (`supabase/seed.sql`) — 4 editions (2022-2025), 15 exhibitors, 43 exhibitor×edition rows, sponsors, packages, spaces, registrations, leads, financial transactions
- Updated `docker-compose.yaml` — removed PostgreSQL service (now Supabase), kept Qdrant + Neo4j + agent/API/pipeline services
- Updated `docs/USER_GUIDE.md` — new Quick Start, services table, Evidence section, Supabase section, project structure
- Created `mirror/application/EXPLORATION_GUIDE.md` — stakeholder-facing guide for Evidence dashboards + Neo4j Browser
- Updated `mirror/README.md` — references to evidence-app and exploration guide
- Created ADR-0001: Supabase + Evidence.dev as Standard Deployment Stack
- Created ridgeline-demo#25 for DuckDB → Supabase migration
- Validated full stack: `npx supabase start` → `npx supabase db reset` → `npm run sources` (all 22 sources OK) → `npm run build` (clean) → all 8 pages return 200
- Confirmed two Supabase instances coexist (ridgeline on 54322, axpona on 5440)

### Next Steps

- Update PORTS.md in dx-hub-pr with Supabase port convention (API, Studio columns)
- Consider migrating Qdrant corpus to pgvector (Supabase-native) — separate issue
- Add per-exhibitor detail page (parameterized route like ridgeline's `[sku].md`)
- Create more comprehensive seed data if needed for client demo
