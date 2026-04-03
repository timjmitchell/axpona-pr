# Ubiquitous Language — AXPONA

> **Version:** 1.0.0
> **Status:** Complete
> **Bounded Context:** AXPONA (all contexts unless noted)
> **Derivation:** [bizbok-ddd-overlay-tradeshow.md](bizbok-ddd-overlay-tradeshow.md)

This document defines the domain language for the AXPONA trade show system. Terms here are authoritative within this engagement and are drawn from trade show industry vocabulary, BIZBOK capability maps, and UFI standards.

---

## Core Concepts

### Edition
A single annual instance of the AXPONA trade show. The **conformed dimension** — the join key across all bounded contexts. The trade show equivalent of a SaaS monthly cohort. Every fact table, every metric, every cross-context analysis is organized by edition. AXPONA 2026 is the 17th edition.

- **Aggregate Root** context: Event (CORE)
- **Referenced by:** All other contexts via `edition_id`

### Exhibitor
A company or brand that purchases space to display products at the show. The supply side of the marketplace. An Exhibitor has a multi-edition lifecycle (Prospected → Applied → Contracted → Confirmed → Attended → Rebooking) and accumulates priority points across editions.

- **Aggregate Root** for: Exhibitor context (CORE)
- **Referenced by:** Exhibition Space, Sponsorship, Interaction, Agreement, Finance

### Attendee
An individual who registers and attends the show. The demand side of the marketplace. Attendees are managed by an external vendor (Unity Event Solutions) reflecting their SUPPORTING classification.

- **Aggregate Root** for: Attendee context (SUPPORTING)
- **Referenced by:** Interaction, Finance

### Sponsor
An exhibitor or partner who purchases audience attention through sponsorship items. Sponsors operate within the advertising business model (weight 0.25). A Sponsor may also be an Exhibitor — the two contexts share a partner reference by ID, not by object navigation.

- **Aggregate Root context:** Sponsorship (CORE)

### Exhibition Space
A physical area within the venue assigned to an exhibitor. Five space types exist at AXPONA, including the domain-specific **listening room** format unique to audio trade shows.

- **Aggregate Root** for: Exhibition Space context (CORE)

---

## Space Types

| Type | Description | Typical Price |
|---|---|---|
| **Listening Room** | Private demo space for audio equipment. Domain-specific to audio trade shows. | $5,250 |
| **Expo Booth** | Standard exhibit hall booth. | $1,500–$3,500 |
| **Ear Gear Expo** | Headphone/portable audio demo area. | $1,500–$2,500 |
| **Car Audio** | Vehicle-based audio demonstration. | Varies |
| **ALTI Pavilion** | Premium lifestyle/luxury audio area. | Premium pricing |

---

## Ticket Types

| Type | Description | Price Range |
|---|---|---|
| **General Admission** | Single-day access | $32–$40 |
| **Friday Pass** | Friday-only access | $32 |
| **Saturday Pass** | Saturday-only access | $40 |
| **Sunday Pass** | Sunday-only access | $15 |
| **VIP** | Premium access, priority entry, exclusive events | $100–$150 |
| **Trade Pass** | Industry professional access (B2B) | Varies |

---

## Business Model Terms

### Two-Sided Marketplace
AXPONA's primary business model (weight 0.6). Exhibitors (supply) pay to access attendees (demand). Attendees pay for access to products. Network effects compound: more exhibitors → better experience → more attendees → higher exhibitor willingness to pay.

### UFI 5 S Revenue Model
Industry-standard revenue framework for exhibition organizers:

| Stream | AXPONA Expression | Weight |
|---|---|---|
| **Space** | Booth sales, demo rooms | Primary (marketplace) |
| **Services** | Lead retrieval, drayage, AV, packages | Growing (marketplace) |
| **Sign-up** | Tiered tickets (GA, VIP) | Secondary (marketplace) |
| **Sponsorship** | Packages, signage, branded experiences | High-margin (advertising) |
| **Subscription** | Podcast, ALTI Pavilion (emerging) | Future candidate |

### Rebooking Rate
The percentage of exhibitors who rebook space within 30 days of show close. **The single most important leading indicator.** Predicts next-year space revenue, sponsorship value, and attendee draw. Industry benchmark: ~80%.

### Services Attach Rate
Services revenue as a percentage of space revenue per exhibitor. Measures upsell effectiveness. Physical services (drayage, electrical) are low-margin pass-through; digital services (lead retrieval, analytics) are high-margin and organizer-owned.

### Floor Plan Fill %
Assigned spaces as a percentage of total spaces at T-90 (90 days before show). A leading indicator of show quality and revenue capacity.

### Sponsorship Sell-Through
Sold sponsorship items as a percentage of available items by category. Heavy "SOLD" markers on premium inventory indicate demand exceeds supply.

---

## Lifecycle Terms

### Value Stream Stages
The 5-stage value stream that produces each edition:

1. **Plan Show** — Floor plan published, registration opens
2. **Sell Space** — Exhibitor acquisition, space assignment, agreement activation
3. **Market Show** — Attendee registration, marketing campaigns
4. **Execute Show** — Live event, badge scanning, lead capture
5. **Retain & Grow** — Rebooking, ROI reporting, sponsorship renewal

### Domain Events
State transitions that produce data capture events:

| Event | Stage | What It Captures |
|---|---|---|
| `FloorPlanPublished` | Plan | Floor plan version, space inventory |
| `EventOpenedForRegistration` | Plan | Edition metadata, registration window |
| `SpaceAssigned` | Sell | Assignment record, exhibitor status |
| `AgreementActivated` | Sell | Contract terms, payment schedule |
| `RegistrationCompleted` | Market | Registration + ticket |
| `EventConcluded` | Execute | Final counts, summary |
| `LeadsCaptured` | Execute | Badge scan data batch |
| `RebookingAccepted` | Retain | Rebooking record, space reservation |
| `ROIReportDelivered` | Retain | Per-exhibitor lead summary |

---

## DDD Terms

### Aggregate Root
The primary entity in a bounded context that enforces invariants and is the unit of consistency. Cross-context references are by ID only — no object graph navigation across boundaries.

### Bounded Context
A semantic boundary around a coherent set of domain concepts. AXPONA has 8 bounded contexts: 4 CORE, 2 SUPPORTING, 2 GENERIC.

### Domain Type
Strategic classification of a bounded context:
- **CORE** — Competitive advantage. Build custom. (Exhibitor, Sponsorship, Exhibition Space, Event)
- **SUPPORTING** — Necessary, not differentiating. Buy or build good-enough. (Attendee, Interaction)
- **GENERIC** — Commodity. Buy off the shelf. (Agreement, Finance)

### Context Map Pattern
Integration patterns between bounded contexts:
- **Customer-Supplier** — One context consumes data from another (Exhibitor → Exhibition Space)
- **Conformist** — One context adopts another's model directly (Event → Attendee via edition_id)
- **Shared Kernel** — Both contexts share a common model (Exhibition Space ↔ Event via dim_edition)
- **ACL (Anti-Corruption Layer)** — Translation boundary (Attendee → Finance)
- **Published Language** — Canonical schema consumed by many (Agreement → Exhibitor, Sponsorship, Finance)

---

## Data Architecture Terms

### Medallion Architecture
Three-layer data pipeline organization:
- **Staging** — Source-system organized (technical boundaries). Normalizes whatever format data arrives in.
- **Intermediate** — Domain-organized (semantic boundaries). Cross-context joins with explicit lineage.
- **Marts** — Domain-organized (bounded context outputs). Fact and dimension tables.

### Conformed Dimension
A dimension shared across all marts. For AXPONA, `dim_edition` is the single conformed dimension.

### Semantic Layer
Published metric definitions that form the business vocabulary for analytics:
- Rebooking rate, floor plan fill %, sponsorship sell-through, attendee growth YoY, services attach rate, edition margin, trade pass growth, sponsor renewal rate

---

## Industry Terms

### CEIR Four-Metric Index
Industry gold standard for trade show health: Net Square Feet, Professional Attendance, Number of Exhibitors, Real Revenue. Tracked quarterly across 14 sectors by the Center for Exhibition Industry Research.

### Trade Show Executive
Industry publication that publishes show rankings, retention benchmarks, and growth metrics.

---

## Related

- [STRATEGIC_DDD.md](STRATEGIC_DDD.md) — Strategic classification with full entity definitions
- [classification.md](classification.md) — Formal classification inputs
- [business-model-synthesis.md](business-model-synthesis.md) — Revenue structure analysis
- [data-architecture-spec.md](data-architecture-spec.md) — Pipeline and dimensional model definitions
