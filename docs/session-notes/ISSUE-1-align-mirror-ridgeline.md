# Issue #1: Align mirror to Ridgeline 4-layer model

> **Issue:** [axpona-pr#1](https://github.com/timjmitchell/axpona-pr/issues/1)
> **Status:** In Progress

## 2026-04-02
<!-- @appended by /issue on 2026-04-02T00:00:00Z -->

### Context

Restructure the mirror from flat medallion layout to Ridgeline's 4-layer DDD-aligned model: domain, application, infrastructure, presentation. Also fix arch-sync findings (ARCHITECTURE.md and CLAUDE.md gaps).

Current state has mixed concerns: `domain/` holds both raw data and domain docs, empty `gold/`/`silver/` dirs, no place for agent definitions or client deliverables.

### Work Done

-

### Next Steps

- Migrate files according to the mapping in the issue
- Scaffold `application/` and `presentation/` layers
- Remove empty/redundant directories (`gold/`, `silver/`)
- Update `mirror/README.md` and `mirror/manifest.yaml`
- Fix arch-sync findings in ARCHITECTURE.md and CLAUDE.md
