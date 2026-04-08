# AXPONA — Gap Analysis: Predicted vs. Observed

> **Date:** 2026-03-16
> **Method:** [togaf-gap-analysis.md](../../docs/research/togaf-gap-analysis.md)
> **Bottom-up (observed):** [axpona-signal-validation.md](../../docs/testing/axpona-signal-validation.md)
> **Top-down (predicted):** [axpona-reference-model.md](../../docs/testing/axpona-reference-model.md)
> **Issue:** [research-pr#37](https://github.com/timjmitchell/research-pr/issues/37)

---

## Overview

This analysis asks two questions and then compares the answers:

1. **Top-down: What should a company like this look like?** Based on AXPONA's industry (trade shows), business model (two-sided marketplace), and scale ($5M-$20M, ~25 people), what business domains, entities, capabilities, and infrastructure would we expect to find?
2. **Bottom-up: What's actually happening on the ground?** From publicly observable signals — pricing pages, press releases, forum discussions, tech stack detection — what can we confirm, and where does reality diverge from the prediction?

The gaps between these two views are where the interesting findings live: things the company should have but doesn't, things it has that we wouldn't expect, and things we can't see from the outside that warrant investigation.

> **Methodology note:** This follows the TOGAF Architecture Development Method (ADM) gap analysis technique — a standard enterprise architecture framework for comparing target state against baseline. We adapted it for external due diligence where the baseline comes from public signals rather than internal access.

---

## 1. Critical Metrics Not Visible from the Outside

These are the numbers that would determine whether AXPONA is healthy or in trouble — and none of them are publicly available:

| Metric | Why It Matters | What We Can See |
|---|---|---|
| **Exhibitor rebooking rate** | The single most important leading indicator — predicts next-year space revenue, which drives 60%+ of total revenue | **Confirmed: 80% re-registration rate** (client data + offering memorandum: "Over 80% of exhibit related revenue rebooks onsite"). Matches CEIR industry average (~80%) — at parity, not above |
| **Services attach rate** | Industry's fastest-growing revenue stream; measures how well AXPONA upsells beyond booth space | Not visible. Services exist (drayage, AV, lead retrieval) but pricing and uptake are not public |
| **Edition P&L** | Whether the show is actually profitable and how margins trend year-over-year | Not visible. Revenue is estimated ($5M-$20M) from space pricing × capacity + tickets + sponsorship |
| **Exhibitor churn** | Whether the 700+ brand count is growing organically or masking turnover | **Partially resolved:** 80% re-registration implies ~20% annual turnover — 140+ new brands needed per year to maintain 700+ count. Whether the brand count is growing net-positive remains unconfirmed |
| **CRM and data tooling** | Whether exhibitor relationships are managed systematically or in someone's head | Not visible. Could be Salesforce, HubSpot, or spreadsheets — each implies very different operational maturity |
| **Year-round engagement depth** | Whether the podcast and ALTI Pavilion are real revenue or marketing experiments | Not visible. They exist, but adoption and monetization are unknown |

**Update (2026-03-17):** Client data has resolved two of these: exhibitor rebooking rate is 80% (at CEIR industry average), and attendee re-registration is 15%. Client notes that attendee retention is not a concern — consumer demand is not the bottleneck, and the show pays travel/lodging for key press and influencers to ensure coverage regardless of location. The remaining metrics (services attach rate, edition P&L, CRM tooling, year-round engagement depth) are still unconfirmed.

Any diligence conversation with AXPONA management should start here. The public signals confirm the business model works — these metrics tell you *how well* it works.

---

## 2. Business Domains

```
                         TARGET (Predicted)
                    ┌───────────┬───────────┬───────────┬───────────┬──────────┬───────────┬───────────┬───────────┬─────────────┐
                    │ Exhibitor │Sponsorship│Exhibition │   Event   │ Attendee │Interaction│ Agreement │  Finance  │ Eliminated  │
    ┌───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
B   │ Exhibitor     │ Included  │           │           │           │          │           │           │           │             │
a   ├───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
s   │ Sponsorship   │           │ Included  │           │           │          │           │           │           │             │
e   ├───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
l   │ Exhibition    │           │           │ Included  │           │          │           │           │           │             │
i   │ Space         │           │           │           │           │          │           │           │           │             │
n   ├───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
e   │ Event         │           │           │           │ Included  │          │           │           │           │             │
    ├───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
(   │ Attendee      │           │           │           │           │ Included │           │           │           │             │
O   ├───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
b   │ Interaction   │           │           │           │           │          │ Included  │           │           │             │
s   │ (Partial)     │           │           │           │           │          │           │           │           │             │
e   ├───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
r   │ Agreement     │           │           │           │           │          │           │ Included  │           │             │
v   ├───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
e   │ Finance       │           │           │           │           │          │           │           │ Included  │             │
d   │ (Implied)     │           │           │           │           │          │           │           │           │             │
)   ├───────────────┼───────────┼───────────┼───────────┼───────────┼──────────┼───────────┼───────────┼───────────┼─────────────┤
    │ New           │           │           │           │           │          │           │           │           │             │
    └───────────────┴───────────┴───────────┴───────────┴───────────┴──────────┴───────────┴───────────┴───────────┴─────────────┘
```

**Result: All 8 predicted business domains confirmed.** No unpredicted domains and no predicted-but-absent domains observed. Two domains have reduced confidence:
- **Interaction:** Partially confirmed — lead retrieval mentioned in exhibitor kit but not directly demonstrated on website
- **Finance:** Implied — payment processing exists (Unity Event Solutions handles tickets) but no financial infrastructure directly observable

---

## 3. Entity Gap Matrix

### CORE Entities (21 predicted)

| Predicted Entity | Observed? | Evidence | Gap Status |
|---|---|---|---|
| Event | **YES** | 17th edition, annual cycle, multi-venue | Included |
| Exhibitor | **YES** | 700+ brands, 5 space types, named sales contacts | Included |
| Attendee | **YES** | 10,910 in 2025, 6 ticket types | Included |
| Booth/ExhibitionSpace | **YES** | 5 types ($1,500–$5,250), floor plan maps | Included |
| Registration | **YES** | Unity Event Solutions handles registration | Included |
| FloorPlan | **YES** | Maps published per venue area | Included |
| Session | **YES** | Seminars, Master Class Theater, concerts | Included |
| Sponsor | **YES** | 40+ items, 6 categories, heavy SOLD signals | Included |
| Venue | **YES** | Schaumburg Convention Center | Included |
| Badge | **Partial** | Gold Pass mentions "collector's badge" | Included (low detail) |
| Speaker | **YES** | Speakers page exists | Included |
| LeadRecord | **Partial** | Lead retrieval mentioned as exhibitor service | Included (inferred) |
| ServiceOrder | **YES** | Exhibitor services implied by space pricing | Included |
| Pavilion | **YES** | ALTI Pavilion (new 2026) | Included |
| RebookingRecord | **Confirmed: 80% re-registration** | Client data + offering memorandum; over 80% rebooks onsite, 50%+ cash collected within 4 months | Included |
| PriorityPoints | **Not observable** | Internal loyalty mechanic | Gap — internal only |
| SponsorshipItem | **YES** | 40+ individual items with pricing | Included |
| ProductListing | **Partial** | "Exhibitors by Brand" page exists | Included (basic) |
| MatchmakingAppointment | **Not observable** | Not mentioned on current site | Gap — may not exist |
| Listing | **YES** | Exhibitor directory on website | Included |
| Commission | **Not observable** | Internal financial structure | Gap — internal only |

**Summary: 16/21 CORE entities confirmed (RebookingRecord upgraded via client data), 2 not externally observable (by design), 1 may not exist (MatchmakingAppointment), 2 partially confirmed.**

### SUPPORTING Entities (16 predicted)

| Predicted Entity | Observed? | Gap Status |
|---|---|---|
| Customer | YES — attendees are customers | Included |
| Product | YES — the show, space types, sponsorship packages | Included |
| Order | Implied — ticketing and booth sales require orders | Included (inferred) |
| Partner | YES — exhibitors and sponsors | Included |
| Agreement | YES — exhibition contract downloadable | Included |
| Asset | Not observable | Gap |
| Employee | Not observable (no job postings found) | Gap — expected at scale |
| Account | Implied — financial accounts exist | Included (inferred) |
| Location | YES — venue, floor areas | Included |
| Facility | YES — Schaumburg Convention Center | Included |
| Channel | YES — online registration, on-site | Included |
| Accreditation | Not observable | Gap — may not apply |
| Operation | Implied — logistics exist | Included (inferred) |
| AdImpression | Not directly observable | Gap — sponsorship CPM not published |
| Campaign | Implied — marketing exists | Included (inferred) |
| AdPlacement | YES — 40+ sponsorship placements | Included |

### GENERIC Entities (20 predicted)

| Status | Count | Notes |
|---|---|---|
| Process-implied, not observable | 14 | Strategy, Initiative, KPI, Service, Portfolio, Requirement, Lead, Opportunity, Quote, Supplier, PurchaseOrder, ServiceRequest, SLA, Deliverable |
| Confirmed not applicable | 3 | Warehouse, Shipment, Inventory — APQC PCF 4.0 predicts these but trade shows don't have physical supply chains |
| Partially applicable | 3 | Case, Resolution, SatisfactionScore — customer service exists but formality unknown |

**Key finding: 3 GENERIC entities are false positives.** Warehouse, Shipment, and Inventory are structurally predicted by APQC PCF category 4.0 (Manage Supply Chain for Physical Products) but do not apply to trade shows. This confirms the reference model's confidence score (0.6) for process-implied entities — the low confidence correctly flagged uncertainty.

---

## 4. Technical Gap Matrix

### Data Management

For a $5M-$20M company with ~25 employees and no data roles, we'd expect minimal formal data management. Here's what we found:

| Area | Expected | Observed | Assessment |
|---|---|---|---|
| Data strategy | No formal strategy | No evidence of one | **As expected** — premature at this scale |
| Business data knowledge | Implicit, not formalized | Strong domain knowledge (5 space types, 40+ sponsorship items) but no formal data definitions | **As expected** — the business knows its data, just hasn't documented it |
| Data governance | None | None | **As expected** |
| Data architecture | Vendor-managed | WordPress + Unity Event Solutions + spreadsheets | **As expected** — minimal, appropriate |
| Data quality | No ownership | No evidence of quality processes | **As expected** — but this is where problems will surface first as the business grows |
| Data operations | Vendor-managed | Unity Event Solutions handles registration data lifecycle | **As expected** |
| Reporting & analytics | Manual/basic | Post-show reports exist (implied by exhibitor ROI mentions) but no analytics infrastructure | **As expected** — likely manual Excel work |

**Bottom line:** No surprises. Every area matches what you'd predict for a company this size. The one to watch is data quality — as exhibitor count grows, informal tracking of rebooking rates and services attach will break down.

### Tech Stack

| Expected | Observed | Assessment |
|---|---|---|
| Minimal custom tech | WordPress + external ticketing | **Match** — this is a logistics business, not a tech business |
| Registration handled externally | Unity Event Solutions | **Match** — commodity platform, no custom build |
| No public API | No API found | **Match** |
| 0-1 data headcount | 0 data roles | **Match** — analytics in spreadsheets, no one owns data quality |

---

## 5. Revenue Model

Comparing UFI 5 S predictions against observed revenue streams:

| UFI Stream | Predicted | Observed | Gap |
|---|---|---|---|
| **Space** | Primary (declining industry-wide, 63% → 57%) | Primary — 5 space types, $1,500–$5,250, 220+ rooms | **No gap** — fully confirmed. AXPONA's listening room format may resist the industry decline better than commodity booth shows. |
| **Services** | Growing (13–16%) | Implied — drayage, AV, lead retrieval, electrical mentioned in exhibitor context. Not separately priced publicly. | **Minor gap** — services exist but pricing/attach rate not observable. Industry trend suggests this should be growing. |
| **Sign-up** | Secondary (~10%) | 6 ticket types, $15–$150, 10,910 attendees | **No gap** — fully confirmed. Gen-Z ticket ($15) shows strategic thinking about audience renewal. |
| **Sponsorship** | Growing (~10%) | 40+ items, $500–$12,000, heavy SOLD signals | **Positive divergence** — sponsorship appears stronger than the 10% industry average. The depth of the catalog (6 categories, granular pricing) suggests this may be 15–20% of revenue. |
| **Subscription** | Emerging (~4%) | Audio Insider Podcast, ALTI Pavilion, merch shop | **Directionally confirmed** — early-stage signals of year-round engagement. Not yet a material revenue stream. |

---

## 6. Gaps, Solutions, and Priorities

### Gap Category Framework

| Category | Definition | Priority |
|---|---|---|
| **Structural** | Org/process problems — must fix to enable execution | High |
| **Operational** | Execution problems — drive metrics | Medium |
| **Strategic** | Differentiation problems — create value | Lower (for AXPONA's scale) |

### Consolidated Gap Matrix

| # | Gap | Category | Severity | Proposed Solution | Dependencies |
|---|---|---|---|---|---|
| G1 | **Exhibitor lifecycle tracking exists but formality unknown** — rebooking rate confirmed at 80% (at CEIR industry average), with over 80% of exhibit revenue rebooking onsite and 50%+ cash collected within 4 months. Whether this is tracked in a CRM or spreadsheets is still unknown. | Structural | Medium (downgraded from High) | Verify current tracking tooling. If informal, implement structured tracking to protect the 80% rate — especially critical if considering geographic expansion. | None |
| G2 | **Services attach rate not measurable** — exhibitor services revenue likely not tracked separately from space revenue | Operational | Medium | Separate services line items in exhibitor invoicing. Track services revenue as a distinct metric per exhibitor. Industry trend shows this is the fastest-growing revenue stream. | G1 (exhibitor tracking) |
| G3 | **Sponsorship deliverable tracking informal** — 40+ items across 6 categories likely tracked in spreadsheets without structured completion workflow | Operational | Medium | Formalize a deliverable checklist per sponsor: Contracted → In-Production → Delivered → Verified. This proves ROI to sponsors and supports renewal conversations. | None |
| G4 | **No unified edition P&L** — edition P&L likely assembled manually from separate sources (exhibitor revenue, sponsorship revenue, ticket revenue, costs) | Structural | Medium | Build a simple edition-level P&L that aggregates across all revenue streams. Even a well-structured spreadsheet would be a significant improvement. | G1, G2 |
| G5 | **Matchmaking capability absent** — not observed on the website | Operational | Low | Not a gap at current scale. Matchmaking becomes relevant when attendee count exceeds exhibitor discovery capacity. AXPONA's niche focus (audiophile community) may make organic discovery sufficient. | None |
| G6 | **Post-show analytics limited to basic reporting** — exhibitor ROI proof likely manual, no automated lead-to-conversion tracking | Strategic | Low | Implement structured post-show reporting: leads per exhibitor, attendance by day, session popularity. Even basic automated reports differentiate AXPONA from competitors who provide nothing. | G3 (sponsorship tracking), badge scan data |

### Priority Roadmap

```
NOW (no cost, high impact)
└── G1: Structure exhibitor lifecycle tracking (spreadsheet is fine)

NEXT (modest cost, builds on NOW)
├── G3: Formalize sponsorship deliverable tracking
├── G2: Separate services revenue tracking
└── G4: Build edition P&L view

LATER (requires investment or scale)
├── G6: Automated post-show analytics
└── G5: Matchmaking capability (if scale warrants)
```

---

## 7. Summary

### Where Prediction and Reality Align

1. **All 8 business domains confirmed** from public signals alone — the industry-based prediction accurately described how AXPONA is organized
2. **Operations-heavy, tech-light** — Work systems (40%) dominate with minimal custom technology, exactly as observed
3. **Revenue model matches industry pattern** — UFI 5 S framework accurately describes AXPONA's revenue streams
4. **No data team** — 0 data roles, analytics in spreadsheets, no one owns data quality (typical at this scale)
5. **Low data maturity across the board** — DCAM Level 1-2 across all components, as expected for a 25-person company

### Where Prediction and Reality Diverge

1. **Sponsorship is much bigger than expected** — the industry-based prediction suggested a sparse sponsorship function; reality shows 40+ items across 6 categories with active demand
2. **Some predicted entities don't apply** — Warehouse, Shipment, and Inventory are standard predictions for most businesses but trade shows don't have physical supply chains
3. **Matchmaking may not exist** — predicted as a key function but not observable on the website and possibly not implemented

### Coherence Assessment

| Dimension | Status | Evidence |
|---|---|---|
| Marketing vs. Reality | **Coherent** | "220+ listening rooms, 700+ brands" matches 2025 actuals (213 rooms, 700+ brands) |
| Scale vs. Infrastructure | **Coherent** | $5M–$20M with WordPress + external vendors = appropriate minimal tech |
| Revenue Model vs. Structure | **Coherent** | Partner-funded marketplace confirmed by pricing, sponsorship catalog, and ticket pricing |
| AI Claims | **N/A** | No AI/ML claims made — no coherence check needed |

---

## 8. Structured Extraction Update (Issue #44)

> **Date:** 2026-03-16
> **Source:** Three-tier structured extraction (regex → Ollama → Claude)
> **Full report:** [tier3-synthesis.md](../../docs/testing/tier3-synthesis.md)

The original gap analysis (sections 1–7) was conducted against the LLM-extracted knowledge graph (42 entities from 113 chunks). Issue #44 added structured extraction from dedicated page crawls, producing 955 typed Neo4j nodes and 1,937 relationships.

### Entity Evidence Upgrades

| Entity | Previous Status | New Status | New Evidence |
|---|---|---|---|
| ProductListing | Partial | **Confirmed with detail** | 588 brands across 15 product categories (Speakers 144, Amplifiers 109, DACs 82) |
| SponsorshipItem | Confirmed | **Confirmed with inventory** | 51 items, 6 categories, 47% sell-through, $105K+ min sold revenue |
| Attendee | Confirmed | **Confirmed with segmentation** | 6 ticket types with demographic targeting (Gen-Z, Trade, Gold Pass, $0–$150 range) |
| Exhibitor | Confirmed | **Confirmed with scale** | 309 unique exhibitors carrying 588 brands; top 5 exhibitors carry 27% of all brands |
| Listing | Confirmed | **Confirmed with structure** | Full brand directory with exhibitor→brand→location mapping |

**Updated CORE entity score: 17/21 confirmed (up from 15/21).** ProductListing upgraded from Partial; SponsorshipItem, Attendee, and Listing now have quantified evidence.

### Revenue Model Refinement (§5 Update)

| UFI Stream | Original Assessment | Updated Assessment |
|---|---|---|
| Space | Confirmed | **Confirmed with distribution**: 155 listening rooms, 29 expo hall, 26 ear gear, 19 premium rooms |
| Sponsorship | Positive divergence | **Quantified**: 51 items, $500–$12K range, $105K+ confirmed sold, ~$200–250K total inventory |
| Sign-up | Confirmed | **Detailed**: 6-tier pricing, 25–87% onsite premiums, VIP ($150) and B2B ($80) tiers |
| Services | Minor gap | Unchanged — not separately priced in public data |
| Subscription | Directionally confirmed | Unchanged |

### New Cross-Source Intelligence

- **Exhibitor concentration**: Top 5 exhibitors (Music Direct 70, Milwaukee Vintage 36, Playback Distribution 18, MoFi Distribution 17, Quintessence Audio 17) carry 27% of all brands — hub-and-spoke distribution model
- **Location distribution**: 50% listening rooms, 11% convention center, 9% expo hall, 8% ear gear, 6% premium rooms, 1% car audio
- **Sponsorship sell-through by category**: Signs & Graphics (9/17 sold), Around AXPONA (7/13), Glass Clings (4/6), Special Events (3/7), Digital (1/7) — physical signage sells best

### New Questions for Due Diligence

1. Space allocation logic for multi-brand exhibitors (70 brands → how much floor space?)
2. Sponsorship pricing optimization (47% sell-through suggests room to adjust)
3. Brand exclusivity terms in exhibitor agreements

---

## Related

- [classification.md](classification.md) — Classification inputs
- [business-model-synthesis.md](business-model-synthesis.md) — Investment thesis
- [bizbok-ddd-overlay.md](mirror/bizbok-ddd-overlay.md) — DDD derivation
- [ddd-derivation-validation.md](mirror/ddd-derivation-validation.md) — Derivation rule validation
- [tier3-synthesis.md](../../docs/testing/tier3-synthesis.md) — Tier 3 Claude synthesis report
- [data-architecture-spec.md](mirror/data-architecture-spec.md) — Data architecture (mirror architecture implementation)
- [axpona-reference-model.md](../../docs/testing/axpona-reference-model.md) — Target architecture (predicted)
- [axpona-signal-validation.md](../../docs/testing/axpona-signal-validation.md) — Baseline architecture (observed)
