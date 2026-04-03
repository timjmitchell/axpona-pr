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
- **Mirror architecture:** `mirror/` (domain/application/infrastructure/presentation)

## Context Resolution

When shared commands (`/arch-sync`, `/intake`, `/issue`, etc.) run in this repo, they use this repo's authorities:

- **Pattern registry:** this repo's `pattern_v1.yaml`, not core's
- **Schema:** this repo's schema, not core's
- **UL:** this repo's domain vocabulary

See [DD-0002 § Context Resolution](https://github.com/timjmitchell/dx-hub-pr/blob/main/docs/design-docs/DD-0002-consulting-deployment-pattern.md) for the full authority source matrix.

## Cross-Repo Context

This repo is a leaf deployment — it consumes SemOps core but has no downstream consumers.

**Key authorities for this repo:**

| Source | Type | What it tells you |
|--------|------|-------------------|
| `config/patterns/pattern_v1.yaml` | Bronze | Domain pattern registry (this repo's, not core's) |
| `mirror/manifest.yaml` | Config | Mirror declaration — target org, layers, classification |
| `mirror/domain/outside-in/strategic-ddd.md` | Domain | 8 bounded contexts for trade show operations |
| `mirror/domain/outside-in/ubiquitous-language.md` | Domain | Domain vocabulary definitions |
| `mirror/infrastructure/schemas/axpona-schema.sql` | Schema | Canonical dimensional model |

**Upstream repos (read-only dependencies):**

| Repo | What we consume |
|------|-----------------|
| dx-hub-pr | Architecture governance, patterns, coordination |
| semops-hub-pr | Schema, methodology, infrastructure services |
| research-pr | Pipeline tooling, signal collection infrastructure |

## Available Commands

| Command | Use when |
|---------|----------|
| `/kb` | Looking up patterns, capabilities, repos, or methodology |
| `/issue` | Working on GitHub issues (start, resume, checkpoint) |
| `/intake` | Evaluating new issues against the domain model |
| `/arch-sync` | Auditing this repo's docs against templates and REPOS.yaml |
| `/prime` | Loading local context for this repo |
| `/prime-global` | Loading cross-repo context from dx-hub-pr |
| `/derive` | Generating DDD architecture from synthesis |
| `/synthesize` | Business model synthesis and merge |
| `/recon` | Zero-footprint source reconnaissance |
| `/discover` | Active source discovery for 3P signal collection |

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
