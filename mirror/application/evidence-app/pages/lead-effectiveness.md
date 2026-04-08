---
title: Lead Effectiveness
---

# Lead Effectiveness

Leads per exhibitor, conversion rates, and interaction quality. Measures the value exhibitors get from attending.

## Leads per Exhibitor

```sql leads_per
select
    e.edition_year,
    count(lc.*) as total_leads,
    count(distinct lc.exhibitor_id) as exhibitors_with_leads,
    round(count(lc.*)::numeric / nullif(count(distinct lc.exhibitor_id), 0), 1) as leads_per_exhibitor
from axpona.fct_lead_capture lc
join axpona.dim_edition e on lc.edition_id = e.edition_id
group by e.edition_year
order by e.edition_year
```

<BigValue data={leads_per} value=leads_per_exhibitor title="Leads per Exhibitor" />
<BigValue data={leads_per} value=total_leads title="Total Leads" />

<LineChart data={leads_per} x=edition_year y=leads_per_exhibitor title="Leads per Exhibitor Trend" />

## Lead Status Distribution

```sql by_status
select
    lc.lead_status,
    count(*) as leads,
    round(count(*)::numeric / sum(count(*)) over (), 3) as pct
from axpona.fct_lead_capture lc
group by lc.lead_status
order by leads desc
```

<BarChart data={by_status} x=lead_status y=leads title="Lead Distribution by Status" />

## Leads by Interaction Type

```sql by_type
select
    lc.interaction_type,
    count(*) as leads,
    count(distinct lc.exhibitor_id) as exhibitors
from axpona.fct_lead_capture lc
group by lc.interaction_type
order by leads desc
```

<BarChart data={by_type} x=interaction_type y=leads title="Leads by Interaction Type" />

## Top Exhibitors by Lead Volume

```sql top_exhibitors
select
    ex.company_name,
    count(lc.*) as leads,
    count(*) filter (where lc.lead_status in ('qualified', 'converted')) as qualified
from axpona.fct_lead_capture lc
join axpona.dim_exhibitor ex on lc.exhibitor_id = ex.exhibitor_id
group by ex.company_name
order by leads desc
limit 20
```

<DataTable data={top_exhibitors} />
