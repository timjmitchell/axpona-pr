# Semantic Layer — Metrics & KPIs

**Status:** Planned
**DDD Analog:** Query interface (Published Language)
**Medallion:** Metric definitions

## What Belongs Here

Metric definitions, KPI formulas, and the Published Language for AXPONA analytics. This layer defines what each metric means and how it's calculated — it enforces vocabulary without enforcing a single physical model.

Priority metrics (from data-architecture-spec.md Section 7):

| Metric | Definition | Priority |
|--------|------------|----------|
| Rebooking rate | % exhibitors rebooked within 30 days | Critical |
| Floor plan fill % | Assigned / total spaces at T-90 | Critical |
| Edition margin | (Revenue - Cost) / Revenue | Critical |
| Sponsorship sell-through | Sold / available by category | High |
| Attendee growth YoY | Edition-over-edition count change | High |
| Services attach rate | Services rev / space rev per exhibitor | High |
| Sponsor renewal rate | % sponsors returning YoY | High |
| Trade Pass growth | YoY change in Trade Pass registrations | Medium |

## Rules

1. **One definition per metric** — no ambiguity in metric vocabulary
2. **Fact source declared** — every metric traces to a marts-layer fact table
3. **Business model linked** — each metric maps to a business model component
4. **No data** — this layer contains definitions, not data files

## Key Files

| File | Description |
|------|-------------|
| `manifest.yaml` | Metric definitions with formulas and fact sources |

See `manifest.yaml` for full metric specifications.
