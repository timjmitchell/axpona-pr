---
title: Attendee Demand
---

# Attendee Demand

Attendee count, ticket ARPU, and growth trends. Demand-side of the marketplace.

## Attendee Growth

```sql growth
select
    ag.edition_year,
    ag.attendee_count,
    ag.prev_year_count,
    ag.yoy_growth
from axpona.v_attendee_growth ag
order by ag.edition_year
```

<BigValue data={growth} value=attendee_count title="Latest Attendance" />
<BigValue data={growth} value=yoy_growth fmt=pct1 title="YoY Growth" />

<LineChart data={growth} x=edition_year y=attendee_count title="Attendee Count by Year" />

## Ticket ARPU

```sql arpu
select
    e.edition_year,
    count(*) as registrations,
    round(sum(r.ticket_price) / nullif(count(*), 0), 2) as arpu
from axpona.fct_registration r
join axpona.dim_edition e on r.edition_id = e.edition_id
group by e.edition_year
order by e.edition_year
```

<LineChart data={arpu} x=edition_year y=arpu fmt=usd title="Ticket ARPU" />

## Registration by Ticket Type

```sql by_ticket
select
    r.ticket_type,
    count(*) as registrations,
    round(avg(r.ticket_price), 2) as avg_price,
    round(sum(r.ticket_price), 0) as total_revenue
from axpona.fct_registration r
group by r.ticket_type
order by registrations desc
```

<BarChart data={by_ticket} x=ticket_type y=registrations title="Registrations by Ticket Type" />

## Acquisition Source

```sql acquisition
select
    r.acquisition_source,
    count(*) as registrations,
    round(count(*) filter (where r.is_returning)::numeric / count(*), 3) as returning_pct
from axpona.fct_registration r
where r.acquisition_source is not null
group by r.acquisition_source
order by registrations desc
```

<BarChart data={acquisition} x=acquisition_source y=registrations title="Registrations by Acquisition Source" />

## Returning Attendees

```sql returning
select
    e.edition_year,
    count(*) as total,
    count(*) filter (where r.is_returning) as returning,
    round(count(*) filter (where r.is_returning)::numeric / count(*), 3) as returning_pct
from axpona.fct_registration r
join axpona.dim_edition e on r.edition_id = e.edition_id
group by e.edition_year
order by e.edition_year
```

<LineChart data={returning} x=edition_year y=returning_pct fmt=pct1 title="Returning Attendee %" />
