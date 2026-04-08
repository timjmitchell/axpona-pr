# AXPONA — Formal Classification

> **Date:** 2026-03-16
> **Engine:** `research_toolkit.diligence.models.Classification`
> **Issue:** [research-pr#37](https://github.com/timjmitchell/research-pr/issues/37)

## Structured Classification

```python
from research_toolkit.diligence.models import Classification

axpona = Classification(
    customer_type="b2b2c",
    sector="events",
    industry="trade_shows",
    vertical="audio",
    geography="north_america",
    business_model=[
        ("marketplace", 0.6),
        ("advertising", 0.25),
        ("project", 0.15),
    ],
    service_model=None,  # not a software company
    revenue_range="$5M-$20M",
    employee_count=25,
    metadata={
        "company_name": "AXPONA (JD Events LLC)",
        "website": "axpona.com",
        "parent_company": "JD Events LLC",
        "headquarters": "Fairfield, CT",
        "founded": 2002,
        "portfolio": ["AXPONA", "Plant Based World Expo", "Healthcare Facilities Symposium"],
        "bizbok_industry": "Trade Shows (custom — not in BIZBOK v14 standard industries)",
    },
)
```

## Field Rationale

| Field | Value | Reasoning |
|-------|-------|-----------|
| `customer_type` | `b2b2c` | Two-sided marketplace: exhibitors (B2B) pay to access attendees (B2C). Both sides are customers. |
| `sector` | `events` | Parent sector per NAICS 711/713 event industry grouping |
| `industry` | `trade_shows` | Specific industry within events — distinct from conferences, festivals, or conventions |
| `vertical` | `audio` | Audio/hi-fi niche — North America's largest consumer audio show |
| `geography` | `north_america` | Single-location show (Chicago), US-based company, attendees primarily North American |
| `business_model` | marketplace 0.6, advertising 0.25, project 0.15 | **Marketplace (0.6):** Two-sided — exhibitors pay for space to access attendee audience; attendees pay for access to products. Primary revenue driver. **Advertising (0.25):** Sponsorship catalog (40+ items, $500–$12K) = selling audience attention. High margin. **Project (0.15):** Each edition is a discrete project with lifecycle, P&L, and margin. |
| `service_model` | `None` | Not a software company — no SaaS/PaaS/on-prem delivery |
| `revenue_range` | `$5M-$20M` | Estimated from: ~220 listening rooms at $5,250 + expo booths + sponsorship + 10,910 tickets at $32–$150 |
| `employee_count` | `25` | Small organizer; ~25 staff across JD Events' 3-show portfolio |

## Business Model Detail

### Marketplace (weight: 0.6) — Primary

Two-sided marketplace where exhibitors (supply) pay to access attendees (demand).

- **Supply side:** 700+ brands, 5 space types ($1,500–$5,250), exhibitor services
- **Demand side:** 10,910 attendees, 6 ticket types ($15–$150)
- **Network effect:** More exhibitors → better attendee experience → more attendees → exhibitors willing to pay more
- **Revenue mechanics:** Space sales + services attach rate + rebooking cycle

### Advertising (weight: 0.25) — Secondary

Sponsorship = selling audience attention to partners.

- **Inventory:** 40+ items across 6 categories ($500–$12,000)
- **Revenue mechanics:** Package tiers, placement-based pricing, exclusivity premiums
- **Key signal:** Heavy "SOLD" markers on premium inventory = demand exceeds supply

### Project (weight: 0.15) — Tertiary

Each annual edition is a discrete project with its own P&L.

- **Revenue mechanics:** Edition-bound revenue recognition, venue contracts, vendor coordination
- **Lifecycle:** Plan → Sell → Market → Execute → Retain (5 value stream stages)

## Engine Output

Running `generate_reference(axpona)` produces the reference model documented in [axpona-reference-model.md](../../docs/testing/axpona-reference-model.md), including:

- System mix: 20% Application / 40% Work / 15% Analytics / 25% Record (`events_project`)
- 57 predicted entities (21 CORE / 16 SUPPORTING / 20 GENERIC)
- 8 domain contexts (4 core / 2 supporting / 2 generic)
- 9 APQC processes, DCAM/DAMA capability expectations
