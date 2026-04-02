# Intermediate Layer — Cross-Source Joins

**Status:** Planned
**DDD Analog:** Domain services
**Medallion:** Silver-to-Gold transition

## What Belongs Here

Cross-source joins, entity resolution, and deduplication outputs. This layer reconciles entities extracted from different staging sources into unified domain entities with lineage.

Planned join specs:

- **Exhibitor lifecycle** — unify exhibitor identity across directory, space assignments, and forum mentions
- **Sponsorship assembly** — join inventory with sold status and community mentions
- **Attendee funnel** — join ticket types, pricing, demographics with experience sentiment
- **Cross-context** — exhibitor × attendee × space marketplace dynamics

## Rules

1. **Explicit lineage** — every output field traces to its staging-layer source
2. **Entity resolution** — reconcile the same entity across different sources
3. **No raw data** — only joins and transforms of staging outputs
4. **Grain documented** — each output declares its grain (e.g., "one row per exhibitor")

## Key Files

| File | Description |
|------|-------------|
| `manifest.yaml` | Layer manifest with join specifications |

See `manifest.yaml` for planned join specs and their source/output declarations.
