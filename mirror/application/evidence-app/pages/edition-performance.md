---
title: Edition Performance
---

# Edition Performance

Per-edition P&L, EBITDA margin, and revenue growth year-over-year.

## Edition Summary

```sql editions
select
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

<DataTable data={editions} />

## Revenue vs Cost

```sql rev_cost
select
    es.edition_year,
    es.total_revenue,
    es.total_cost
from axpona.v_edition_summary es
where es.total_revenue is not null
order by es.edition_year
```

<LineChart data={rev_cost} x=edition_year y={['total_revenue', 'total_cost']} fmt=usd title="Revenue vs Cost" />

## Margin Trend

<LineChart data={editions} x=edition_year y=margin fmt=pct1 title="EBITDA Margin %" />

## Revenue Growth YoY

```sql growth
select
    ag.edition_year,
    ag.attendee_count,
    ag.prev_year_count,
    ag.yoy_growth
from axpona.v_attendee_growth ag
order by ag.edition_year
```

<BarChart data={growth} x=edition_year y=yoy_growth fmt=pct1 title="Attendee Growth YoY" />

## Revenue Breakdown

```sql breakdown
select
    e.edition_year,
    p.exhibitor_revenue,
    p.sponsorship_revenue,
    p.ticket_revenue,
    p.services_revenue
from axpona.fct_edition_pnl p
join axpona.dim_edition e on p.edition_id = e.edition_id
order by e.edition_year
```

<BarChart data={breakdown} x=edition_year y={['exhibitor_revenue', 'sponsorship_revenue', 'ticket_revenue', 'services_revenue']} fmt=usd type=stacked title="Revenue Breakdown by Source" />
