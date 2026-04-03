# Marts Layer — Analytical Outputs

**Status:** Active
**DDD Analog:** Read models (published interface)
**Medallion:** Gold

## What Belongs Here

Domain-organized analytical outputs — the "published interface" that consulting deliverables consume. Each output represents a bounded context's read model.

Active:
- **Business model synthesis** — revenue streams, system mix, investment thesis

Planned (from data-architecture-spec.md):
- **Exhibitor mart** — `fct_exhibitor_edition`, `dim_exhibitor`
- **Sponsorship mart** — `fct_sponsorship_delivery`, `dim_sponsor`
- **Attendee mart** — `fct_registration`, `dim_attendee`
- **Event mart** — `fct_edition_pnl`, `dim_edition`
- **Exhibition space mart** — `fct_space_assignment`, `dim_space`
- **Interaction mart** — `fct_lead_capture`

## Rules

1. **Schema-backed** — mart outputs align to `schemas/axpona-schema.sql` dimensional models
2. **Context-owned** — each mart maps to a DDD bounded context
3. **Grain declared** — every fact table declares its grain explicitly
4. **No raw or staging data** — only synthesis and analytical products

## Key Files

| File | Description |
|------|-------------|
| `business-model-synthesis.yaml` | Business model analysis + investment thesis |
| `manifest.yaml` | Layer manifest with synthesis rules and planned marts |
