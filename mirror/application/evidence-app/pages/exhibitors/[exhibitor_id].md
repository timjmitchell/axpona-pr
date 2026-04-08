---
title: Exhibitor Detail
---

```sql exhibitor
select
    ex.exhibitor_id,
    ex.company_name,
    ex.category,
    ex.exhibitor_type,
    ex.current_tier,
    ex.editions_attended,
    ex.website,
    ex.contact_name
from axpona.dim_exhibitor ex
where ex.exhibitor_id = '${params.exhibitor_id}'
```

# {exhibitor[0].company_name}

| Field | Value |
|-------|-------|
| **ID** | {exhibitor[0].exhibitor_id} |
| **Category** | {exhibitor[0].category} |
| **Type** | {exhibitor[0].exhibitor_type} |
| **Tier** | {exhibitor[0].current_tier} |
| **Editions Attended** | {exhibitor[0].editions_attended} |

## Edition History

```sql editions
select
    e.edition_year,
    fe.space_type,
    fe.space_sqft,
    fe.contract_value,
    fe.services_revenue,
    fe.total_revenue,
    fe.is_returning,
    fe.rebooked_within_30d,
    fe.priority_points,
    fe.lifecycle_state
from axpona.fct_exhibitor_edition fe
join axpona.dim_edition e on fe.edition_id = e.edition_id
where fe.exhibitor_id = '${params.exhibitor_id}'
order by e.edition_year
```

<BigValue data={editions} value=total_revenue fmt=usd title="Latest Revenue" />
<BigValue data={editions} value=contract_value fmt=usd title="Latest Contract" />
<BigValue data={editions} value=services_revenue fmt=usd title="Latest Services" />

### Revenue Trend

<LineChart data={editions} x=edition_year y=total_revenue fmt=usd title="Total Revenue by Year" />

### Contract Value vs Services

<BarChart data={editions} x=edition_year y={['contract_value', 'services_revenue']} fmt=usd type=stacked title="Revenue Breakdown" />

### Edition Detail

<DataTable data={editions} rows=20>
    <Column id=edition_year title="Year" />
    <Column id=space_type title="Space Type" />
    <Column id=space_sqft title="Sqft" />
    <Column id=contract_value title="Contract" fmt=usd />
    <Column id=services_revenue title="Services" fmt=usd />
    <Column id=total_revenue title="Total" fmt=usd />
    <Column id=is_returning title="Returning" />
    <Column id=rebooked_within_30d title="Rebooked 30d" />
    <Column id=priority_points title="Priority Pts" />
    <Column id=lifecycle_state title="State" />
</DataTable>

## Services Attach Rate

```sql attach
select
    e.edition_year,
    sa.space_revenue,
    sa.services_revenue,
    sa.attach_rate
from axpona.v_services_attach_rate sa
join axpona.fct_exhibitor_edition fe on sa.exhibitor_id = fe.exhibitor_id and sa.edition_id = fe.edition_id
join axpona.dim_edition e on sa.edition_id = e.edition_id
where sa.exhibitor_id = '${params.exhibitor_id}'
order by e.edition_year
```

{#if attach.length > 0}

<LineChart data={attach} x=edition_year y=attach_rate fmt=pct1 title="Services Attach Rate" />

{:else}

No services attach data available.

{/if}

## Lead Capture

```sql leads
select
    e.edition_year,
    lc.interaction_type,
    lc.lead_status,
    lc.scan_timestamp,
    att.first_name || ' ' || att.last_name as attendee_name
from axpona.fct_lead_capture lc
join axpona.dim_edition e on lc.edition_id = e.edition_id
join axpona.dim_attendee att on lc.attendee_id = att.attendee_id
where lc.exhibitor_id = '${params.exhibitor_id}'
order by lc.scan_timestamp desc
```

{#if leads.length > 0}

<DataTable data={leads} rows=20>
    <Column id=edition_year title="Year" />
    <Column id=attendee_name title="Attendee" />
    <Column id=interaction_type title="Type" />
    <Column id=lead_status title="Status" />
    <Column id=scan_timestamp title="Timestamp" />
</DataTable>

{:else}

No lead capture data available.

{/if}

## Space Assignments

```sql spaces
select
    e.edition_year,
    s.space_id,
    s.space_type,
    s.floor_location,
    s.sqft,
    sa.actual_price,
    sa.revenue_per_sqft,
    sa.assignment_status
from axpona.fct_space_assignment sa
join axpona.dim_space s on sa.space_id = s.space_id
join axpona.dim_edition e on sa.edition_id = e.edition_id
where sa.exhibitor_id = '${params.exhibitor_id}'
order by e.edition_year desc
```

{#if spaces.length > 0}

<DataTable data={spaces} rows=20>
    <Column id=edition_year title="Year" />
    <Column id=space_id title="Space" />
    <Column id=space_type title="Type" />
    <Column id=floor_location title="Location" />
    <Column id=sqft title="Sqft" />
    <Column id=actual_price title="Price" fmt=usd />
    <Column id=revenue_per_sqft title="$/Sqft" fmt=usd />
</DataTable>

{:else}

No space assignment data available.

{/if}

---

[Back to Exhibitor Retention](/exhibitor-retention) | [All Exhibitors](/exhibitors) | [Home](/)
