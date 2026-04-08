---
title: Sponsorship Yield
---

# Sponsorship Yield

Sponsorship fill rate, CPM equivalent, and renewal rate by category and tier.

## Sell-Through by Category

```sql sell_through
select
    st.edition_id,
    e.edition_year,
    st.category,
    st.total_items,
    st.sold_items,
    st.sell_through_pct
from axpona.v_sponsorship_sell_through st
join axpona.dim_edition e on st.edition_id = e.edition_id
order by e.edition_year desc, st.sell_through_pct desc
```

<BarChart data={sell_through} x=category y=sell_through_pct fmt=pct1 series=edition_year title="Sell-Through % by Category" />

## Fill Rate by Tier

```sql by_tier
select
    sp.tier,
    count(*) as total_packages,
    count(*) filter (where sp.availability_status = 'sold') as sold,
    round(count(*) filter (where sp.availability_status = 'sold')::numeric / count(*), 3) as fill_rate,
    round(sum(sp.price) filter (where sp.availability_status = 'sold'), 0) as revenue
from axpona.sponsorship_package sp
group by sp.tier
order by revenue desc nulls last
```

<BarChart data={by_tier} x=tier y=fill_rate fmt=pct1 title="Fill Rate by Tier" />

<DataTable data={by_tier} />

## CPM Equivalent

```sql cpm
select
    e.edition_year,
    p.sponsorship_revenue,
    p.attendee_count,
    case when p.attendee_count > 0
        then round(p.sponsorship_revenue / (p.attendee_count::numeric / 1000), 0)
        else null
    end as cpm
from axpona.fct_edition_pnl p
join axpona.dim_edition e on p.edition_id = e.edition_id
where p.sponsorship_revenue is not null
order by e.edition_year
```

<LineChart data={cpm} x=edition_year y=cpm fmt=usd title="Sponsorship CPM Equivalent" />

## Renewal Rate

```sql renewal
select
    e.edition_year,
    count(distinct sd.sponsorship_id) as total_sponsorships,
    count(distinct sd.sponsorship_id) filter (where sd.is_renewal) as renewals,
    round(count(distinct sd.sponsorship_id) filter (where sd.is_renewal)::numeric /
          nullif(count(distinct sd.sponsorship_id), 0), 3) as renewal_rate
from axpona.fct_sponsorship_delivery sd
join axpona.dim_edition e on sd.edition_id = e.edition_id
group by e.edition_year
order by e.edition_year
```

<LineChart data={renewal} x=edition_year y=renewal_rate fmt=pct1 title="Sponsorship Renewal Rate" />
