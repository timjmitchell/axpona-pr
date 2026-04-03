# BIZBOK → DDD Overlay: Trade Show Industry (AXPONA)

> Derived using BIZBOK Guide v14 methodology (§2.2, §2.5, §6.5) applied to an
> industry NOT covered by the BIZBOK reference models. Uses AXPONA (JD Events
> LLC) as the concrete example. Demonstrates that the derivation method is
> portable beyond the eight industries in Part 8.
>
> Companion to: [bizbok-ddd-overlay.md](bizbok-ddd-overlay.md) (Financial Services worked example)

---

## Method Recap

The BIZBOK derivation is mechanical (see companion doc for the 11-step table).
The key inputs are:

1. **Business objects** — the nouns the business manages
2. **Information concepts** — Primary (independent lifecycle) vs. Secondary (dependent)
3. **States and types** — per information concept
4. **Capability map** — L1 anchored to one business object each
5. **Value streams** — end-to-end value delivery decomposed into stages

For an uncovered industry, we supply these inputs ourselves using domain
knowledge, then the DDD mapping follows the same mechanical rules.

---

## Step 0: What Business Objects Does a Trade Show Company Manage?

Before drawing capabilities, identify the nouns. For AXPONA / trade shows:

| Business Object | Independent? | Already in Common Model? |
|----------------|-------------|------------------------|
| Event (the show itself) | Yes | Yes — Supporting tier |
| Exhibition Space (booth, pavilion, demo room) | Yes | No — new |
| Exhibitor (company showing products) | Debatable | No — type of Partner/Customer? |
| Attendee (person attending) | Debatable | No — type of Customer? |
| Sponsor (company buying visibility) | Debatable | No — type of Partner? |
| Session (talk, demo, panel) | Dependent on Event | No |
| Lead (captured attendee interest) | Dependent on Exhibitor + Attendee | No |
| Badge (access credential) | Dependent on Attendee + Event | No |
| Floor Plan (spatial layout) | Dependent on Event + Venue | No |

### The Typing Question

The BIZBOK has a firm rule (§2.2, Guideline 1):

> "Do not create typed variants like Retail Customer Management and Wholesale
> Customer Management — types belong in the information map, not the
> capability map."

This means:

- **Exhibitor** is a type of Partner (a legal entity involved with the organization)
- **Attendee** is a type of Customer (a legal entity that has an agreement)
- **Sponsor** is a type of Partner (with a sponsorship agreement)

The BIZBOK would keep them under Partner Management and Customer Management
with types in the information map, not as separate L1s.

**DDD disagrees.** We'll address this divergence in the overlay section below.

---

## Step 1: L1 Capability Map — Trade Shows

Starting from the Common Reference Model (§8.6), with trade-show adjustments:

```
┌─────────────────────────────────────────────────────────────┐
│                   STRATEGIC TIER                             │
│  (Same as Common Reference Model — stable across industries) │
│                                                              │
│  Strategy · Plan · Policy · Campaign · Brand · Market        │
│  Message · Research · Initiative · IP Rights · Business Entity│
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                     CORE TIER                                │
│  (Where trade show differentiation lives)                    │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  Event        │  │  Exhibition  │  │  Agreement   │       │
│  │  Management   │  │  Space Mgmt  │  │  Management  │       │
│  │  (PROMOTED)   │  │  (NEW)       │  │              │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  Customer    │  │  Partner     │  │  Product     │       │
│  │  Management  │  │  Management  │  │  Management  │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  Order       │  │  Channel     │  │  Interaction │       │
│  │  Management  │  │  Management  │  │  Management  │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   SUPPORTING TIER                            │
│                                                              │
│  Asset · Competency · Content · Decision · Facility ·        │
│  Finance · HR · Incident · Information · Inquiry ·           │
│  Job · Language · Legal Proceeding · Location ·              │
│  Schedule · Submission · Time · Training Course · Work       │
└─────────────────────────────────────────────────────────────┘
```

### Trade Show-Specific Changes from Common Model

| Change | Rationale |
|--------|-----------|
| Event Management **promoted** from Supporting → Core | Event IS the product — it's not an incidental occurrence, it's the entire business |
| Exhibition Space Management **added** to Core | Genuinely new business object — the allocatable unit within a venue (not the same as Facility, which is the building) |
| Interaction Management **elevated** within Core | Lead capture, badge scanning, matchmaking are core interactions, not supporting |

Everything else maps to the Common Reference Model. The strategic and
supporting tiers are stable — exactly as BIZBOK predicts.

---

## Step 2: Aggregate Roots from Business Objects

| L1 Capability | Aggregate Root | Business Object |
|--------------|----------------|-----------------|
| Event Management | `Event` | Event (the show) |
| Exhibition Space Management | `ExhibitionSpace` | Exhibition Space |
| Agreement Management | `Agreement` | Agreement (exhibitor/sponsor contracts) |
| Customer Management | `Customer` | Customer (attendees) |
| Partner Management | `Partner` | Partner (exhibitor companies, sponsors) |
| Product Management | `Product` | Product (the show, sponsorship packages) |
| Order Management | `Order` | Order (booth orders, ticket orders) |
| Channel Management | `Channel` | Channel (online, badge scan, mobile) |
| Interaction Management | `Interaction` | Interaction (lead capture, meetings) |

---

## Step 3-4: Information Map — Trade Shows

### Event Context

```
Event (Aggregate Root — Primary)
│  States: Planning → Open → Live → Post-Show → Archived
│  Types: Annual Conference, Exhibition, Hybrid
│  Invariant: only one edition can be Live at a time
│  L2 Capability: Event Management
│
├── EventEdition (Entity — Secondary)
│   e.g., AXPONA 2025, AXPONA 2026
│   States: Announced → Scheduled → Completed
│   Invariant: sequential numbering, dates don't overlap
│
├── Session (Entity — Secondary, has own lifecycle)
│   States: Proposed → Confirmed → Scheduled → Live → Completed
│   Types: Keynote, Panel, Demo, Workshop, Listening Session
│   References: speakerId, exhibitionSpaceId (by ID)
│   Invariant: scheduled time must fall within Event.Live window
│
├── Speaker (Entity — Secondary)
│   States: Invited → Confirmed → Presented
│   References: partnerId or external
│
├── FloorPlan (Entity — Secondary)
│   States: Draft → Published → Final → Archived
│   Invariant: total allocated space ≤ venue capacity
│
├── Badge (Value Object)
│   Immutable: {attendeeId, eventEditionId, badgeType, accessLevel}
│   Types: Attendee, Exhibitor, Press, VIP, Speaker
│
└── EventTheme (Value Object)
    Immutable: {name, description, year}
```

### Exhibition Space Context

```
ExhibitionSpace (Aggregate Root — Primary)
│  States: Planned → Available → Reserved → Assigned → Occupied → Vacated
│  Types: Standard Booth, Island Booth, Pavilion, Demo Room, Listening Room
│  Invariant: one assignee per space per event edition
│  L2 Capability: Exhibition Space Management
│
├── SpaceAssignment (Entity — Secondary)
│   States: Reserved → Confirmed → Occupied → Vacated
│   References: partnerId (exhibitor), eventEditionId, orderId
│   Invariant: assignment requires a signed Agreement
│
├── SpaceDimensions (Value Object)
│   Immutable: {width, depth, sqft, cornerFlag, electricalAccess}
│
├── AdjacentSpaces (Value Object)
│   Immutable: {leftNeighborId, rightNeighborId, acrossId}
│   Used for: adjacency preferences, competitor separation rules
│
└── PriorityPoints (Value Object — AXPONA-specific)
    Immutable: {points, earnedFromEditionId}
    Used for: rebooking priority ranking
```

### Customer Context (Attendees)

```
Customer (Aggregate Root — Primary)
│  States: Suspect → Prospect → Active → Inactive
│  Types: Individual, Organization (from Common Model)
│  --- Trade show subtypes via information map: ---
│  Attendee Types: General, VIP, Press, Industry
│  L2 Capability: Customer Management
│
├── Registration (Entity — Secondary)
│   States: Started → Completed → Confirmed → Checked-In → No-Show
│   Types: Online, On-Site, Comp, Exhibitor-Invited
│   References: eventEditionId, orderId
│   Invariant: one registration per customer per event edition
│
├── Ticket (Value Object)
│   Immutable: {ticketType, price, accessLevel}
│   Types: Single-Day, Multi-Day, VIP, Exhibitor-Pass
│
└── AttendeePreference (Value Object)
    Immutable: {categories, brands, interests}
    Used for: matchmaking, personalized scheduling
```

### Partner Context (Exhibitors & Sponsors)

```
Partner (Aggregate Root — Primary)
│  States: Potential → Actual → Past (from Common Model)
│  Types: Supply, Distribution, Support (Common Model)
│  --- Trade show subtypes via information map: ---
│  Exhibitor Types: Brand, Dealer, Distributor, Media
│  Sponsor Types: Title, Gold, Silver, Bronze, In-Kind
│  L2 Capability: Partner Management
│
├── ExhibitorProfile (Entity — Secondary)
│   States: Draft → Published → Archived
│   References: productListingIds, exhibitionSpaceId
│   Contains: company description, categories, brands carried
│
├── ProductListing (Entity — Secondary)
│   States: Submitted → Approved → Published → Archived
│   References: productId
│   Invariant: must be approved before visible on event site
│
├── RebookingRecord (Entity — Secondary)
│   States: Eligible → Offered → Accepted → Declined → Lapsed
│   References: currentAssignmentId, nextEditionId
│   Contains: PriorityPoints (VO), preferred space
│
├── SponsorshipDeliverable (Entity — Secondary)
│   States: Contracted → In-Production → Delivered → Verified
│   Types: Logo Placement, Session Naming, Banner, Digital Ad, Email Blast
│   References: agreementId
│   Invariant: all deliverables must be Delivered before Event.Post-Show
│
└── PartnerTier (Value Object)
    Immutable: {tierName, benefits, minimumSpend}
```

### Agreement Context

```
Agreement (Aggregate Root — Primary)
│  States: Pending → In Force → Terminated → Abandoned (from Common Model)
│  Types: Bilateral, Multilateral, Express, Implied (Common Model)
│  --- Trade show subtypes: ---
│  Exhibitor Contract, Sponsorship Agreement, Venue Lease, AV Services
│  L2 Capability: Agreement Management
│
├── AgreementTerm (Entity — Secondary)
│   States: Pending → In Force → Terminated
│   Types: Survivable, Non-survivable
│   Examples: booth assignment clause, cancellation policy, rebooking rights
│
├── SponsorshipPackage (Value Object)
│   Immutable: {tier, price, deliverables[], exclusivityFlag}
│
└── MonetaryAmount (Value Object)
    Immutable: {amount, currency}
```

### Interaction Context (Leads & Matchmaking)

```
Interaction (Aggregate Root — Primary)
│  States: Planned → In-Progress → Past (from Common Model)
│  Types: Consultation, External, Internal, Meeting, Seminar (Common Model)
│  --- Trade show subtypes: ---
│  Lead Scan, Scheduled Meeting, Drop-In, Demo Request
│  L2 Capability: Interaction Management
│
├── LeadRecord (Entity — Secondary)
│   States: Captured → Qualified → Followed-Up → Converted → Dead
│   References: partnerId (exhibitor), customerId (attendee)
│   Contains: scan timestamp, notes, interest level
│   Invariant: one lead per exhibitor-attendee pair per event
│
├── MatchmakingAppointment (Entity — Secondary)
│   States: Requested → Confirmed → Completed → Cancelled → No-Show
│   References: partnerId, customerId, exhibitionSpaceId, timeSlot
│   Invariant: no double-booking per participant per time slot
│
└── InteractionNote (Value Object)
    Immutable: {timestamp, content, interactionType}
```

---

## Step 5: State Machines

### Event Lifecycle

```
            ┌──────────────┐
   ┌───────→│   Planning   │
   │        └──────┬───────┘
   │               │
   │     EventOpenedForRegistration
   │               │
   │        ┌──────▼───────┐
   │        │     Open     │ ← registrations + booth sales
   │        └──────┬───────┘
   │               │
   │         EventWentLive
   │               │
   │        ┌──────▼───────┐
   │        │     Live     │ ← the show is happening
   │        └──────┬───────┘
   │               │
   │        EventConcluded
   │               │
   │        ┌──────▼───────┐
   │        │  Post-Show   │ ← lead reports, surveys, rebooking
   │        └──────┬───────┘
   │               │
   │        EventArchived
   │               │
   │        ┌──────▼───────┐
   │        │   Archived   │
   │        └──────────────┘
   │
   └── (next edition created from Archived → Planning)
```

### Exhibition Space Lifecycle

```
   ┌──────────────┐
   │   Planned    │ ← floor plan drafted, spaces defined
   └──────┬───────┘
          │ SpaceMadeAvailable
   ┌──────▼───────┐
   │  Available   │ ← open for booking
   └──────┬───────┘
          │ SpaceReserved {partnerId, orderId}
   ┌──────▼───────┐
   │  Reserved    │ ← held pending contract
   └──────┬───────┘
          │ SpaceAssigned {agreementId}
   ┌──────▼───────┐        SpaceReservationExpired
   │  Assigned    │───────────────────────┐
   └──────┬───────┘                       │
          │ SpaceOccupied                 │
   ┌──────▼───────┐               ┌──────▼───────┐
   │  Occupied    │               │  Available   │
   └──────┬───────┘               └──────────────┘
          │ SpaceVacated
   ┌──────▼───────┐
   │   Vacated    │ ← teardown complete
   └──────────────┘
```

### Registration Lifecycle

```
   ┌──────────────┐
   │   Started    │ ← form begun
   └──────┬───────┘
          │ RegistrationCompleted {orderId}
   ┌──────▼───────┐
   │  Completed   │ ← payment received
   └──────┬───────┘
          │ RegistrationConfirmed {badgeId}
   ┌──────▼───────┐
   │  Confirmed   │ ← badge issued
   └──────┬───────┘
          │
    ┌─────┴──────┐
    │            │
    │  AttendeeCheckedIn    AttendeeNoShow
    │            │
    ▼            ▼
 Checked-In   No-Show
```

---

## Step 6: Value Stream — "Deliver Trade Show"

The primary value stream for a trade show company, decomposed into stages
with entrance/exit criteria that map to domain events:

```
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
│  Plan   │→│  Sell   │→│ Market  │→│ Execute │→│ Retain  │
│  Show   │  │  Space  │  │  Show   │  │  Show   │  │  & Grow │
└─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘
```

| Stage | Entrance Criteria | Capabilities Involved | Exit Criteria (Domain Event) |
|-------|-------------------|----------------------|------------------------------|
| Plan Show | Budget approved, venue selected | Event Mgmt, Facility Mgmt, Schedule Mgmt | `FloorPlanPublished`, `EventOpenedForRegistration` |
| Sell Space | Floor plan published | Exhibition Space Mgmt, Agreement Mgmt, Partner Mgmt, Order Mgmt, Product Mgmt | `SpaceAssigned`, `AgreementActivated` |
| Market Show | Exhibitor lineup confirmed | Campaign Mgmt, Customer Mgmt, Channel Mgmt, Content Mgmt | `RegistrationConfirmed` (volume target met) |
| Execute Show | Event goes live | Event Mgmt, Interaction Mgmt, Exhibition Space Mgmt, Customer Mgmt | `EventConcluded`, `LeadsCaptured` |
| Retain & Grow | Show concluded | Partner Mgmt, Agreement Mgmt, Research Mgmt, Finance Mgmt | `RebookingAccepted`, `ROIReportDelivered` |

### Cross-Aggregate Domain Events

```
EventOpenedForRegistration { eventEditionId, openDate }
  → Exhibition Space Mgmt: spaces transition to Available
  → Customer Mgmt: registration portal opens
  → Channel Mgmt: activate online registration channel

SpaceReserved { spaceId, partnerId, orderId }
  → Order Mgmt: create/update order
  → Agreement Mgmt: draft exhibitor contract
  → Partner Mgmt: update exhibitor status

AgreementActivated { agreementId, partnerId }
  → Exhibition Space Mgmt: transition space to Assigned
  → Finance Mgmt: invoice per payment schedule
  → Partner Mgmt: exhibitor confirmed

RegistrationCompleted { customerId, eventEditionId, orderId }
  → Finance Mgmt: process payment
  → Customer Mgmt: issue badge
  → Event Mgmt: increment attendee count

EventConcluded { eventEditionId }
  → Interaction Mgmt: finalize all lead records
  → Partner Mgmt: generate per-exhibitor lead reports
  → Exhibition Space Mgmt: all spaces → Vacated
  → Agreement Mgmt: check deliverable completion
  → Research Mgmt: trigger post-show survey

RebookingAccepted { partnerId, nextEditionId, spacePreference }
  → Exhibition Space Mgmt: early reservation for next edition
  → Agreement Mgmt: generate renewal contract
  → Partner Mgmt: accrue PriorityPoints
```

---

## Step 7: Saga — "Exhibitor Onboarding"

A cross-aggregate workflow coordinated by the value stream:

```
Trigger: ProspectIdentified { partnerId }

1. Partner Mgmt         → update Partner state to Actual
2. Product Mgmt         → present available packages (booth + sponsorship)
3. Order Mgmt           → create Order with selected items
4. Exhibition Space Mgmt → reserve requested space
   ├── IF space available → SpaceReserved
   └── IF waitlisted     → SpaceWaitlisted (compensating: hold deposit)
5. Agreement Mgmt       → generate exhibitor contract
6. Agreement Mgmt       → AgreementActivated (contract signed)
7. Exhibition Space Mgmt → SpaceAssigned (confirmed)
8. Finance Mgmt         → invoice, PaymentReceived
9. Partner Mgmt         → create ExhibitorProfile (for event website)
10. Channel Mgmt        → grant exhibitor portal access

Compensating Actions:
  - AgreementAbandoned → release space reservation, refund deposit
  - SpaceReservationExpired → notify partner, offer alternatives
  - PaymentFailed → suspend assignment, escalate to sales
```

---

## Step 8: The DDD Divergence — Where BIZBOK and DDD Disagree

This is the most instructive part of the overlay. The BIZBOK method keeps
Exhibitor, Attendee, and Sponsor as **types within Customer/Partner
Management**. DDD would split them into separate bounded contexts.

### BIZBOK View (Stable Capability Map)

```
Partner Management (L1)
  ├── Partner Definition
  ├── Partner Preference Management
  ├── Partner Risk Management
  ├── Partner Information Management
  └── (handles: exhibitors, sponsors, venue partners, AV vendors)
      ↳ differentiated by Type in the Information Map

Customer Management (L1)
  ├── Customer Definition
  ├── Customer Preference Management
  ├── Customer Information Management
  └── (handles: attendees, press, VIPs)
      ↳ differentiated by Type in the Information Map
```

### DDD View (Linguistic Precision)

```
Exhibitor Context (Bounded Context)
  Ubiquitous Language: booth, floor plan, rebooking, priority points,
                       product listing, lead report
  Team: Sales / Exhibitor Relations

Attendee Context (Bounded Context)
  Ubiquitous Language: registration, badge, check-in, session,
                       ticket type, matchmaking
  Team: Marketing / Registration Operations

Sponsorship Context (Bounded Context)
  Ubiquitous Language: package, deliverable, tier, placement,
                       exclusivity, ROI report
  Team: Sales / Sponsorship
```

### Why DDD Splits

| Signal | Evidence |
|--------|----------|
| **Different ubiquitous language** | "Booth assignment" vs. "registration" vs. "deliverable" — different teams use different words for their core workflows |
| **Different invariants** | Exhibitor: space must be assigned before profile published. Attendee: badge requires completed payment. Sponsor: all deliverables verified before post-show report. |
| **Different lifecycles** | Exhibitor: Prospected → Contracted → Attended → Rebooking. Attendee: Registered → Checked-In → Post-Survey. Sponsor: Pitched → Signed → Delivered → Renewed. |
| **Different team ownership** | In a 25-person company like JD Events, these are still managed by different people with different concerns |

### Why BIZBOK Doesn't Split

| Reason | BIZBOK Logic |
|--------|-------------|
| **Stability** | The capability map should survive org changes. If you merge the sales team, you don't want to refactor the map. |
| **No object duplication** | Exhibitor IS a Partner. Creating a separate L1 implies a separate business object, but it's the same legal entity. |
| **Types solve it** | The information map's Type field (Exhibitor, Sponsor, Attendee) handles the differentiation without L1 proliferation. |

### The Reconciliation

Both views are correct at different levels of abstraction:

```
BIZBOK Capability Map (stable, org-independent)
    │
    │  "Partner Management" as L1
    │
    ▼
DDD Context Map (team-aligned, implementation-ready)
    │
    ├── Exhibitor BC (implements Partner Mgmt for exhibitor type)
    ├── Sponsorship BC (implements Partner Mgmt for sponsor type)
    └── Attendee BC (implements Customer Mgmt for attendee type)
```

The BIZBOK map is the **CIM** (Computation-Independent Model) — what the
business does, independent of how it's organized.

The DDD context map is the **PIM** (Platform-Independent Model) — how the
domain is partitioned for implementation, aligned to team boundaries.

**Derivation rule:** When a BIZBOK type has its own lifecycle states, its own
L2 capabilities, its own invariants, AND is managed by a different team — it
graduates from a type to a DDD bounded context. The L1 stays unified in the
capability map, but splits at implementation.

---

## Step 9: Industry Context — Events (Parent Vertical)

Before analyzing the trade show revenue model specifically, we research **up the
vertical stack** to the parent industry. This reveals what is shared across all
event types vs what is unique to trade shows.

### Why This Matters

Business model understanding requires research at two levels:

1. **Parent industry** (Events) — shared revenue structures, industry benchmarks,
   standard metrics, governing bodies
2. **Specific vertical** (Trade Shows) — unique dynamics, leading indicators,
   competitive differentiators

Skipping the parent level is how AXPONA got misclassified as "transactional" —
the engine had no concept of how the events industry actually makes money.

### The UFI 5 S Revenue Model (Industry Standard)

UFI (The Global Association of the Exhibition Industry) developed the most
rigorous framework for organizer revenue. It applies across event types but with
different weights per vertical:

| Revenue Stream | Events (Industry) | Trade Shows | Conferences | Festivals |
|----------------|-------------------|-------------|-------------|-----------|
| **Space** Sales | 63% → 57% (declining) | Primary (booth) | Secondary (expo hall) | N/A |
| **Services** Sales | 13-16% (fastest growth) | High (logistics, AV, lead retrieval) | Medium (AV, F&B) | High (F&B, vendors) |
| **Sign-up** Sales | ~10% (growing) | Secondary (tickets) | Primary (registration 40-60%) | Primary (tickets 60-80%) |
| **Sponsorship** Sales | ~10% (steady) | Secondary (packages) | Growing (session sponsors) | Profit lever (10-35%) |
| **Subscription** Sales | ~4% (strategic) | Emerging (year-round) | Memberships (associations) | Rare |

**Structural shift:** Space sales are projected to drop below 50% in the early
2030s, with services and subscriptions gaining share. This is the industry moving
from transaction-based to relationship-based recurring revenue.

### CEIR Four-Metric Index (Industry Gold Standard)

CEIR (Center for Exhibition Industry Research, housed within IAEE) tracks four
core metrics quarterly across 14 industry sectors:

| CEIR Metric | Definition | Trade Show Context | Q4 2024 vs 2019 |
|-------------|-----------|-------------------|-----------------|
| Net Square Feet (NSF) | Exhibit space sold | Exhibition Space Context | +0.3% (recovered) |
| Professional Attendance | Verified attendee count | Attendee Context | -3.4% |
| Number of Exhibitors | Exhibiting companies | Exhibitor Context | -11.2% |
| Real Revenue | Inflation-adjusted total | Cross-context aggregate | -15.5% |

Note how the CEIR metrics map directly to our DDD bounded contexts. This is not
a coincidence — the industry naturally organizes its measurement around the same
business objects that DDD identifies as aggregate roots.

### Industry Benchmarks

| Metric | Benchmark | Source |
|--------|-----------|--------|
| Exhibitor retention rate | ~80% average — **AXPONA confirmed at 80%** (client data + offering memorandum) | Trade Show Executive; client |
| Large organizer EBITDA margin | 20%+ (Informa: 28% in 2024) | Informa FY2024 |
| Post-pandemic gross margin | 35-45% (down ~20pts from peak) | PCMA |
| Additional revenue per attendee | $26.62 avg beyond ticket | Bizzabo |
| Expense growth (post-COVID) | ~30% increase | CEIR |

### What's Shared vs What's Unique (Trade Shows)

| Dimension | Shared with Events Industry | Unique to Trade Shows |
|-----------|---------------------------|----------------------|
| Revenue model | Two-sided marketplace dynamics | Partner revenue dominance (70-80%) |
| Sponsorship | Advertising model (selling audience attention) | Tied to floor plan positioning |
| Metrics | CEIR four-metric index | Rebooking rate as leading indicator |
| Surfaces | Registration, badge scanning | Floor plan system, exhibitor portal |
| Project model | Each edition is a project with lifecycle | Year-round exhibitor relationship management |
| Margin structure | 20%+ EBITDA at scale | Sponsorship is the margin lever (near-zero variable cost) |

### Industry Bodies

| Organization | Focus | Key Publication |
|-------------|-------|-----------------|
| **UFI** | Exhibitions globally (772 orgs, 84 countries) | Global Exhibition Barometer, 5 S Model |
| **IAEE/CEIR** | U.S. exhibitions | CEIR Index (quarterly), CEIR Predict |
| **PCMA** | Conventions/meetings | State of the Industry report |
| **EIC** | Cross-industry standards | APEX standards, CMP certification |

---

## Step 10: Revenue Model — The Two-Sided Marketplace

The DDD context split isn't just a linguistic preference — it follows the money.

### Where Does Revenue Come From?

Trade shows are a **two-sided marketplace**. Both sides pay, but not equally:

```
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│   PARTNERS (Exhibitors + Sponsors)                          │
│   ═══════════════════════════════                            │
│   ~200 exhibitors × $2K-$10K+ per booth                     │
│   + sponsorship packages ($5K-$50K+)                         │
│   + add-ons (electricity, WiFi, lead scanners)              │
│   = PRIMARY REVENUE (70-80%)                                 │
│                                                              │
│              ┌──────────────────┐                            │
│              │   THE EXCHANGE   │                            │
│              │                  │                            │
│              │ Partners pay to  │                            │
│              │ access attendees │                            │
│              │                  │                            │
│              │ Attendees come   │                            │
│              │ to access        │                            │
│              │ partners'        │                            │
│              │ products         │                            │
│              └──────────────────┘                            │
│                                                              │
│   CUSTOMERS (Attendees)                                      │
│   ═════════════════════                                      │
│   ~6,000 attendees × $30-$100 per ticket                     │
│   = SECONDARY REVENUE (20-30%)                               │
│   = PRIMARY VALUE PROPOSITION to exhibitors                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

This creates a critical asymmetry:

- **Attendees are the product** — "6,000 qualified audiophiles will see your
  gear" is the pitch to exhibitors
- **Exhibitors are the revenue** — booth sales and sponsorships fund the show
- **Sponsorship is the margin** — pure visibility sales on top of booth revenue

### DDD Core Domain Classification (Revenue-Adjusted)

| Bounded Context | DDD Classification | Revenue Role | Investment Priority |
|----------------|-------------------|--------------|-------------------|
| Exhibitor | **Core Domain** | Primary revenue source | Highest — custom, deep modeling |
| Sponsorship | **Core Domain** | Highest-margin revenue | High — package design is competitive advantage |
| Exhibition Space | **Core Domain** | Constrains exhibitor revenue | High — floor plan optimization is IP |
| Event | **Core Domain** | The product itself | High — show quality drives both sides |
| Attendee | **Core Supporting** | Secondary revenue, primary draw | Medium — must execute well but process is standard |
| Interaction | **Core Supporting** | Enables exhibitor ROI proof | Medium — lead capture proves value to exhibitors |
| Agreement | Supporting | Contracts | Lower — standard legal workflows |
| Finance | Supporting | Payment processing | Lower — off-the-shelf |

**Key insight:** The Attendee context isn't a generic "Supporting" subdomain —
it's **core supporting** because attendee quality and volume directly
determine what exhibitors will pay. But the *processes* for managing attendees
(registration, badge, check-in) are relatively standard. The competitive
advantage is in the exhibitor and sponsorship contexts.

---

## Step 11: Bounded Context Entities and Due Diligence Signals

Each DDD bounded context has its own entities, relationships, and — crucially —
its own observable signals. When performing due diligence on a trade show
company, surface signals and internal intelligence naturally bucket into the
context that owns them.

### Exhibitor Context

```
Exhibitor Context (Bounded Context)
│
├── Entities
│   ├── Exhibitor (Aggregate Root)
│   │   States: Prospected → Applied → Contracted → Confirmed → Attended → Rebooking
│   │   Invariant: must have signed Agreement before space assigned
│   │
│   ├── ExhibitorProfile (Entity)
│   │   States: Draft → Published → Archived
│   │   Contains: company desc, categories, brands, product listings
│   │
│   ├── RebookingRecord (Entity)
│   │   States: Eligible → Offered → Accepted → Declined → Lapsed
│   │
│   └── PriorityPoints (Value Object)
│       Immutable: {points, earnedFromEditionId}
│
├── Relationships
│   ├── Exhibitor → ExhibitionSpace (via SpaceAssignment)
│   ├── Exhibitor → Agreement (1:many across editions)
│   ├── Exhibitor → Interaction (leads captured at booth)
│   └── Exhibitor → Product (listings for show guide)
│
├── Surface Signals (observable without internal access)
│   ├── Exhibitor count trend (year-over-year from archived show guides)
│   ├── Exhibitor mix (brands vs. dealers vs. distributors)
│   ├── Floor plan fill % (visible from published floor plan)
│   ├── Returning vs. new exhibitors (compare year-over-year lists)
│   ├── Booth size distribution (10x10 vs. islands — spend indicator)
│   └── Waitlist existence (mentioned in marketing = demand > supply)
│
└── Internal Intelligence (requires data access)
    ├── Rebooking rate (% that rebook within 30 days post-show)
    ├── Average contract value and trend
    ├── Exhibitor churn by category
    ├── Time-to-close (prospect → signed contract)
    ├── PriorityPoints distribution (loyalty concentration)
    └── Cancellation rate and timing
```

### Attendee Context

```
Attendee Context (Bounded Context)
│
├── Entities
│   ├── Attendee (Aggregate Root)
│   │   States: Registered → Ticketed → Checked-In → No-Show
│   │   Types: General, VIP, Press, Industry
│   │
│   ├── Registration (Entity)
│   │   States: Started → Completed → Confirmed → Checked-In
│   │   Invariant: one per attendee per edition
│   │
│   ├── Badge (Value Object)
│   │   Immutable: {attendeeId, editionId, badgeType, accessLevel}
│   │
│   └── Ticket (Value Object)
│       Immutable: {ticketType, price, accessLevel}
│
├── Relationships
│   ├── Attendee → Event (via Registration)
│   ├── Attendee → Interaction (leads captured by exhibitors)
│   └── Attendee → Session (via schedule/preferences)
│
├── Surface Signals
│   ├── Attendance count trend (published post-show, press coverage)
│   ├── Ticket price changes (year-over-year from website)
│   ├── Early-bird sellout speed (social media mentions)
│   ├── Geographic reach (attendee city data if published)
│   ├── Demographic profile (press releases, survey summaries)
│   └── Social media engagement (hashtags, posts, sentiment)
│
└── Internal Intelligence
    ├── Registration conversion rate (started → completed)
    ├── Check-in rate (registered → actually showed up)
    ├── Returning attendee % (multi-year retention)
    ├── Attendee-to-exhibitor ratio (quality of crowd for exhibitors)
    ├── Ticket type mix (VIP % = willingness to pay premium)
    └── No-show rate and trend
```

### Sponsorship Context

```
Sponsorship Context (Bounded Context)
│
├── Entities
│   ├── Sponsorship (Aggregate Root)
│   │   States: Proposed → Sold → Contracted → Active → Delivered → Reported
│   │   Types: Title, Gold, Silver, Bronze, In-Kind, Session Naming
│   │
│   ├── SponsorshipDeliverable (Entity)
│   │   States: Contracted → In-Production → Delivered → Verified
│   │   Types: Logo Placement, Banner, Digital Ad, Email, Session Naming
│   │   Invariant: all deliverables Delivered before post-show report
│   │
│   └── SponsorshipPackage (Value Object)
│       Immutable: {tier, price, deliverables[], exclusivityFlag}
│
├── Relationships
│   ├── Sponsorship → Partner (sponsor is a partner type)
│   ├── Sponsorship → Agreement (sponsorship contract)
│   ├── Sponsorship → Event (edition-specific)
│   └── Sponsorship → ExhibitionSpace (some packages include premium space)
│
├── Surface Signals
│   ├── Sponsor count and tier mix (visible on event website)
│   ├── Title sponsor continuity (same company year-over-year = stable)
│   ├── Sponsor category diversity (one industry vs. many)
│   ├── Sponsorship visibility (logos on website, emails, signage)
│   └── New sponsor acquisition (new logos appearing)
│
└── Internal Intelligence
    ├── Sponsorship revenue as % of total
    ├── Package upsell rate (Silver → Gold year-over-year)
    ├── Deliverable completion rate
    ├── Sponsor renewal rate
    ├── Average sponsorship contract value
    └── Custom package requests (demand exceeds standard tiers)
```

### Interaction Context (Leads & Matchmaking)

```
Interaction Context (Bounded Context)
│
├── Entities
│   ├── Interaction (Aggregate Root)
│   │   States: Planned → In-Progress → Past
│   │   Types: Lead Scan, Scheduled Meeting, Drop-In, Demo Request
│   │
│   ├── LeadRecord (Entity)
│   │   States: Captured → Qualified → Followed-Up → Converted → Dead
│   │   Invariant: one per exhibitor-attendee pair per event
│   │
│   └── MatchmakingAppointment (Entity)
│       States: Requested → Confirmed → Completed → No-Show
│       Invariant: no double-booking per participant per time slot
│
├── Relationships
│   ├── Interaction → Exhibitor (who captured the lead)
│   ├── Interaction → Attendee (whose badge was scanned)
│   └── Interaction → ExhibitionSpace (where it happened)
│
├── Surface Signals
│   ├── Lead retrieval service offered (visible on exhibitor kit)
│   ├── Matchmaking feature advertised (website)
│   ├── Post-show ROI stats published (press releases)
│   └── Exhibitor testimonials mentioning lead quality
│
└── Internal Intelligence
    ├── Leads per exhibitor (average, distribution)
    ├── Lead-to-conversion rate (if tracked post-show)
    ├── Matchmaking appointment completion rate
    ├── Badge scan volume per hour (engagement heat map)
    └── Exhibitor satisfaction with lead quality (survey)
```

### Leading vs. Lagging Indicators Across Contexts

```
LEADING (predictive)                    LAGGING (confirmatory)
═══════════════════                     ══════════════════════

Exhibitor rebooking rate ──────────────→ Next-year booth revenue
Sponsorship renewal rate ──────────────→ Next-year sponsorship revenue
Waitlist depth ────────────────────────→ Pricing power
Early-bird ticket velocity ────────────→ Total attendance

Floor plan fill % at T-90 ────────────→ Show quality
Exhibitor mix diversity ──────────────→ Attendee satisfaction
Sponsor tier upgrades ────────────────→ Perceived brand value

                    ┌──────────────────────────────────┐
                    │  THE LEADING INDICATOR:           │
                    │                                   │
                    │  Exhibitor rebooking rate          │
                    │  within 30 days of show close      │
                    │                                   │
                    │  If this drops, everything else    │
                    │  follows. It's the canary.         │
                    └──────────────────────────────────┘
```

---

## Step 12: Business Model Analytics Overlay

A trade show isn't a single business model — it's a **hybrid of three** from
the [Business Model Analytics](../research/business-model-analytics.md)
framework. The reference engine classified AXPONA as `transactional`
(Order, OrderItem, Cart). That's wrong. Each bounded context maps to a
different business model lens, and each lens brings its own metrics,
dimensions, and fact tables.

### Business Model Classification (Corrected)

| Business Model | Weight | Why It Applies |
|---------------|--------|---------------|
| **Marketplace/Platform** | Primary | Two-sided: exhibitors pay to access attendees, attendees pay to access products |
| **Advertising/Media** | Secondary | Sponsorship = selling audience attention to a captive, qualified audience |
| **Project/Bid-Based** | Tertiary | Each show edition is a project with lifecycle, milestone delivery, and margin |

### Metrics by Bounded Context × Business Model

#### Exhibitor Context — Marketplace Supply Side

| Metric | Source Framework | Definition | Trade Show Expression |
|--------|-----------------|------------|---------------------|
| Supply Growth | Marketplace | New sellers per period | New exhibitors per edition |
| Repeat Rate | Marketplace | % sellers with multiple transactions | Rebooking rate (within 30 days) |
| Liquidity | Marketplace | % listings that transact | Floor plan fill % |
| Time to Transaction | Marketplace | Listing → sale duration | Days from booth listing → signed contract |
| Churn | Marketplace | Sellers leaving platform | Exhibitors that don't rebook |
| AOV | Commerce | Average order value | Average exhibitor contract value |

**Fact Table — Exhibitor Revenue (edition grain):**

```
- exhibitor_id
- edition_id
- booth_type (standard, island, pavilion, demo room)
- contract_value
- add_on_revenue (electricity, wifi, lead scanners)
- total_revenue
- is_returning (boolean)
- priority_points
- days_to_close (prospect → signed)
- rebooked_within_30_days (boolean)
```

#### Attendee Context — Marketplace Demand Side

| Metric | Source Framework | Definition | Trade Show Expression |
|--------|-----------------|------------|---------------------|
| Demand Growth | Marketplace | New buyers per period | New attendees per edition |
| Buyer/Seller Ratio | Marketplace | Active buyers / active sellers | Attendee:Exhibitor ratio (~30:1) |
| Conversion Rate | Commerce | Purchases / visits | Registrations / website visitors |
| ARPU | Advertising | Revenue per user | Ticket revenue per attendee |
| DAU equivalent | Advertising | Daily active users | Daily attendance (3-day show) |
| Repeat Rate | Marketplace | % buyers returning | Returning attendee % |

**Fact Table — Attendee Registration (registration grain):**

```
- attendee_id
- edition_id
- registration_date
- ticket_type (single-day, multi-day, VIP, comp)
- ticket_price
- acquisition_source (organic, paid, exhibitor-invite, referral)
- checked_in (boolean)
- days_attended
- is_returning (boolean)
- editions_attended_total
```

#### Sponsorship Context — Advertising/Media Lens

| Metric | Source Framework | Definition | Trade Show Expression |
|--------|-----------------|------------|---------------------|
| Fill Rate | Advertising | Impressions sold / available | Sponsorship slots sold / available |
| CPM equivalent | Advertising | Cost per 1000 impressions | Sponsorship cost / (attendees × touchpoints) |
| Yield (eCPM) | Advertising | Effective revenue per impression | Sponsorship revenue / total attendee-impressions |
| Renewal Rate | Subscription | % customers renewing | Sponsor renewal year-over-year |
| Upsell Rate | Subscription | Expansion revenue | Sponsor tier upgrades (Silver → Gold) |
| ROAS proxy | Advertising | Return on ad spend | Sponsor-reported ROI from show |

**Fact Table — Sponsorship Delivery (deliverable grain):**

```
- sponsorship_id
- sponsor_id (partner_id)
- edition_id
- package_tier (title, gold, silver, bronze, in-kind)
- package_value
- deliverable_type (logo, banner, email, session_naming, signage)
- deliverable_status (contracted, in_production, delivered, verified)
- estimated_impressions
- exclusivity_flag (boolean)
- is_renewal (boolean)
- previous_tier (for upgrade tracking)
```

#### Event Context — Project/Bid-Based Lens

| Metric | Source Framework | Definition | Trade Show Expression |
|--------|-----------------|------------|---------------------|
| Project Margin | Project | (Revenue - costs) / revenue | Show edition P&L |
| Backlog | Project | Contracted unrecognized revenue | Rebooked exhibitors + renewed sponsors for next edition |
| On-Time Delivery | Project | Projects delivered by deadline | Show opens on scheduled date with all deliverables met |
| % Complete | Project | Progress against plan | Milestones: venue signed, floor plan published, X% spaces sold |
| Cost Overrun | Project | Actual / budgeted cost | Edition budget vs. actual |

**Fact Table — Edition P&L (edition grain):**

```
- edition_id
- edition_year
- venue_cost
- marketing_spend
- operations_cost (AV, staffing, logistics)
- exhibitor_revenue
- sponsorship_revenue
- ticket_revenue
- ancillary_revenue (food, merch)
- total_revenue
- total_cost
- margin
- attendee_count
- exhibitor_count
- sponsor_count
```

### The Dimensional Model

Across all contexts, the key dimensions are:

| Dimension | Type | Examples |
|-----------|------|---------|
| Edition | Time-variant | AXPONA 2024, 2025, 2026 |
| Exhibitor | Slowly changing | Company, category, size, years attending |
| Attendee | Slowly changing | Demographics, geography, ticket history |
| Sponsor | Slowly changing | Company, tier history, category |
| Exhibition Space | Event-specific | Booth ID, type, sqft, location on floor |
| Session | Event-specific | Track, type, speaker, time slot |
| Channel | Stable | Online, on-site, exhibitor-invite, social |

**The edition dimension is the join key** — everything rolls up to "how did
this edition perform vs. previous editions?" This is the trade show
equivalent of a SaaS company's monthly cohort analysis.

---

## Step 13: Surface-System Analytics Overlay

The [Surface-System Analytics](../research/surface-system-analytics.md)
framework adds another diagnostic layer: WHERE data is captured (the surface)
and WHAT system type it connects to. For trade shows, the surfaces are a
mix of digital and physical — and the physical surfaces have a unique
"runtime analytics blur" analogous to web A/B testing.

### Trade Show Surfaces

| Surface | System Type | Pattern | Bounded Context |
|---------|------------|---------|-----------------|
| Registration website | Application + Analytics (dual) | Web/Digital — multi-domain | Attendee |
| Exhibitor portal | Application + Analytics (dual) | Web/Digital — B2B side | Exhibitor |
| Badge scanning | Application + Record | POS-like — physical | Interaction |
| On-site registration | Application + Record | POS — physical | Attendee |
| Lead retrieval scanners | Application + Analytics | IoT-like — edge device | Interaction |
| Floor plan system | Application + Work | Work system — spatial inventory | Exhibition Space |
| Event mobile app | Application + Analytics (dual) | Mobile — contained | Attendee + Interaction |

### The Badge Scanning Blur

Badge scanning at a trade show is the physical-world equivalent of web
instrumentation — it's simultaneously **operational and analytical**:

```
Badge Scan Event
├── Operational (real-time, affects experience)
│   ├── Access control — is this person allowed in?
│   ├── Session check-in — mark attendee as present
│   └── Lead capture — exhibitor scans attendee badge
│
└── Analytical (measured, used for optimization)
    ├── Attendance tracking — how many showed up today?
    ├── Traffic flow — which areas are busiest at what times?
    ├── Dwell time — how long at each booth?
    ├── Lead quality — which attendees visited which exhibitors?
    └── Exhibitor ROI — leads captured per exhibitor
```

**The "no second chance" constraint applies:** If you didn't capture
booth-level badge scan timestamps during the show, you can NEVER
reconstruct exhibitor traffic patterns after. Just like a web experiment
that wasn't instrumented for device type — the data window is closed.

### Surface Diagnostic for Trade Show Due Diligence

What surfaces a trade show company invests in reveals their maturity:

| Surface Investment | Diagnosis |
|-------------------|-----------|
| Basic registration website only | Early stage — manual operations, no data culture |
| Registration + exhibitor portal | Growing — separate digital surfaces for each customer type |
| + Badge scanning with lead retrieval | Maturing — physical/digital integration, proving exhibitor ROI |
| + Mobile app with matchmaking | Advanced — real-time analytics blur, personalization |
| + IoT (traffic sensors, dwell tracking) | Sophisticated — physical analytics comparable to web analytics |

**For AXPONA:** Registration website + exhibitor portal + badge scanning
with lead retrieval = **maturing** stage. The absence of a dedicated mobile
app or IoT traffic tracking suggests room for growth in real-time
analytics at the show itself.

---

## AXPONA-Specific Concrete Example

Applying the full derivation to AXPONA (JD Events LLC):

### The Company

- ~25 employees, $5M-$20M revenue
- Annual 3-day audio/hi-fi trade show in Chicago
- ~200 exhibitors, ~6,000 attendees
- Revenue: exhibitor booth sales + sponsorship + ticket sales

### Context Map (DDD)

```
┌──────────────────────────────────────────────────────────────┐
│                    AXPONA Context Map                         │
│                                                              │
│  ┌─────────────┐  Customer/    ┌─────────────┐              │
│  │  Exhibitor  │──Supplier───→│  Exhibition  │              │
│  │  Context    │              │  Space       │              │
│  └──────┬──────┘              │  Context     │              │
│         │                     └──────┬───────┘              │
│    Conformist                        │                       │
│         │                    Shared Kernel                    │
│  ┌──────▼──────┐              ┌──────▼───────┐              │
│  │  Agreement  │◄─────────────│    Event     │              │
│  │  Context    │  Conformist  │   Context    │              │
│  └──────┬──────┘              └──────┬───────┘              │
│         │                            │                       │
│    Published                    Conformist                    │
│    Language                          │                       │
│         │                     ┌──────▼───────┐              │
│  ┌──────▼──────┐              │  Attendee   │              │
│  │  Finance    │◄────ACL──────│  Context    │              │
│  │  Context    │              └──────┬───────┘              │
│  └─────────────┘                     │                       │
│                                 Conformist                   │
│  ┌─────────────┐              ┌──────▼───────┐              │
│  │ Sponsorship │──Customer/──→│ Interaction  │              │
│  │  Context    │  Supplier    │  Context     │              │
│  └─────────────┘              └──────────────┘              │
└──────────────────────────────────────────────────────────────┘

Relationship Types:
  Customer/Supplier — upstream provides, downstream consumes
  Conformist — downstream adopts upstream's model
  Shared Kernel — co-owned model (Event is shared reference)
  Published Language — published API/schema
  ACL (Anti-Corruption Layer) — translation between models
```

### Scenario Walkthrough: "Exhibitor Books a Booth at AXPONA 2026"

```
1. Sales rep identifies prospect (audio dealer in Denver)
   → Partner Mgmt: Partner.state = Potential → Actual
   → Domain Event: PartnerQualified { partnerId, source: "sales outreach" }

2. Exhibitor selects 10x10 Standard Booth, requests Row A
   → Product Mgmt: lookup available packages
   → Exhibition Space Mgmt: check availability
   → Order Mgmt: OrderCreated { items: [booth-10x10], total: $3,200 }

3. Space reserved pending contract
   → Exhibition Space Mgmt: SpaceReserved { spaceId: "A-107", partnerId }
   → 72-hour hold timer starts

4. Contract generated and signed
   → Agreement Mgmt: AgreementActivated { type: "Exhibitor Contract" }
   → Exhibition Space Mgmt: SpaceAssigned { spaceId: "A-107" }

5. Invoice sent, payment received
   → Finance Mgmt: PaymentReceived { amount: $3,200, orderId }
   → Partner Mgmt: update ExhibitorProfile, grant portal access

6. Show day — exhibitor sets up in A-107
   → Exhibition Space Mgmt: SpaceOccupied { spaceId: "A-107" }

7. Attendee badges scanned at booth
   → Interaction Mgmt: LeadCaptured { partnerId, customerId, timestamp }

8. Show ends — leads delivered
   → Interaction Mgmt: LeadReportGenerated { partnerId, leadCount: 147 }
   → EventConcluded triggers RebookingWindowOpened

9. Exhibitor rebooks for AXPONA 2027
   → Partner Mgmt: RebookingAccepted { priorityPoints: 2 }
   → Exhibition Space Mgmt: early SpaceReserved for next edition
   → Agreement Mgmt: renewal contract generated

Total domain events in this flow: 12
Total aggregates touched: 7 (Partner, Order, ExhibitionSpace,
                              Agreement, Payment, Interaction, Event)
Total sagas: 1 (Exhibitor Onboarding → Show → Rebooking)
```

---

## Summary: What the Method Produces

Starting from zero BIZBOK coverage for trade shows, the derivation method
produced:

| Artifact | Count | Source |
|----------|-------|--------|
| L1 Capabilities (Core) | 9 | 7 from Common Model + 1 promoted + 1 new |
| L1 Capabilities (Total) | 30 | 11 Strategic + 9 Core + ~20 Supporting |
| Bounded Contexts (DDD) | 10-12 | 3 additional splits from BIZBOK typing rule |
| Aggregate Roots | 9 | One per L1 core capability |
| Primary Information Concepts | 9 | One per aggregate root |
| Secondary Information Concepts | ~15 | Dependent entities per context |
| Value Objects | ~10 | Immutable descriptors |
| Domain Events | ~15 | State transitions + cross-aggregate coordination |
| Value Stream Stages | 5 | Plan → Sell → Market → Execute → Retain |
| Sagas | 3-4 | Exhibitor Onboarding, Attendee Registration, Sponsorship Fulfillment, Rebooking |
| Due Diligence Signal Categories | 4 | One per core bounded context |

The method is portable. The same derivation used for Financial Services in the
companion doc works for an uncovered industry — you just supply your own
business objects and information concepts instead of reading them from Part 8.

Step 9 (Industry Context) establishes a critical methodological point: business
model understanding requires researching **up the vertical stack** — the parent
industry (Events) reveals shared revenue structures (UFI 5 S), standard metrics
(CEIR Index), and benchmarks that frame the specific vertical's unique dynamics.
Without this, you get misclassifications (AXPONA as "transactional").

Steps 10-11 show that DDD bounded contexts aren't just an implementation
convenience — they're the natural structure for due diligence signal collection.
Each context has its own surface signals (observable externally) and internal
intelligence (requires data access), and the signals cluster by context because
the entities and invariants are different.

**The single most important takeaway:** Exhibitor rebooking rate within
30 days of show close is the leading indicator for the entire business.
If that drops, attendee numbers, sponsorship revenue, and show quality
all follow. It lives in the Exhibitor Context — the core domain where
the money is.
