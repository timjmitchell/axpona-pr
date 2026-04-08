---
title: Financial Health
---

# Financial Health

Revenue allocation, transaction flow, and financial account health across the edition lifecycle.

## Revenue by Account Category

```sql by_category
select
    a.account_category,
    count(t.*) as transactions,
    round(sum(t.amount), 0) as total_amount
from axpona.fct_transaction t
join axpona.dim_account a on t.account_id = a.account_id
where a.account_type = 'revenue'
group by a.account_category
order by total_amount desc
```

<BarChart data={by_category} x=account_category y=total_amount fmt=usd title="Revenue by Category" />

## Transaction Volume by Edition

```sql by_edition
select
    e.edition_year,
    count(t.*) as transactions,
    round(sum(t.amount) filter (where a.account_type = 'revenue'), 0) as revenue,
    round(sum(t.amount) filter (where a.account_type = 'expense'), 0) as expenses
from axpona.fct_transaction t
join axpona.dim_account a on t.account_id = a.account_id
join axpona.dim_edition e on t.edition_id = e.edition_id
group by e.edition_year
order by e.edition_year
```

<BarChart data={by_edition} x=edition_year y={['revenue', 'expenses']} fmt=usd title="Revenue vs Expenses by Year" />

## Transaction Status

```sql status
select
    t.status,
    count(*) as transactions,
    round(sum(t.amount), 0) as total_amount
from axpona.fct_transaction t
group by t.status
order by total_amount desc
```

<BarChart data={status} x=status y=transactions title="Transactions by Status" />

## Payment Flow

```sql payments
select
    t.transaction_type,
    t.party_type,
    count(*) as transactions,
    round(sum(t.amount), 0) as total_amount
from axpona.fct_transaction t
group by t.transaction_type, t.party_type
order by total_amount desc
```

<DataTable data={payments} />
