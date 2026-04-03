# Strategic DDD — AXPONA

> **Version:** 1.0.0
> **Status:** Complete — validated against derivation rules (13/13 pass, 4 N/A)
> **Foundation:** [Four Data System Types](https://github.com/timjmitchell/docs-pr/blob/main/docs/SEMOPS_DOCS/SEMANTIC_OPERATIONS_FRAMEWORK/STRATEGIC_DATA/data-system-classification.md)
> **Derivation:** [bizbok-ddd-overlay-tradeshow.md](bizbok-ddd-overlay-tradeshow.md)
> **Validation:** [ddd-derivation-validation.md](ddd-derivation-validation.md)
> **Issue:** [research-pr#37](https://github.com/timjmitchell/research-pr/issues/37)

This document defines the strategic DDD classification for all AXPONA bounded contexts. It is the authoritative investment guide: where to build vs. buy vs. adopt standard patterns.

---

## Strategic Classification

```
CORE (competitive advantage — invest disproportionately)
├── Exhibitor          — marketplace supply side; rebooking rate is the canary
├── Sponsorship        — advertising/media; high-margin audience monetization
├── Exhibition Space   — floor plan optimization; listening room format is domain-specific
└── Event              — edition lifecycle; the project that produces the product

SUPPORTING (necessary but not differentiating — invest in reliability)
├── Attendee           — marketplace demand side; external vendor (Unity Event Solutions)
└── Interaction        — lead capture & matchmaking; badge scanning as service

GENERIC (commodity — buy or adopt standard patterns, don't build)
├── Agreement          — contract management (DocuSign/PandaDoc)
└── Finance            — accounting and payments (QuickBooks/Stripe)
```

### Investment Thesis

| Domain Type | Invest In | AXPONA Signal |
|---|---|---|
| **CORE** | Depth, relationships, domain expertise | Named sales team, 5 space types, 40+ sponsorship products, listening room format |
| **SUPPORTING** | Reliability, standard solutions | External ticketing vendor (Unity Events), badge scanning as a service |
| **GENERIC** | Off-the-shelf, don't build | Downloadable contracts, standard payment processing |

**The pattern:** AXPONA invests in supply-side and product domains (Exhibitor, Sponsorship, Exhibition Space, Event) and commoditizes demand-side operations (Attendee, Interaction) and back-office (Agreement, Finance).

---

## System Mix

> Source: data-system-classification → business type: `events_project`

| System Type | Weight | Interpretation |
|---|---|---|
| **Work** | **40%** | Event planning, logistics, vendor coordination — **dominant** |
| Record | 25% | Contracts, invoices, compliance docs |
| Application | 20% | Registration, exhibitor portals, badge scanning |
| Analytics | 15% | Post-show reporting, exhibitor ROI |

AXPONA is **Work-dominant**. Most value creation happens in logistics, vendor coordination, and project management — not in application CRUD or real-time analytics.

---

## Bounded Context Definitions

### Exhibitor Context — Marketplace Supply Side (CORE)

**Aggregate Root:** Exhibitor
**Owns:** Exhibitor lifecycle, profile, rebooking, priority points, service orders, product listings, lead retrieval licenses, packages
**Source:** Exhibitor CRM (likely Salesforce/HubSpot/spreadsheet), sales team
**Mutability:** Active lifecycle — prospecting through rebooking cycle

**Why CORE:** Exhibitors are the primary revenue source (space sales = 60%+ of revenue). The rebooking rate is confirmed at **80%** (client data + offering memorandum), with over 80% of exhibit revenue rebooking onsite and 50%+ cash collected within 4 months. This matches the CEIR industry average (~80%). Named sales team (Mark Freed, Ryan Pearson), 5 space types, and rebooking mechanics signal deep operational investment.

**Entities:**

| Entity | Role | States |
|---|---|---|
| Exhibitor | Aggregate Root | Prospected → Applied → Contracted → Confirmed → Attended → Rebooking |
| ExhibitorProfile | Entity | Draft → Published → Archived |
| RebookingRecord | Entity | Eligible → Offered → Accepted → Declined → Lapsed |
| PriorityPoints | Value Object | {points, earnedFromEditionId} |
| ProductListing | Entity | Submitted → Approved → Published → Archived |
| ServiceOrder | Entity | Requested → Confirmed → Fulfilled → Invoiced |
| LeadRetrievalLicense | Entity | Purchased → Activated → Expired |
| ExhibitorPackage | Value Object | {space, services[], sponsorshipAddOns[], totalPrice} |

**Metrics:** Supply growth, repeat/rebooking rate, floor plan liquidity, time-to-close, average contract value, services attach rate, package vs a-la-carte ratio

**Four Data System Type:** Work (sales pipeline, vendor coordination, relationship management)

---

### Sponsorship Context — Advertising/Media Lens (CORE)

**Aggregate Root:** Sponsorship
**Owns:** Sponsorship lifecycle, deliverables, packages
**Source:** Sponsorship tracking (likely spreadsheet), sales team
**Mutability:** Edition-bound lifecycle from proposal through delivery verification

**Why CORE:** Sponsorship is high-margin revenue (advertising model, weight 0.25). 40+ items across 6 categories ($500–$12,000) with heavy "SOLD" markers on premium inventory — demand exceeds supply. Granular product catalog and exclusivity premiums signal sophisticated monetization of audience attention.

**Entities:**

| Entity | Role | States |
|---|---|---|
| Sponsorship | Aggregate Root | Proposed → Sold → Contracted → Active → Delivered → Reported |
| SponsorshipDeliverable | Entity | Contracted → In-Production → Delivered → Verified |
| SponsorshipPackage | Value Object | {tier, price, deliverables[], exclusivityFlag} |

**Metrics:** Fill rate (slots sold/available), CPM equivalent, yield, renewal rate, upsell rate (tier upgrades)

**Four Data System Type:** Work (tracking, deliverable coordination)

---

### Exhibition Space Context (CORE)

**Aggregate Root:** ExhibitionSpace
**Owns:** Space inventory, assignments, floor plan versions, dimensions
**Source:** Floor plan system (manual or specialized tool)
**Mutability:** Edition-bound lifecycle — planned through vacated

**Why CORE:** The listening room format is domain-specific to audio trade shows and cannot be replicated by generic organizers. Floor plan optimization directly drives revenue (revenue per sqft) and exhibitor satisfaction (adjacency, traffic flow).

**Entities:**

| Entity | Role | States |
|---|---|---|
| ExhibitionSpace | Aggregate Root | Planned → Available → Reserved → Assigned → Occupied → Vacated |
| SpaceAssignment | Entity | Reserved → Confirmed → Occupied → Vacated |
| SpaceDimensions | Value Object | {width, depth, sqft, cornerFlag, electricalAccess} |

**Space types:** listening_room, expo, ear_gear, car_audio, alti

**Metrics:** Liquidity (fill %), revenue per sqft, assignment cycle time

**Four Data System Type:** Work (floor plan management, assignment workflow)

---

### Event Context (CORE)

**Aggregate Root:** Event
**Owns:** Edition lifecycle, programming (sessions, speakers), floor plan versions, milestone tracking
**Source:** Event management (internal), venue coordination
**Mutability:** Edition-bound project lifecycle

**Why CORE:** Each annual edition is a discrete project with its own P&L. 17 editions (2026), multi-venue logistics, deep programming (sessions, speakers, demos). The Event context is the project container that produces the product.

**Entities:**

| Entity | Role | States |
|---|---|---|
| Event | Aggregate Root | Planning → Open → Live → Post-Show → Archived |
| EventEdition | Entity | Announced → Scheduled → Completed |
| Session | Entity | Proposed → Confirmed → Scheduled → Live → Completed |
| Speaker | Entity | Invited → Confirmed → Presented |
| FloorPlan | Entity | Draft → Published → Final → Archived |

**Metrics:** Project margin (edition P&L), on-time delivery, attendee-to-exhibitor ratio

**Four Data System Type:** Work (project management, logistics coordination)

---

### Attendee Context — Marketplace Demand Side (SUPPORTING)

**Aggregate Root:** Attendee
**Owns:** Registration lifecycle, badge, ticket
**Source:** Unity Event Solutions (external ticketing vendor), registration website
**Mutability:** Edition-bound — registration through check-in

**Why SUPPORTING:** Attendees are the demand side of the marketplace — critical for exhibitor value proposition but not where AXPONA differentiates. Standard ticketing handled by external vendor (Unity Event Solutions). Attendee re-registration rate is **15%** — client confirms consumer demand is not a bottleneck. The show pays travel/lodging for key press and influencers, ensuring media coverage regardless of location. 85% of attendees are first-timers each year.

**Entities:**

| Entity | Role | States |
|---|---|---|
| Attendee | Aggregate Root | Registered → Ticketed → Checked-In → No-Show |
| Registration | Entity | Started → Completed → Confirmed → Checked-In |
| Badge | Value Object | {attendeeId, editionId, badgeType, accessLevel} |
| Ticket | Value Object | {ticketType, price, accessLevel} |

**Ticket types:** general_admission, friday_pass, saturday_pass, sunday_pass, vip, trade_pass

**Metrics:** Demand growth, buyer/seller ratio, conversion rate, ARPU, check-in rate, returning %

**Four Data System Type:** Application (registration system, badge management)

---

### Interaction Context — Lead Capture & Matchmaking (SUPPORTING)

**Aggregate Root:** Interaction
**Owns:** Lead records, matchmaking appointments, badge scan data
**Source:** Badge scanning vendor, lead retrieval system
**Mutability:** Event-time capture, post-show lifecycle

**Why SUPPORTING:** Lead capture and matchmaking are operational necessities that prove exhibitor ROI. Offered as a service (lead retrieval licenses sold to exhibitors), not a core competency. Badge scanning hardware and software are vendor-provided.

**Entities:**

| Entity | Role | States |
|---|---|---|
| Interaction | Aggregate Root | Planned → In-Progress → Past |
| LeadRecord | Entity | Captured → Qualified → Followed-Up → Converted → Dead |
| MatchmakingAppointment | Entity | Requested → Confirmed → Completed → No-Show |

**Metrics:** Leads per exhibitor, lead-to-conversion rate, matchmaking completion rate

**Four Data System Type:** Application (badge scanning, real-time capture)

---

### Agreement Context (GENERIC)

**Aggregate Root:** Agreement
**Owns:** Contract terms, lifecycle, payment schedules
**Source:** Contract management (DocuSign/PandaDoc), legal
**Mutability:** Ops-updated on contract changes

**Why GENERIC:** Standard contract management. Downloadable contracts, standard document workflow. Agreement context exposes Published Language consumed by Exhibitor, Sponsorship, and Finance.

**Entities:**

| Entity | Role | States |
|---|---|---|
| Agreement | Aggregate Root | Pending → In Force → Terminated → Abandoned |
| AgreementTerm | Entity | Pending → In Force → Terminated |

**Investment:** DocuSign, PandaDoc, or equivalent. Standard contract management.

**Four Data System Type:** Record (authoritative legal facts)

---

### Finance Context (GENERIC)

**Aggregate Root:** FinancialAccount
**Owns:** Financial transactions, payments, revenue allocation, invoicing
**Source:** Accounting system (QuickBooks/equivalent), payment processing
**Mutability:** Transaction-level updates

**Why GENERIC:** Standard payment and accounting. No competitive advantage from custom financial infrastructure. Revenue allocation (mapping exhibitor/sponsor/ticket payments to financial categories) is the only non-trivial integration.

**Entities:**

| Entity | Role | States |
|---|---|---|
| FinancialAccount | Aggregate Root | Pending → Open → Closed → Suspended |
| FinancialTransaction | Entity | Executed → Pending → Rejected → Cancelled |
| Payment | Aggregate | Unpaid → Paid → Settled / Cancelled → Reversed |
| MonetaryAmount | Value Object | {amount, currency} |

**Investment:** Stripe + QuickBooks (or equivalent). Standard payment and accounting.

**Four Data System Type:** Record (authoritative financial facts)

---

## Context Map

```
┌─────────────────────────────────────────────────────────────────────┐
│                          CORE DOMAIN                                │
│                                                                     │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────────────┐   │
│  │  SPONSORSHIP │    │    EVENT     │    │     EXHIBITOR        │   │
│  │              │    │             │    │                      │   │
│  │  40+ items,  │    │  edition    │    │  supply side,        │   │
│  │  6 categories│    │  lifecycle  │    │  rebooking cycle     │   │
│  └──────┬───────┘    └──────┬──────┘    └──────────┬───────────┘   │
│         │                   │                      │               │
│         │           Shared  │ Kernel        Customer│               │
│         │           Kernel  │                Supplier│               │
│         │                   │                      │               │
│         │            ┌──────▼──────┐               │               │
│         │            │ EXHIBITION  │◄──────────────┘               │
│         │            │   SPACE     │                               │
│         │            │             │                               │
│         │            │ floor plan, │                               │
│         │            │ assignments │                               │
│         │            └─────────────┘                               │
│         │                                                          │
└─────────┼──────────────────────────────────────────────────────────┘
          │
┌─────────┼──────────────────────────────────────────────────────────┐
│         │              SUPPORTING                                   │
│         │                                                          │
│  ┌──────▼───────┐    ┌──────────────┐                               │
│  │  ATTENDEE    │    │ INTERACTION  │                               │
│  │              │    │              │                               │
│  │  demand side,│    │ lead capture,│                               │
│  │  Unity Events│    │ badge scan   │                               │
│  └──────────────┘    └──────────────┘                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                          GENERIC                                    │
│  ┌──────────────┐    ┌──────────────┐                               │
│  │  AGREEMENT   │    │   FINANCE    │                               │
│  │              │    │              │                               │
│  │  contracts,  │    │  accounting, │                               │
│  │  DocuSign    │    │  QuickBooks  │                               │
│  └──────────────┘    └──────────────┘                               │
└─────────────────────────────────────────────────────────────────────┘
```

### Context Map Patterns

| Relationship | Pattern | Rationale |
|---|---|---|
| Exhibitor → Exhibition Space | Customer-Supplier | Exhibitor consumes space data via join by ID |
| Event → Attendee | Conformist | Attendee adopts `edition_id` from Event directly |
| Exhibition Space ↔ Event | Shared Kernel | `dim_edition` is a conformed dimension shared by both |
| Attendee → Finance | ACL | Revenue allocation translates ticket purchases to financial line items |
| Agreement → all consumers | Published Language | Canonical contract schema consumed by Exhibitor, Sponsorship, Finance |
| Sponsorship → Interaction | Customer-Supplier | Sponsorship consumes interaction metrics for ROI reporting |

---

## The Conformed Dimension: Edition

The **edition is the join key** across all contexts — the trade show equivalent of a SaaS monthly cohort. Every fact table, every metric, every cross-context analysis is organized by edition. This is the single shared reference all contexts agree on.

---

## Leading vs Lagging Indicators

| Leading (predictive) | Lagging (confirmatory) |
|---|---|
| Exhibitor rebooking rate (30 days post-show) | Next-year booth revenue |
| Sponsorship renewal rate | Next-year sponsorship revenue |
| Waitlist depth | Pricing power |
| Early-bird ticket velocity | Total attendance |
| Floor plan fill % at T-90 | Show quality |

**The single most important metric:** Exhibitor rebooking rate within 30 days of show close. Confirmed at **80%** (CEIR industry average). If this drops, everything else follows.

---

## Principles

1. **Partners fund the ecosystem.** Exhibitors and sponsors contribute 70-80% of revenue. Attendees are the draw, not the primary payer.

2. **Edition is the anchor.** Every analysis, every metric, every cross-context join is organized by edition. It is the conformed dimension.

3. **Rebooking rate is the canary.** The 30-day post-show rebooking rate predicts next-year revenue across all streams.

4. **Work systems dominate.** At AXPONA's scale (~25 employees, $5M-$20M), most "systems" are spreadsheets, email chains, and manual processes. The data architecture normalizes whatever format data arrives in.

5. **Listening rooms are domain-specific.** The private demo space format is unique to audio trade shows. Generic trade show organizers cannot replicate it. This is where Exhibition Space earns its CORE classification.

6. **BIZBOK types graduate to DDD contexts.** When a BIZBOK type (e.g., "Exhibitor" under Partner Management) has its own lifecycle, capabilities, invariants, and team ownership — it graduates from a type to a bounded context. This is the CIM→PIM mapping documented in the overlay.

---

## Related

- [classification.md](classification.md) — Formal classification inputs
- [axpona-reference-model.md](axpona-reference-model.md) — Engine-generated reference model (57 entities)
- [business-model-synthesis.md](business-model-synthesis.md) — Investment thesis and revenue analysis
- [bizbok-ddd-overlay-tradeshow.md](bizbok-ddd-overlay-tradeshow.md) — Full BIZBOK→DDD derivation
- [ddd-derivation-validation.md](ddd-derivation-validation.md) — Rule-by-rule validation (13/13 pass)
- [data-architecture-spec.md](data-architecture-spec.md) — Pipeline organization, dimensional models, data flow
