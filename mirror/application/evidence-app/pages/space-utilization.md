---
title: Space Utilization
---

# Space Utilization

Revenue per square foot, floor plan fill rate, and listening room premium. 213 listening rooms at venue capacity ceiling — growth comes from pricing, not capacity.

## Floor Plan Fill Rate

```sql fill
select
    f.edition_id,
    e.edition_year,
    f.total_spaces,
    f.filled_spaces,
    f.fill_pct
from axpona.v_floor_plan_fill f
join axpona.dim_edition e on f.edition_id = e.edition_id
order by e.edition_year
```

<BigValue data={fill} value=fill_pct fmt=pct1 title="Latest Fill %" />
<BigValue data={fill} value=filled_spaces title="Filled Spaces" />
<BigValue data={fill} value=total_spaces title="Total Spaces" />

<LineChart data={fill} x=edition_year y=fill_pct fmt=pct1 title="Floor Plan Fill % Trend" />

## Revenue per Square Foot

```sql rev_sqft
select
    e.edition_year,
    s.space_type,
    round(sum(sa.actual_price) / nullif(sum(s.sqft), 0), 2) as revenue_per_sqft,
    sum(sa.actual_price) as total_revenue,
    round(sum(s.sqft), 0) as total_sqft
from axpona.fct_space_assignment sa
join axpona.dim_space s on sa.space_id = s.space_id
join axpona.dim_edition e on sa.edition_id = e.edition_id
where sa.assignment_status in ('assigned', 'occupied')
  and sa.actual_price > 0
group by e.edition_year, s.space_type
order by e.edition_year
```

<BarChart data={rev_sqft} x=edition_year y=revenue_per_sqft fmt=usd series=space_type title="Revenue per Sqft by Space Type" />

## Listening Room Premium

```sql premium
select
    e.edition_year,
    round(avg(sa.actual_price / nullif(s.sqft, 0)) filter (where s.space_type = 'listening_room'), 2) as listening_room_rate,
    round(avg(sa.actual_price / nullif(s.sqft, 0)) filter (where s.space_type = 'expo'), 2) as expo_rate,
    case when avg(sa.actual_price / nullif(s.sqft, 0)) filter (where s.space_type = 'expo') > 0
        then round(
            avg(sa.actual_price / nullif(s.sqft, 0)) filter (where s.space_type = 'listening_room') /
            avg(sa.actual_price / nullif(s.sqft, 0)) filter (where s.space_type = 'expo'),
            2
        )
        else null
    end as premium_multiple
from axpona.fct_space_assignment sa
join axpona.dim_space s on sa.space_id = s.space_id
join axpona.dim_edition e on sa.edition_id = e.edition_id
where sa.assignment_status in ('assigned', 'occupied')
  and sa.actual_price > 0
group by e.edition_year
order by e.edition_year
```

<LineChart data={premium} x=edition_year y=premium_multiple title="Listening Room Premium (multiple over expo rate)" />

## Fill Rate by Space Type

```sql fill_by_type
select
    s.space_type,
    count(*) as total,
    count(*) filter (where sa.assignment_status in ('assigned', 'occupied')) as filled,
    round(count(*) filter (where sa.assignment_status in ('assigned', 'occupied'))::numeric / count(*), 3) as fill_pct
from axpona.fct_space_assignment sa
join axpona.dim_space s on sa.space_id = s.space_id
group by s.space_type
order by fill_pct desc
```

<BarChart data={fill_by_type} x=space_type y=fill_pct fmt=pct1 title="Fill Rate by Space Type" />
