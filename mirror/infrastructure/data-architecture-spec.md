# AXPONA — Data Architecture Specification

> **Date:** 2026-03-16
> **Method:** [ddd-data-architecture.md](../../docs/research/ddd-data-architecture.md) + [mirror-architecture-solution.md](../../docs/research/mirror-architecture-solution.md)
> **DDD Source:** [bizbok-ddd-overlay-tradeshow.md](bizbok-ddd-overlay-tradeshow.md)
> **Classification:** [classification.md](classification.md)
> **Issue:** [research-pr#37](https://github.com/timjmitchell/research-pr/issues/37)

---

## Overview

This spec translates AXPONA's 8 DDD bounded contexts into a concrete data architecture: pipeline organization, dimensional models, integration patterns, domain events, and lineage. It then maps this architecture to the Mirror Architecture implementation — the running replica that serves as the assessment and diagnostic substrate.

### System Mix Context

AXPONA's system mix (20% App / 40% Work / 15% Analytics / 25% Record) means the data architecture is **Work-dominant**. Most value creation happens in logistics, vendor coordination, and project management — not in application CRUD or real-time analytics. The data architecture must capture the outputs of these work processes as authoritative facts.

---

## 1. Bounded Contexts → Pipeline Organization

### Source Systems (Staging Layer)

AXPONA's source systems map to the DDD contexts that own them:

| Source System | System Type | DDD Context | Staging Folder |
|---|---|---|---|
| Unity Event Solutions (ticketing) | Application | Attendee | `staging/unity_events/` |
| Exhibitor CRM (likely Salesforce/HubSpot/spreadsheet) | Application + Record | Exhibitor | `staging/exhibitor_crm/` |
| Sponsorship tracking (likely spreadsheet) | Work | Sponsorship | `staging/sponsorship/` |
| Floor plan system (manual or specialized) | Work | Exhibition Space | `staging/floorplan/` |
| Contract management (DocuSign/PandaDoc) | Record | Agreement | `staging/contracts/` |
| Accounting (QuickBooks/equivalent) | Record | Finance | `staging/accounting/` |
| Badge scanning / lead retrieval (vendor) | Application | Interaction | `staging/badge_scan/` |
| Event management (internal) | Work | Event | `staging/event_mgmt/` |

**Note:** At AXPONA's scale ($5M–$20M, ~25 employees), many of these "systems" are spreadsheets, email chains, or manual processes. The staging layer normalizes whatever format the data arrives in — CSV exports, API pulls, or manual entry.

### Medallion Layer Mapping

#### Current Implementation (Outside-In Phase)

The mirror currently operates in the outside-in phase — no client data access, so layers contain extraction outputs from public signals rather than source-system exports:

```
domain/                     ← Raw data sources (bronze)
  sources.json              ← Source manifest (29 crawl targets)
  *-raw.md                  ← Crawled markdown (website pages, forum threads)
  manifest.yaml             ← Layer manifest

staging/                    ← Structured extraction (silver)
  structured-extraction.json    ← Tier 1 regex extraction
  enriched-extraction.json      ← Tier 2 Ollama enrichment
  sentiment-extraction.json     ← Tier 3 Claude sentiment (202 records)
  exhibitor-extraction-test.json ← Tier 2 test run
  manifest.yaml             ← Layer manifest with pipeline + validation rules

intermediate/               ← Cross-source joins (planned)
  manifest.yaml             ← Join specs for entity resolution

marts/                      ← Analytical outputs (gold)
  business-model-synthesis.yaml  ← Business model analysis + investment thesis
  manifest.yaml             ← Layer manifest with synthesis rules

semantic/                   ← Metric definitions (planned)
  manifest.yaml             ← 8 priority metrics with formulas + fact sources
```

#### Target Design (Discovery Phase)

When real client data access is available, staging reorganizes by source system:

```
staging/                    ← Source-system organized (technical boundaries)
  unity_events/             ← Attendee registration data
  exhibitor_crm/            ← Exhibitor pipeline, contracts
  sponsorship/              ← Sponsorship inventory, deliverables
  floorplan/                ← Space assignments, floor plan versions
  contracts/                ← Agreement documents, terms
  accounting/               ← Financial transactions, invoices
  badge_scan/               ← Lead retrieval, badge scans
  event_mgmt/               ← Edition details, sessions, speakers

intermediate/               ← Domain-organized (semantic boundaries)
  exhibitor/                ← Exhibitor lifecycle joins, rebooking history
  sponsorship/              ← Package assembly, deliverable tracking
  exhibition_space/         ← Space utilization, assignment history
  event/                    ← Edition timeline, programming rollup
  attendee/                 ← Registration funnel, ticket mix
  interaction/              ← Lead aggregation, matchmaking completion
  cross_context/            ← Cross-domain joins (exhibitor × attendee × space)

marts/                      ← Domain-organized (bounded context outputs)
  exhibitor/                ← fct_exhibitor_edition, dim_exhibitor
  sponsorship/              ← fct_sponsorship_delivery, dim_sponsor
  exhibition_space/         ← fct_space_assignment, dim_space
  event/                    ← fct_edition_pnl, dim_edition
  attendee/                 ← fct_registration, dim_attendee
  interaction/              ← fct_lead_capture, dim_interaction
  finance/                  ← fct_transaction, dim_account
```

### Layer Ownership

| Layer | Owner | DDD Analog |
|---|---|---|
| Staging | Data team (or the person who exports CSVs) | ACL — translation zone |
| Intermediate | Domain owner + data team | Domain logic in new context |
| Marts | Domain owner | Published interface |
| Semantic layer | Platform/analytics team | Published Language |

---

## 2. Aggregates → Dimensional Models

Each DDD aggregate root becomes the grain of a fact table. The aggregate's entities and value objects inform dimensions and measures.

### Exhibitor Context — Marketplace Supply Side

**Fact: `fct_exhibitor_edition`** (grain: one row per exhibitor per edition)

| Column | Source | Type |
|---|---|---|
| `exhibitor_id` | Exhibitor aggregate root | FK → dim_exhibitor |
| `edition_id` | Event context reference | FK → dim_edition |
| `space_type` | Exhibition Space context | Degenerate dimension |
| `space_sqft` | SpaceDimensions VO | Measure |
| `contract_value` | Agreement context | Measure |
| `services_revenue` | ServiceOrder entities | Measure |
| `total_revenue` | Computed | Measure |
| `is_returning` | RebookingRecord | Boolean |
| `priority_points` | PriorityPoints VO | Measure |
| `days_to_close` |curl -i --proxy brd.superproxy.io:33335 --proxy-user brd-customer-hl_c5d249b9-zone-residential_proxy1:9kbt45ciuup4 -k "https://geo.brdtest.com/welcome.txt?product=resi&method=native" Exhibitor lifecycle timestamps | Measure |
| `rebooked_within_30d` | RebookingRecord state | Boolean |
| `contract_signed_date` | Agreement state transition | Date |
| `first_edition_year` | Exhibitor history | Slowly changing |

**Dimension: `dim_exhibitor`**

| Column | Source |
|---|---|
| `exhibitor_id` | Exhibitor aggregate root ID |
| `company_name` | ExhibitorProfile |
| `category` | ExhibitorProfile (audio, accessories, media, etc.) |
| `exhibitor_type` | Partner type (brand, dealer, distributor) |
| `first_edition` | Historical |
| `editions_attended` | Running count |
| `current_tier` | PartnerTier VO |

### Sponsorship Context — Advertising/Media Lens

**Fact: `fct_sponsorship_delivery`** (grain: one row per deliverable per edition)

| Column | Source | Type |
|---|---|---|
| `sponsorship_id` | Sponsorship aggregate root | FK |
| `sponsor_id` | Partner reference (by ID) | FK → dim_sponsor |
| `edition_id` | Event context reference | FK → dim_edition |
| `package_tier` | SponsorshipPackage VO | Degenerate dimension |
| `deliverable_type` | SponsorshipDeliverable entity | Degenerate dimension |
| `deliverable_value` | Package allocation | Measure |
| `estimated_impressions` | Package metadata | Measure |
| `exclusivity_flag` | SponsorshipPackage VO | Boolean |
| `delivery_status` | SponsorshipDeliverable state | Status |
| `is_renewal` | Sponsorship history | Boolean |
| `previous_tier` | Historical (for upgrade tracking) | Slowly changing |

### Attendee Context — Marketplace Demand Side

**Fact: `fct_registration`** (grain: one row per registration per edition)

| Column | Source | Type |
|---|---|---|
| `attendee_id` | Attendee aggregate root | FK → dim_attendee |
| `edition_id` | Event context reference | FK → dim_edition |
| `registration_date` | Registration entity | Date |
| `ticket_type` | Ticket VO | Degenerate dimension |
| `ticket_price` | Ticket VO | Measure |
| `acquisition_source` | Registration metadata | Degenerate dimension |
| `checked_in` | Registration state | Boolean |
| `days_attended` | Badge scan data | Measure |
| `is_returning` | Attendee history | Boolean |
| `editions_attended_total` | Running count | Measure |

### Event Context — Project Lens

**Fact: `fct_edition_pnl`** (grain: one row per edition)

| Column | Source | Type |
|---|---|---|
| `edition_id` | Event aggregate root | PK |
| `edition_year` | EventEdition entity | Dimension |
| `venue_cost` | Finance context | Measure |
| `marketing_spend` | Finance context | Measure |
| `operations_cost` | Finance context | Measure |
| `exhibitor_revenue` | Aggregate from fct_exhibitor_edition | Measure |
| `sponsorship_revenue` | Aggregate from fct_sponsorship_delivery | Measure |
| `ticket_revenue` | Aggregate from fct_registration | Measure |
| `total_revenue` | Computed | Measure |
| `total_cost` | Computed | Measure |
| `margin` | Computed | Measure |
| `attendee_count` | Aggregate | Measure |
| `exhibitor_count` | Aggregate | Measure |
| `sponsor_count` | Aggregate | Measure |

### Exhibition Space Context

**Fact: `fct_space_assignment`** (grain: one row per space per edition)

| Column | Source | Type |
|---|---|---|
| `space_id` | ExhibitionSpace aggregate root | FK → dim_space |
| `edition_id` | Event context reference | FK → dim_edition |
| `exhibitor_id` | SpaceAssignment reference | FK → dim_exhibitor |
| `space_type` | ExhibitionSpace type | Degenerate dimension |
| `sqft` | SpaceDimensions VO | Measure |
| `revenue_per_sqft` | Computed | Measure |
| `assignment_date` | SpaceAssignment state transition | Date |
| `floor_location` | AdjacentSpaces VO | Degenerate dimension |

### Interaction Context

**Fact: `fct_lead_capture`** (grain: one row per lead per edition)

| Column | Source | Type |
|---|---|---|
| `interaction_id` | Interaction aggregate root | PK |
| `exhibitor_id` | LeadRecord reference | FK → dim_exhibitor |
| `attendee_id` | LeadRecord reference | FK → dim_attendee |
| `edition_id` | Event context reference | FK → dim_edition |
| `scan_timestamp` | LeadRecord | Timestamp |
| `interaction_type` | Interaction type | Degenerate dimension |
| `lead_status` | LeadRecord state | Status |
| `space_id` | Interaction location reference | FK → dim_space |

### Shared Dimension: `dim_edition`

The **edition is the join key** across all contexts — the trade show equivalent of a SaaS monthly cohort.

| Column | Source |
|---|---|
| `edition_id` | EventEdition entity |
| `edition_year` | EventEdition |
| `edition_number` | Sequential (17th edition = 2026) |
| `venue_name` | Event context |
| `dates` | EventEdition scheduled dates |
| `days` | Duration |

---

## 3. Anti-Corruption Layers → Integration Patterns

Each source system requires an ACL at the staging boundary:

| Source → Target | ACL Strategy | Translation |
|---|---|---|
| Unity Events → Attendee staging | API extract or CSV export | Vendor schema → canonical registration schema. Map vendor ticket types to domain ticket types. |
| Exhibitor CRM → Exhibitor staging | API or export | Normalize company names, deduplicate across editions, map CRM stages to Exhibitor lifecycle states. |
| Badge scan vendor → Interaction staging | CSV/API | Raw scan events → LeadRecord format. Join badge IDs to attendee/exhibitor IDs. |
| QuickBooks → Finance staging | API or export | Chart of accounts → domain financial categories. Map line items to exhibitor/sponsor/attendee revenue streams. |
| Floor plan tool → Exhibition Space staging | Manual or export | Spatial data → space inventory with types, dimensions, assignment status. |
| Contract docs → Agreement staging | Document extraction | Extract agreement terms, dates, parties from contract metadata. |

**Key ACL principle:** Source systems own their schemas. The staging layer translates to domain vocabulary without modifying source data. This is the single-writer rule applied to data — each context writes only to its own staging models.

---

## 4. Context Map → Data Flow Architecture

The DDD context map translates to a data lineage graph:

```
                         DATA FLOW ARCHITECTURE
                         ═══════════════════════

  SOURCE SYSTEMS                    INTERMEDIATE                      MARTS
  ══════════════                    ════════════                      ═════

  Unity Events ──► stg_registration ──┐
                                      ├──► int_attendee_funnel ──► fct_registration
  Badge Scan ────► stg_badge_scan ────┤                              │
                                      └──► int_lead_rollup ─────► fct_lead_capture
                                                                     │
  Exhibitor CRM ► stg_exhibitor ──────┐                              │
                                      ├──► int_exhibitor_lifecycle ► fct_exhibitor_edition
  Floor Plan ───► stg_space ──────────┤                              │
                                      └──► int_space_utilization ──► fct_space_assignment
                                                                     │
  Sponsorship ──► stg_sponsorship ────► int_deliverable_tracking ──► fct_sponsorship_delivery
                                                                     │
  QuickBooks ───► stg_financial ──────► int_revenue_allocation ────► fct_edition_pnl
                                           (joins all revenue         │
                                            streams to edition)       │
  Contracts ────► stg_agreement ──────────────────────────────────────┘
                                                                     │
                                                                     ▼
                                                              SEMANTIC LAYER
                                                              ═════════════
                                                          Metric definitions:
                                                          • Rebooking rate
                                                          • Floor plan fill %
                                                          • Sponsorship sell-through
                                                          • Attendee growth YoY
                                                          • Services attach rate
                                                          • Edition margin
```

### Context Map Pattern → Data Integration Pattern

| DDD Pattern | Data Integration Equivalent |
|---|---|
| **Customer-Supplier** (Exhibitor → Exhibition Space) | `fct_exhibitor_edition` references `dim_space` by ID. Exhibitor mart consumes space data via join, not duplication. |
| **Conformist** (Event → Attendee) | Attendee staging adopts `edition_id` from Event context directly. No translation needed — edition is a shared reference. |
| **Shared Kernel** (Exhibition Space ↔ Event) | `dim_edition` is a conformed dimension shared by all marts. Both Exhibition Space and Event contexts contribute to it. |
| **ACL** (Attendee → Finance) | Revenue allocation intermediate model translates ticket purchases into financial line items with domain-appropriate categorization. |
| **Published Language** (Agreement → all consumers) | Agreement staging produces a canonical contract schema consumed by Exhibitor, Sponsorship, and Finance marts. |

---

## 5. Domain Events → Event-Driven Data Architecture

Each value stream stage exit produces domain events that become the primary data capture mechanism:

| Value Stream Stage | Domain Event | Data Capture |
|---|---|---|
| **Plan Show** | `FloorPlanPublished` | Snapshot floor plan version, space inventory → `stg_space` |
| **Plan Show** | `EventOpenedForRegistration` | Edition metadata, registration window → `stg_event_mgmt` |
| **Sell Space** | `SpaceAssigned` | Assignment record → `stg_space`, exhibitor status → `stg_exhibitor` |
| **Sell Space** | `AgreementActivated` | Contract terms, payment schedule → `stg_agreement`, `stg_financial` |
| **Market Show** | `RegistrationCompleted` | Registration + ticket → `stg_registration` |
| **Execute Show** | `EventConcluded` | Final attendee count, exhibitor count → edition summary |
| **Execute Show** | `LeadsCaptured` | Badge scan data batch → `stg_badge_scan` |
| **Retain & Grow** | `RebookingAccepted` | Rebooking record → `stg_exhibitor`, space reservation → `stg_space` |
| **Retain & Grow** | `ROIReportDelivered` | Per-exhibitor lead summary → `int_lead_rollup` |

**At AXPONA's scale:** These "events" are not streaming messages — they're batch captures at natural workflow transition points. A rebooking is recorded when the sales team logs it. Registration data arrives as a daily export from Unity Event Solutions. The event-driven model describes *what happened*, not *how it's transmitted*.

---

## 6. Mirror Architecture Implementation

The Mirror Architecture ([mirror-architecture-solution.md](../../docs/research/mirror-architecture-solution.md)) operationalizes this data architecture as a running replica. For AXPONA, this means:

### 6.1 Four-Step Mirror Workflow Applied

```
1. GENERATE     Classification → Reference Model → Predicted Schemas
                (Already done: classification.md → axpona-reference-model.md)
                Predicted: 8 contexts, 57 entities, 4 fact tables, 7 dimensions

2. SIMULATE     Predicted Schemas → Synthetic Data → Running Mirror
                SDV multi-table generation from dimensional models above
                Synthetic exhibitors, attendees, sponsorships, editions
                Referential integrity preserved across contexts

3. DISCOVER     Real System Access → Actual Schemas → Validated Mirror
                (Phase 2 — requires client engagement)
                Unity Events API → real registration schema
                Exhibitor CRM export → real pipeline schema
                QuickBooks export → real financial schema

4. DIAGNOSE     Predicted vs. Actual → Gap Analysis
                (Feeds Stage 5: TOGAF gap analysis)
                Divergences = consulting insights
```

### 6.2 Per-System-Type Mirror Strategy

| DDD Context | System Type | Mirror Strategy | What to Mirror |
|---|---|---|---|
| **Exhibitor** | Application + Work | CDC + Context APIs | CRM schema, pipeline stages, rebooking workflow |
| **Sponsorship** | Work | AI extraction + RAG | Sponsorship tracking structure, deliverable workflow |
| **Exhibition Space** | Work | AI extraction | Floor plan data model, space inventory, assignment rules |
| **Event** | Work | AI extraction | Edition timeline, programming structure, milestone tracking |
| **Attendee** | Application | CDC + Context APIs | Unity Events registration schema, ticket types, badge data |
| **Interaction** | Application | CDC + Context APIs | Badge scan schema, lead record format |
| **Agreement** | Record | ACL + Translation | Contract terms structure, payment schedule format |
| **Finance** | Record | ACL + Translation | Chart of accounts, revenue categorization, invoice schema |

### 6.3 Initial Mirror Contents (Outside-In Phase)

Built entirely from the reference model and signal validation — no client data access required:

| Layer | Contents | Source |
|---|---|---|
| **Schemas** | 6 fact tables + 7 dimensions (from Section 2 above) | Reference model entities → table definitions |
| **Data** | Synthetic editions (2020–2026), ~200 exhibitors, ~10K attendees, ~40 sponsors per edition | SDV generation from dimensional models, constrained by observed scale |
| **Transforms** | dbt models for staging → intermediate → marts per the pipeline org above | Generated from the medallion mapping (Section 1) |
| **Lineage** | Data flow graph (Section 4) in OpenLineage format | Generated from dbt model dependencies |
| **Contracts** | ODCS data contracts per mart model | Schema + quality rules from reference model |

### 6.4 Synthetic Data Parameters

Derived from signal validation observations:

| Parameter | Value | Source |
|---|---|---|
| Editions | 7 (2020–2026) | Show history |
| Exhibitors per edition | 180–220 (growing) | 700+ brands, ~200 exhibiting per year |
| Attendees per edition | 6,000–11,000 (growing, COVID dip 2020–2021) | 10,910 in 2025 |
| Sponsors per edition | 30–50 | 40+ items observed |
| Space types | 5 (listening room, expo, ear gear, car audio, ALTI) | Pricing page |
| Ticket types | 6 | Pricing page |
| Sponsorship items | 40+ across 6 categories | Sponsorship catalog |
| Rebooking rate | ~80% (industry benchmark) | Trade Show Executive |
| Check-in rate | ~85% | Industry standard |

### 6.5 The Top-Down Advantage

The reference model provides the structural backbone that eliminates the hardest problem in bottom-up discovery (Section 7.7 of mirror-architecture-solution.md):

| Aspect | From Reference Model | From Real System Profiling |
|---|---|---|
| Table semantic meaning | Known — mapped from 8 DDD contexts | Confirmed or corrected |
| Cross-table relationships | Known — from aggregate boundaries | Validated against actual FKs |
| Business constraints | Known — from framework lookups | Extended by data inspection |
| Dimensional classification | Known — 6 fact tables, 7 dimensions | Confirmed by schema shape |
| **Distribution shapes** | Not available | **Uniquely from profiling** |
| **Actual cardinalities** | Estimated from industry benchmarks | **Real numbers** |
| **Schema drift** | Represents ideal state | **Reveals divergence** |

The gap between "should be" and "actually is" becomes the diagnostic output in Stage 5 (gap analysis).

---

## 7. Semantic Layer — Priority Metrics

From the business model synthesis, these metrics form the semantic layer's Published Language:

| Metric | Definition | Fact Source | Business Model |
|---|---|---|---|
| **Rebooking rate** | % exhibitors rebooked within 30 days of show close | `fct_exhibitor_edition.rebooked_within_30d` | Marketplace (supply retention) |
| **Floor plan fill %** | Assigned spaces / total spaces at T-90 | `fct_space_assignment` | Marketplace (supply capacity) |
| **Sponsorship sell-through** | Sold items / available items by category | `fct_sponsorship_delivery` | Advertising (demand) |
| **Attendee growth YoY** | Edition-over-edition attendee count change | `fct_registration` | Marketplace (demand growth) |
| **Services attach rate** | Services revenue / space revenue per exhibitor | `fct_exhibitor_edition` | Marketplace (ARPU) |
| **Edition margin** | (Total revenue - total cost) / total revenue | `fct_edition_pnl` | Project (profitability) |
| **Trade Pass growth** | YoY change in Trade Pass registrations | `fct_registration` where ticket_type = 'trade' | Marketplace (B2B engagement) |
| **Sponsor renewal rate** | % sponsors returning edition-over-edition | `fct_sponsorship_delivery.is_renewal` | Advertising (retention) |

---

## 8. Lineage — Not SSOT

Following the DDD principle (ddd-data-architecture.md Section 2): **lineage replaces SSOT**. There is no single canonical representation of "exhibitor" or "revenue." Instead:

- Each context owns its authoritative view (Exhibitor context owns exhibitor lifecycle; Finance context owns revenue recognition)
- Cross-context joins happen in the intermediate layer with explicit lineage
- The semantic layer enforces vocabulary (what "rebooking rate" means) without enforcing a single physical model
- The edition dimension (`dim_edition`) is the conformed dimension — the one shared reference all contexts agree on

This is particularly important for AXPONA because many "source systems" are spreadsheets maintained by different people. There is no master database to be the SSOT. Lineage traces which spreadsheet, which export, which manual entry produced each data point.

---

## Related

- [classification.md](classification.md) — Classification inputs
- [business-model-synthesis.md](business-model-synthesis.md) — Investment thesis and priority metrics
- [bizbok-ddd-overlay-tradeshow.md](bizbok-ddd-overlay-tradeshow.md) — DDD bounded contexts (Step 12 has fact tables)
- [ddd-derivation-validation.md](ddd-derivation-validation.md) — Rule validation
- [../../docs/research/ddd-data-architecture.md](../../docs/research/ddd-data-architecture.md) — Methodology
- [../../docs/research/mirror-architecture-solution.md](../../docs/research/mirror-architecture-solution.md) — Mirror Architecture implementation
