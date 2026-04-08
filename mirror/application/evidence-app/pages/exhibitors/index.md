---
title: Exhibitors
---

# Exhibitors

All exhibitors with lifetime metrics. Click any exhibitor to see their full history.

```sql exhibitors
select
    ex.exhibitor_id,
    '/exhibitors/' || ex.exhibitor_id as exhibitor_link,
    ex.company_name,
    ex.category,
    ex.exhibitor_type,
    ex.current_tier,
    ex.editions_attended,
    round(sum(fe.total_revenue), 0) as lifetime_revenue,
    round(avg(fe.total_revenue), 0) as avg_revenue,
    max(e.edition_year) as last_attended
from axpona.dim_exhibitor ex
left join axpona.fct_exhibitor_edition fe on ex.exhibitor_id = fe.exhibitor_id
left join axpona.dim_edition e on fe.edition_id = e.edition_id
group by ex.exhibitor_id, ex.company_name, ex.category, ex.exhibitor_type, ex.current_tier, ex.editions_attended
order by lifetime_revenue desc nulls last
```

<BigValue data={exhibitors} value=exhibitor_id fmt=num0 title="Total Exhibitors" />

<DataTable data={exhibitors} rows=50 search=true>
    <Column id=exhibitor_link title="Exhibitor" contentType=link linkLabel=company_name />
    <Column id=category title="Category" />
    <Column id=exhibitor_type title="Type" />
    <Column id=current_tier title="Tier" />
    <Column id=editions_attended title="Editions" />
    <Column id=lifetime_revenue title="Lifetime Revenue" fmt=usd />
    <Column id=avg_revenue title="Avg/Edition" fmt=usd />
    <Column id=last_attended title="Last Year" />
</DataTable>
