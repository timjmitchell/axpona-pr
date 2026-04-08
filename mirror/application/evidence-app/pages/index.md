---
title: AXPONA — Trade Show Analytics
---

# AXPONA — Executive Dashboard

Audio Expo North America. Annual high-end audio trade show (JD Events LLC).

```sql summary
select
    count(distinct e.edition_id) as editions,
    max(e.edition_year) as latest_year,
    max(e.edition_number) as latest_number
from axpona.dim_edition e
where e.status = 'completed'
```

```sql latest_pnl
select
    es.edition_id,
    es.edition_year,
    es.edition_number,
    es.total_revenue,
    es.total_cost,
    es.margin,
    es.attendee_count,
    es.exhibitor_count,
    es.sponsor_count
from axpona.v_edition_summary es
order by es.edition_year desc
```

<BigValue data={latest_pnl} value=total_revenue fmt=usd title="Revenue (Latest)" />
<BigValue data={latest_pnl} value=attendee_count title="Attendees" />
<BigValue data={latest_pnl} value=exhibitor_count title="Exhibitors" />
<BigValue data={latest_pnl} value=sponsor_count title="Sponsors" />

## Revenue by Edition

```sql revenue_trend
select
    es.edition_year,
    es.total_revenue,
    es.total_cost,
    es.margin
from axpona.v_edition_summary es
where es.total_revenue is not null
order by es.edition_year
```

<LineChart data={revenue_trend} x=edition_year y=total_revenue fmt=usd title="Total Revenue by Year" />

## Margin Trend

<LineChart data={revenue_trend} x=edition_year y=margin fmt=pct1 title="EBITDA Margin by Year" />

## Key Metrics Snapshot (Latest Edition)

```sql rebooking
select * from axpona.v_rebooking_rate
order by edition_id desc
limit 1
```

```sql fill
select * from axpona.v_floor_plan_fill
order by edition_id desc
limit 1
```

<BigValue data={rebooking} value=rebooking_rate fmt=pct1 title="Rebooking Rate (30d)" />
<BigValue data={fill} value=fill_pct fmt=pct1 title="Floor Plan Fill %" />

---

**Explore:**
- [Exhibitor Retention](/exhibitor-retention) — Rebooking rate, net growth, contract value, services attach
- [Exhibitors](/exhibitors) — Per-exhibitor detail (revenue history, spaces, leads)
- [Sponsorship Yield](/sponsorship-yield) — Fill rate by category, CPM, renewal rate
- [Space Utilization](/space-utilization) — Revenue per sqft, fill %, listening room premium
- [Edition Performance](/edition-performance) — P&L, margin, revenue growth YoY
- [Attendee Demand](/attendee-demand) — Attendee count, ticket ARPU, growth trends
- [Lead Effectiveness](/lead-effectiveness) — Leads per exhibitor, conversion rates
