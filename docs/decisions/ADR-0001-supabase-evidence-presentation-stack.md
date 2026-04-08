# ADR-0001: Supabase + Evidence.dev as Standard Deployment Stack

> **Status:** Complete
> **Date:** 2026-04-08
> **Related Issue:** [#4](https://github.com/timjmitchell/axpona-pr/issues/4)

## Executive Summary

Adopt Supabase (PostgreSQL + pgvector + REST API + Studio) as the standard data backend and Evidence.dev as the presentation layer for all SemOps consulting deployments. This replaces the previous stack of raw Docker PostgreSQL + DuckDB intermediary, eliminating schema translation friction and collapsing infrastructure into a single managed service.

## Context

Issue #3 produced a full analytical pipeline with 16 gold-layer metrics, but no way to render them as dashboards. The ridgeline-demo engagement had solved this with Evidence.dev + DuckDB, but the DuckDB intermediary caused ongoing friction:

- **Schema translation overhead:** The canonical schema (SQLite for axpona, PostgreSQL for ridgeline) needed translation to DuckDB types (`TEXT→VARCHAR`, `TIMESTAMPTZ→TIMESTAMP`, `datetime('now')→CURRENT_TIMESTAMP`)
- **Two schemas to maintain:** `build-duckdb.sql` + `build-db.sh` scripts duplicated the canonical schema in DuckDB dialect
- **Infrastructure inconsistency:** Each engagement had different canonical schema targets (SQLite vs PostgreSQL) despite both running PostgreSQL in Docker

The guiding principle: **"infrastructure is a non-choice"** — the consulting deployment pattern should produce identical infrastructure across engagements.

## Decision

1. **Supabase as the data backend** — `npx supabase start` provides PostgreSQL 17 + pgvector + REST API + Studio. Schema lives in `supabase/migrations/` as PostgreSQL-native DDL.

2. **Evidence.dev connects directly to PostgreSQL** — no DuckDB intermediary. `@evidence-dev/postgres` is the sole datasource adapter. SQL source files query the same tables and views that exist in the database.

3. **Per-engagement port allocation** — Supabase ports follow the existing PORTS.md convention (`DB: 5440+index`, `API: 5450+index`, `Studio: 5460+index`), enabling multiple Supabase instances to coexist.

4. **pgvector replaces Qdrant (future)** — Supabase includes pgvector, which can serve corpus embeddings currently in Qdrant. This collapses two services into one.

## Consequences

### Positive

- One schema, one database, no translation — PostgreSQL-native everywhere
- `npx supabase start` gives developers a full data layer without Docker knowledge
- Studio UI lets non-technical stakeholders explore data directly
- Auto-generated REST API from schema — useful for agent runtime integration
- pgvector path eliminates separate vector DB service
- Pattern is identical across engagements — ridgeline-demo#25 tracks migration

### Negative

- Supabase CLI is an additional dependency (installed via npm)
- Local Supabase runs its own Docker containers under the hood (abstracted, but still Docker)
- Port allocation scheme now needs to account for 3 Supabase ports per engagement

### Risks

- Evidence.dev dependency tree has version conflicts with Node.js 24+ (TypeScript 6, TailwindCSS 4) — requires `--legacy-peer-deps` and pinned versions
- Empty tables produce invalid parquet files in Evidence build — source files must only exist for populated tables
- Supabase CLI updates could break local dev (mitigated by pinning in package.json)

## Implementation Plan

- [x] Initialize Supabase in axpona-pr with engagement-specific ports
- [x] Migrate axpona-schema.sql from SQLite to PostgreSQL-native (`supabase/migrations/`)
- [x] Set up Evidence.dev app (`mirror/application/evidence-app/`)
- [x] Create 8 dashboard pages (index + 7 analytics patterns)
- [x] Create seed data for demo dashboards
- [x] Validate: `npx supabase start` → `npx supabase db reset` → `npm run sources` → `npm run build` → all pages 200
- [x] Update USER_GUIDE.md and mirror README
- [x] Create ridgeline-demo#25 for DuckDB → Supabase migration
- [ ] Migrate Qdrant corpus to pgvector (future issue)
- [ ] Update PORTS.md in dx-hub-pr with Supabase port convention

## Session Log

### 2026-04-08

- Prototyped full stack in axpona-pr
- Validated two Supabase instances coexisting (ridgeline on 54322, axpona on 5440)
- Created EXPLORATION_GUIDE.md for stakeholder-facing documentation

## References

- [ridgeline-demo#25](https://github.com/timjmitchell/ridgeline-demo/issues/25) — DuckDB → Supabase migration
- [ADR-0008: Consulting Deployment Pattern](https://github.com/timjmitchell/dx-hub-pr/blob/main/docs/decisions/ADR-0008-consulting-deployment-pattern.md) — parent pattern
- [DD-0002: Consulting Deployment Pattern](https://github.com/timjmitchell/dx-hub-pr/blob/main/docs/design-docs/DD-0002-consulting-deployment-pattern.md)
- [Evidence.dev](https://evidence.dev) — markdown + SQL dashboard framework
- [Supabase CLI](https://supabase.com/docs/guides/local-development/cli) — local development stack
