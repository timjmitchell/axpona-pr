# Issue #1: Align mirror to Ridgeline 4-layer model

> **Issue:** [axpona-pr#1](https://github.com/timjmitchell/axpona-pr/issues/1)
> **Status:** Complete

## 2026-04-02
<!-- @appended by /issue on 2026-04-02T00:00:00Z -->

### Context

Restructure the mirror from flat medallion layout to Ridgeline's 4-layer DDD-aligned model: domain, application, infrastructure, presentation. Also fix arch-sync findings (ARCHITECTURE.md and CLAUDE.md gaps).

Current state has mixed concerns: `domain/` holds both raw data and domain docs, empty `gold/`/`silver/` dirs, no place for agent definitions or client deliverables.

### Work Done

- Migrated all files to 4-layer model (domain, application, infrastructure, presentation)
- Domain docs → `mirror/domain/outside-in/`
- Data pipeline layers (bronze, staging, intermediate, marts, semantic, governance) → `mirror/infrastructure/data/`
- Schemas → `mirror/infrastructure/schemas/`
- Show-timing research → `mirror/presentation/`
- Removed empty `gold/`, `silver/` directories
- Scaffolded `application/` (agents, intake, issues) and `presentation/` (diagrams, gaps)
- Updated `mirror/README.md`, `mirror/manifest.yaml`, `mirror/domain/README.md`
- ARCHITECTURE.md: added Versioning Notes, inbound Dependencies table, updated mirror table
- CLAUDE.md: added Cross-Repo Context, Available Commands sections, updated mirror ref

### Next Steps

- None — all acceptance criteria met
