---
title: Exhibitor Retention
---

# Exhibitor Retention

THE leading indicator. 80% of exhibitors rebook within 30 days of show close. If this drops, everything follows.

## Rebooking Rate by Edition

```sql rebooking
select
    r.edition_id,
    e.edition_year,
    r.total_exhibitors,
    r.rebooked,
    r.rebooking_rate
from axpona.v_rebooking_rate r
join axpona.dim_edition e on r.edition_id = e.edition_id
order by e.edition_year
```

<BigValue data={rebooking} value=rebooking_rate fmt=pct1 title="Latest Rebooking Rate" />
<BigValue data={rebooking} value=total_exhibitors title="Total Exhibitors" />
<BigValue data={rebooking} value=rebooked title="Rebooked (30d)" />

<LineChart data={rebooking} x=edition_year y=rebooking_rate fmt=pct1 title="Rebooking Rate Trend" />

## Net Exhibitor Growth

```sql net_growth
select
    e.edition_year,
    count(*) as total,
    count(*) filter (where not fe.is_returning) as new_exhibitors,
    count(*) filter (where fe.is_returning) as returning
from axpona.fct_exhibitor_edition fe
join axpona.dim_edition e on fe.edition_id = e.edition_id
group by e.edition_year
order by e.edition_year
```

<BarChart data={net_growth} x=edition_year y={['new_exhibitors', 'returning']} type=stacked title="Exhibitor Mix by Year" />

## Average Contract Value

```sql avg_contract
select
    e.edition_year,
    round(avg(fe.total_revenue), 0) as avg_revenue,
    round(avg(fe.contract_value), 0) as avg_contract,
    round(avg(fe.services_revenue), 0) as avg_services
from axpona.fct_exhibitor_edition fe
join axpona.dim_edition e on fe.edition_id = e.edition_id
where fe.total_revenue > 0
group by e.edition_year
order by e.edition_year
```

<LineChart data={avg_contract} x=edition_year y=avg_revenue fmt=usd title="Average Revenue per Exhibitor" />

## Contract Value by Space Type

```sql by_space_type
select
    fe.space_type,
    count(*) as exhibitors,
    round(avg(fe.total_revenue), 0) as avg_revenue,
    round(sum(fe.total_revenue), 0) as total_revenue
from axpona.fct_exhibitor_edition fe
where fe.space_type is not null
group by fe.space_type
order by total_revenue desc
```

<BarChart data={by_space_type} x=space_type y=avg_revenue fmt=usd title="Avg Revenue by Space Type" />

## Services Attach Rate

```sql attach
select
    e.edition_year,
    count(*) as exhibitors,
    count(*) filter (where fe.services_revenue > 0) as with_services,
    round(count(*) filter (where fe.services_revenue > 0)::numeric / count(*), 3) as attach_rate
from axpona.fct_exhibitor_edition fe
join axpona.dim_edition e on fe.edition_id = e.edition_id
where fe.contract_value > 0
group by e.edition_year
order by e.edition_year
```

<LineChart data={attach} x=edition_year y=attach_rate fmt=pct1 title="Services Attach Rate Trend" />

## Retention Cohorts

```sql retention
select
    r.from_edition,
    r.to_edition,
    r.exhibitors_from,
    r.retained,
    r.retention_rate
from axpona.v_exhibitor_retention r
where r.to_edition is not null
order by r.from_edition, r.to_edition
```

<DataTable data={retention} />
