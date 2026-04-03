# Architecture

> **Repo:** `axpona-pr`
> **Role:** SemOps Deployment / Consulting Engagement — Trade show operations and exhibitor lifecycle management
> **Status:** ACTIVE
> **Version:** 1.0.0
> **Last Updated:** 2026-04-02

## Role

**axpona-pr** is a consulting deployment — SemOps capabilities applied to the **AXPONA (JD Events LLC)** domain. AXPONA is North America's largest consumer audio show, operating as a two-sided marketplace: exhibitors pay for demo space, attendees pay for access.

**Key distinction:** This repo owns the domain model, analysis, and data architecture for the AXPONA engagement. It consumes SemOps core infrastructure and methodology but is architecturally autonomous.

## DDD Classification

> Source: [REPOS.yaml](https://github.com/timjmitchell/dx-hub-pr/blob/main/config/repos.yaml)

| Property | Value |
|----------|-------|
| **Layer** | `semops-deployment` |
| **Context Type** | `core` |
| **Engagement Type** | `consulting` |
| **Integration Patterns** | `shared-kernel, customer-supplier, anti-corruption-layer, published-language` |
| **Aggregate Root** | `Exhibitor` |

## Bounded Contexts

| Context | Type | Description |
|---------|------|-------------|
| Exhibitor | Differentiating | Supply side — 700+ brands, 5 space types, rebooking mechanics |
| Sponsorship | Differentiating | Highest margin — 40+ products, demand exceeds supply on premiums |
| Exhibition Space | Differentiating | Physical product — listening rooms, expo hall, Ear Gear, Car Audio, ALTI |
| Event | Differentiating | Each annual edition is a discrete project with own P&L |
| Attendee | Necessary | Demand side — registration/ticketing via Unity Event Solutions |
| Interaction | Necessary | Lead capture and matchmaking — sold as exhibitor service |
| Agreement | Commodity | Standard contract management |
| Finance | Commodity | Standard payment processing and accounting |

## Capabilities

| Capability | Status | Description |
|------------|--------|-------------|
| Outside-In Pipeline | active | Signal collection, corpus building, structured extraction |

## Ownership

What this repo owns:
- AXPONA domain model and ubiquitous language
- Mirror architecture (data layers) for AXPONA engagement
- Analysis documents (classification, synthesis, gap analysis)
- Ephemeral corpus and structured extractions

What this repo consumes:
- SemOps methodology and patterns (from dx-hub-pr, semops-hub-pr)
- Research infrastructure and pipeline tooling (from research-pr)

## Key Components

### Mirror Architecture (4-Layer DDD-Aligned)

| Layer | Directory | Purpose |
|-------|-----------|---------|
| Domain | `mirror/domain/` | Business architecture — strategic DDD, UL, business model |
| Application | `mirror/application/` | Client-specific solutions — agents, intake, issues |
| Infrastructure | `mirror/infrastructure/` | Data pipeline — medallion layers, schemas, corpus |
| Presentation | `mirror/presentation/` | Client-facing deliverables — diagrams, gap analysis |

### Analysis Documents

| Document | Purpose |
|----------|---------|
| `docs/classification.md` | Formal business classification |
| `docs/business-model-synthesis.md` | Investment thesis and domain typing |
| `docs/gap-analysis.md` | Prediction vs signals with priority roadmap |
| `docs/executive-briefing.md` | Executive summary |
| `mirror/strategic-ddd.md` | Strategic DDD derivation |
| `mirror/ubiquitous-language.md` | Domain vocabulary |

### Scripts

| Script | Capability | Purpose |
|--------|-----------|---------|
| `scripts/test_haiku_exhibitor_extraction.py` | Outside-In Pipeline | Exhibitor extraction testing |
| `scripts/tier3_synthesis.py` | Outside-In Pipeline | Structured extraction synthesis |

## Dependencies

### What We Consume

| Repo | What We Consume |
|------|-----------------|
| dx-hub-pr | Architecture governance, patterns, coordination |
| semops-hub-pr | Schema, methodology, infrastructure services |
| research-pr | Pipeline tooling, signal collection infrastructure |

### What Consumes Us

| Repo | What They Consume |
|------|-------------------|
| — | No downstream consumers (leaf deployment) |

## Versioning Notes

This repo follows the consulting deployment pattern — it is a leaf node with no downstream consumers. Version bumps are informational and track engagement milestones, not API contracts.

- **PATCH:** Data refreshes, extraction re-runs, doc updates
- **MINOR:** New analysis outputs, additional bounded contexts, schema additions
- **MAJOR:** Structural changes to mirror architecture, schema breaking changes

## Related Documentation

- [GLOBAL_ARCHITECTURE.md](https://github.com/timjmitchell/dx-hub-pr/blob/main/docs/GLOBAL_ARCHITECTURE.md) - System landscape
- [REPOS.yaml](https://github.com/timjmitchell/dx-hub-pr/blob/main/config/repos.yaml) - Structured repo registry
- [ADR-0008: Consulting Deployment Pattern](https://github.com/timjmitchell/dx-hub-pr/blob/main/docs/decisions/ADR-0008-consulting-deployment-pattern.md)
- [DD-0002: Consulting Deployment Pattern](https://github.com/timjmitchell/dx-hub-pr/blob/main/docs/design-docs/DD-0002-consulting-deployment-pattern.md)
- `docs/decisions/` - Architecture Decision Records for this repo
- `docs/session-notes/` - Session logs by issue
