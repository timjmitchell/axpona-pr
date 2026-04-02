# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Role

**axpona-pr** is a consulting deployment — SemOps capabilities applied to the **trade show operations and exhibitor lifecycle management** domain (AXPONA / JD Events LLC).

This repo has its own bounded context: own domain model, own aggregate root (Exhibitor), own ubiquitous language. It consumes SemOps core infrastructure and methodology but is architecturally autonomous.

**Layer:** `semops-deployment` in [repos.yaml](https://github.com/timjmitchell/dx-hub-pr/blob/main/config/repos.yaml)
**Pattern:** [ADR-0008: Consulting Deployment Pattern](https://github.com/timjmitchell/dx-hub-pr/blob/main/docs/decisions/ADR-0008-consulting-deployment-pattern.md)

## Domain Model

- **Aggregate root:** Exhibitor
- **Schema:** TBD
- **Pattern registry:** `config/patterns/pattern_v1.yaml` (own registry, references core where adopted)
- **Mirror architecture:** `mirror/` (domain/bronze/silver/gold/governance)

## Context Resolution

When shared commands (`/arch-sync`, `/intake`, `/issue`, etc.) run in this repo, they use this repo's authorities:

- **Pattern registry:** this repo's `pattern_v1.yaml`, not core's
- **Schema:** this repo's schema, not core's
- **UL:** this repo's domain vocabulary

See [DD-0002 § Context Resolution](https://github.com/timjmitchell/dx-hub-pr/blob/main/docs/design-docs/DD-0002-consulting-deployment-pattern.md) for the full authority source matrix.

## Session Notes

Document work sessions tied to GitHub Issues in `docs/session-notes/`:

- **Format:** `ISSUE-NN-description.md` (one file per issue, append-forever)
- **Index:** Update `docs/SESSION_NOTES.md` with new entries

## Key Files

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - This repo's architecture
- [docs/decisions/](docs/decisions/) - Architecture Decision Records
- [docs/session-notes/](docs/session-notes/) - Session logs by issue
- [config/patterns/pattern_v1.yaml](config/patterns/pattern_v1.yaml) - Domain pattern registry
- [mirror/](mirror/) - Mirror architecture (data layers)
