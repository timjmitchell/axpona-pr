# Schema Reference — AXPONA Domain Model

> **Version:** 1.0.0
> **Schema:** [axpona-schema.sql](axpona-schema.sql)
> **Domain Model:** [STRATEGIC_DDD.md](../STRATEGIC_DDD.md), [UBIQUITOUS_LANGUAGE.md](../UBIQUITOUS_LANGUAGE.md)
> **Data Architecture:** [data-architecture-spec.md](../data-architecture-spec.md)
> **Issue:** research-pr#37

---

## Overview

27 tables across 8 bounded contexts + 1 cross-context edge table + 1 meta table. 7 semantic layer views.

| Context | DDD Type | System Type | Tables | Aggregate Root |
|---------|----------|-------------|--------|----------------|
| Event | CORE | Work | `event`, `event_session`, `event_speaker`, `session_speaker`, `dim_edition`, `fct_edition_pnl` | Event |
| Exhibitor | CORE | Work | `dim_exhibitor`, `fct_exhibitor_edition`, `exhibitor_service_order`, `exhibitor_rebooking` | Exhibitor |
| Sponsorship | CORE | Work | `dim_sponsor`, `fct_sponsorship_delivery`, `sponsorship_package` | Sponsorship |
| Exhibition Space | CORE | Work | `dim_space`, `fct_space_assignment` | ExhibitionSpace |
| Attendee | SUPPORTING | Application | `dim_attendee`, `fct_registration` | Attendee |
| Interaction | SUPPORTING | Application | `dim_interaction`, `fct_lead_capture`, `matchmaking_appointment` | Interaction |
| Agreement | GENERIC | Record | `agreement`, `agreement_term` | Agreement |
| Finance | GENERIC | Record | `dim_account`, `fct_transaction` | FinancialAccount |

**Shared:** `dim_edition` (conformed dimension), `context_edge` (cross-context), `schema_version` (meta)

---

## Conformed Dimension

`dim_edition` is the **single conformed dimension** — the join key across all contexts. Every fact table references `edition_id`. The trade show equivalent of a SaaS monthly cohort.

---

## Conventions

- **Primary keys:** TEXT (slugs/IDs) or INTEGER AUTOINCREMENT
- **Timestamps:** TEXT in ISO 8601 format (SQLite; PostgreSQL upgrade → TIMESTAMPTZ)
- **Booleans:** INTEGER 0/1 (SQLite; PostgreSQL upgrade → BOOLEAN)
- **JSON fields:** JSON type (SQLite treats as TEXT; PostgreSQL upgrade → JSONB)
- **Every main table has:** `metadata JSON NOT NULL DEFAULT '{}'` for schema evolution
- **Every main table has:** `created_at`, `updated_at` timestamps
- **Naming:** `dim_` prefix for dimensions, `fct_` prefix for fact tables, no prefix for entity/operational tables

---

## Fact Tables (6)

### `fct_exhibitor_edition` (Exhibitor)

Grain: one row per exhibitor per edition.

| Column | Type | Source | Description |
|--------|------|--------|-------------|
| exhibitor_id | TEXT | FK → dim_exhibitor | Exhibitor aggregate root |
| edition_id | TEXT | FK → dim_edition | Event context reference |
| space_type | TEXT | Exhibition Space | Degenerate dimension |
| space_sqft | REAL | SpaceDimensions VO | Measure |
| contract_value | REAL | Agreement context | Measure |
| services_revenue | REAL | ServiceOrder entities | Measure |
| total_revenue | REAL | Computed | contract_value + services_revenue |
| is_returning | INTEGER | RebookingRecord | Boolean |
| priority_points | INTEGER | PriorityPoints VO | Measure |
| days_to_close | INTEGER | Lifecycle timestamps | Measure |
| rebooked_within_30d | INTEGER | RebookingRecord state | Boolean |
| contract_signed_date | TEXT | Agreement transition | Date |
| lifecycle_state | TEXT | Exhibitor lifecycle | Status |

### `fct_sponsorship_delivery` (Sponsorship)

Grain: one row per deliverable per sponsorship per edition.

| Column | Type | Source | Description |
|--------|------|--------|-------------|
| sponsorship_id | TEXT | Sponsorship aggregate root | PK component |
| sponsor_id | TEXT | FK → dim_sponsor | Partner reference |
| edition_id | TEXT | FK → dim_edition | Event context reference |
| package_tier | TEXT | SponsorshipPackage VO | Degenerate dimension |
| deliverable_type | TEXT | SponsorshipDeliverable | Degenerate dimension |
| deliverable_value | REAL | Package allocation | Measure |
| estimated_impressions | INTEGER | Package metadata | Measure |
| exclusivity_flag | INTEGER | SponsorshipPackage VO | Boolean |
| delivery_status | TEXT | Deliverable state | Status |
| is_renewal | INTEGER | Sponsorship history | Boolean |
| previous_tier | TEXT | Historical | For upgrade tracking |

### `fct_registration` (Attendee)

Grain: one row per registration per edition.

| Column | Type | Source | Description |
|--------|------|--------|-------------|
| attendee_id | TEXT | FK → dim_attendee | Attendee aggregate root |
| edition_id | TEXT | FK → dim_edition | Event context reference |
| registration_date | TEXT | Registration entity | Date |
| ticket_type | TEXT | Ticket VO | Degenerate dimension |
| ticket_price | REAL | Ticket VO | Measure |
| acquisition_source | TEXT | Registration metadata | Degenerate dimension |
| checked_in | INTEGER | Registration state | Boolean |
| days_attended | INTEGER | Badge scan data | Measure |
| is_returning | INTEGER | Attendee history | Boolean |
| editions_attended_total | INTEGER | Running count | Measure |

### `fct_space_assignment` (Exhibition Space)

Grain: one row per space per edition.

| Column | Type | Source | Description |
|--------|------|--------|-------------|
| space_id | TEXT | FK → dim_space | ExhibitionSpace root |
| edition_id | TEXT | FK → dim_edition | Event context reference |
| exhibitor_id | TEXT | FK → dim_exhibitor | SpaceAssignment reference |
| assignment_status | TEXT | ExhibitionSpace state | Status |
| assignment_date | TEXT | State transition | Date |
| revenue_per_sqft | REAL | Computed | Measure |
| list_price | REAL | Space pricing | Measure |
| actual_price | REAL | Negotiated price | Measure |

### `fct_lead_capture` (Interaction)

Grain: one row per lead per edition.

| Column | Type | Source | Description |
|--------|------|--------|-------------|
| interaction_id | TEXT | Interaction aggregate root | PK component |
| exhibitor_id | TEXT | FK → dim_exhibitor | LeadRecord reference |
| attendee_id | TEXT | FK → dim_attendee | LeadRecord reference |
| edition_id | TEXT | FK → dim_edition | Event context reference |
| scan_timestamp | TEXT | LeadRecord | Timestamp |
| interaction_type | TEXT | Interaction type | Degenerate dimension |
| lead_status | TEXT | LeadRecord state | Status |
| space_id | TEXT | FK → dim_space | Interaction location |

### `fct_edition_pnl` (Event)

Grain: one row per edition.

| Column | Type | Source | Description |
|--------|------|--------|-------------|
| edition_id | TEXT | PK, FK → dim_edition | Event aggregate root |
| venue_cost | REAL | Finance context | Measure |
| marketing_spend | REAL | Finance context | Measure |
| operations_cost | REAL | Finance context | Measure |
| exhibitor_revenue | REAL | Aggregate | Measure |
| sponsorship_revenue | REAL | Aggregate | Measure |
| ticket_revenue | REAL | Aggregate | Measure |
| services_revenue | REAL | Aggregate | Measure |
| total_revenue | REAL | Computed | Measure |
| total_cost | REAL | Computed | Measure |
| margin | REAL | Computed | (revenue - cost) / revenue |

---

## Dimension Tables (5)

| Dimension | Context | Key | Description |
|-----------|---------|-----|-------------|
| `dim_edition` | Shared | edition_id | Conformed dimension — edition year, venue, dates |
| `dim_exhibitor` | Exhibitor | exhibitor_id | Company name, category, type, tier, history |
| `dim_attendee` | Attendee | attendee_id | Name, type, history |
| `dim_sponsor` | Sponsorship | sponsor_id | Company name, type, history |
| `dim_space` | Exhibition Space | space_id | Type, dimensions, location |
| `dim_account` | Finance | account_id | Account type, category |
| `dim_interaction` | Interaction | interaction_id | Type, description |

---

## Semantic Layer Views (7)

| View | Metric | Business Model |
|------|--------|----------------|
| `v_rebooking_rate` | % exhibitors rebooked within 30 days | Marketplace (supply retention) |
| `v_floor_plan_fill` | Assigned / total spaces | Marketplace (supply capacity) |
| `v_sponsorship_sell_through` | Sold / available by category | Advertising (demand) |
| `v_attendee_growth` | YoY attendee count change | Marketplace (demand growth) |
| `v_services_attach_rate` | Services revenue / space revenue | Marketplace (ARPU) |
| `v_edition_summary` | Edition P&L rollup | Project (profitability) |
| `v_exhibitor_retention` | Edition-over-edition retention | Marketplace (loyalty) |

---

## Entity/Operational Tables

| Table | Context | Purpose |
|-------|---------|---------|
| `exhibitor_service_order` | Exhibitor | Service line items (drayage, AV, etc.) |
| `exhibitor_rebooking` | Exhibitor | Rebooking lifecycle tracking |
| `sponsorship_package` | Sponsorship | Package inventory and availability |
| `event` | Event | Top-level event record |
| `event_session` | Event | Programming sessions |
| `event_speaker` | Event | Speaker directory |
| `session_speaker` | Event | Session ↔ speaker junction |
| `matchmaking_appointment` | Interaction | Scheduled B2B meetings |
| `agreement` | Agreement | Contract records |
| `agreement_term` | Agreement | Individual contract terms |

---

## Cross-Context Relationships

The `context_edge` table captures typed relationships between entities across bounded contexts.

| Predicate | From → To | Meaning |
|-----------|-----------|---------|
| `exhibits_at` | exhibitor → edition | Exhibitor participation |
| `sponsors` | sponsor → edition | Sponsorship participation |
| `assigned_to` | space → exhibitor | Space assignment |
| `registered_for` | attendee → edition | Registration |
| `scanned_at` | lead → space | Lead capture location |
| `contracted_under` | exhibitor/sponsor → agreement | Agreement association |
| `invoiced_to` | transaction → party | Financial association |
| `presented_at` | speaker → session | Session participation |
| `related_to` | any → any | Generic association |

---

## PostgreSQL Upgrade Notes

When migrating from SQLite to PostgreSQL:

| SQLite | PostgreSQL | Tables Affected |
|--------|-----------|-----------------|
| `JSON` | `JSONB` | All (metadata, deliverables, etc.) |
| `INTEGER` (boolean) | `BOOLEAN` | All boolean columns |
| `TEXT` (timestamp) | `TIMESTAMPTZ` | All timestamp columns |
| `AUTOINCREMENT` | `GENERATED ALWAYS AS IDENTITY` | exhibitor_service_order.id, agreement_term.term_id |
| `datetime('now')` | `now()` | All default timestamps |

---

## Related

- [axpona-schema.sql](axpona-schema.sql) — SQL DDL
- [STRATEGIC_DDD.md](../STRATEGIC_DDD.md) — Strategic classification
- [UBIQUITOUS_LANGUAGE.md](../UBIQUITOUS_LANGUAGE.md) — Domain language
- [data-architecture-spec.md](../data-architecture-spec.md) — Pipeline organization and data flow
