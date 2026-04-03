# AXPONA — DDD Derivation Validation

> **Date:** 2026-03-16
> **Source:** [bizbok-ddd-overlay-tradeshow.md](bizbok-ddd-overlay-tradeshow.md)
> **Rules:** [ddd-derivation-rules.md](../../docs/research/ddd-derivation-rules.md)
> **Issue:** [research-pr#37](https://github.com/timjmitchell/research-pr/issues/37)

## Purpose

Validate the existing BIZBOK→DDD overlay (written before the derivation rules were formalized) against the current rule set. The overlay was the *first* worked example — the rules were later generalized from it and the financial services overlay, then cross-validated against BIAN, FHIR, ODA, and Context Mapper.

---

## Rule-by-Rule Validation

### Section 1: Bounded Context Identification

| Rule | Status | Evidence |
|------|--------|----------|
| **1.1 — Anchor Noun** | **Pass** | Each of 8 contexts is anchored to exactly one business noun: Exhibitor, Sponsorship, Exhibition Space, Event, Attendee, Interaction, Agreement, Finance. Each noun names the context and becomes the aggregate root. |
| **1.2 — Single-Writer** | **Pass** | Each context is the sole writer to its aggregate root. Cross-context references are by ID (e.g., Exhibitor references ExhibitionSpace by `exhibitionSpaceId`, not by navigating the space object). |
| **1.3 — Tier-to-Domain-Type** | **Pass** | 4 CORE (Exhibitor, Sponsorship, Exhibition Space, Event) + 2 SUPPORTING (Attendee, Interaction) + 2 GENERIC (Agreement, Finance). Mapping matches derivation rules: customer-facing/differentiating → CORE, operationally necessary → SUPPORTING, commodity → GENERIC. |

**Note on BIZBOK divergence:** The overlay explicitly documents (Step 8) that BIZBOK keeps Exhibitor/Sponsor/Attendee as *types* within Partner/Customer Management, while DDD splits them into separate bounded contexts. The overlay's resolution — "when a BIZBOK type has its own lifecycle states, its own L2 capabilities, its own invariants, AND is managed by a different team — it graduates from a type to a DDD bounded context" — is consistent with Rules 1.1 and 2.2. This is correctly identified as a CIM→PIM mapping.

### Section 2: Aggregate Boundary Rules

| Rule | Status | Evidence |
|------|--------|----------|
| **2.1 — Entity vs. Value Object** | **Pass** | Rubric correctly applied throughout. Examples: `Badge {attendeeId, editionId, badgeType, accessLevel}` = immutable, interchangeable by value → Value Object. `LeadRecord` has lifecycle states (Captured → Qualified → Followed-Up → Converted → Dead) → Entity. `SpaceDimensions {width, depth, sqft}` = immutable → Value Object. |
| **2.2 — Aggregate Root Signals** | **Pass** | Each aggregate root (Exhibitor, Sponsorship, ExhibitionSpace, Event, Attendee, Interaction, Agreement, FinancialAccount) has: (1) dedicated L2 capability, (2) independent lifecycle states, (3) multiple inbound references from other contexts, (4) at least one invariant. |
| **2.3 — Cross-Aggregate by ID** | **Pass** | Explicitly documented: `SpaceAssignment` references `partnerId`, `eventEditionId`, `orderId` by ID. `LeadRecord` references `partnerId` (exhibitor) and `customerId` (attendee) by ID. No object graph navigation across context boundaries. |

### Section 3: Context Map Pattern Selection

| Rule | Status | Evidence |
|------|--------|----------|
| **3.1 — Pattern Decision Tree** | **Pass** | Context map in Step 11 shows correct pattern application: Customer-Supplier (Exhibitor → Exhibition Space), Conformist (Event → Attendee), Shared Kernel (Exhibition Space ↔ Event), ACL (Attendee → Finance), Published Language (Agreement → Finance). |
| **3.2 — Pattern by Tier Pairing** | **Pass** | Core ← Core uses Partnership/Shared Kernel (Exhibition Space ↔ Event). Core ← Supporting uses Customer-Supplier (Sponsorship → Interaction). Supporting ← Generic uses Conformist + ACL (Attendee → Finance). |
| **3.3 — OHS/PL Signals** | **Pass** | Agreement context exposes Published Language — it is referenced by Exhibitor, Sponsorship, and Finance (fan-out ≥ 3). Event context is a shared reference (edition is the join key across all contexts). |

### Section 4: Domain Type → Pattern Selection

| Rule | Status | Evidence |
|------|--------|----------|
| **4.1 — Pattern Selection Matrix** | **Pass** | CORE contexts (Exhibitor, Sponsorship, Exhibition Space, Event) → build custom. SUPPORTING (Attendee, Interaction) → buy or build good-enough (Attendee uses Unity Event Solutions, external vendor). GENERIC (Agreement, Finance) → buy off-shelf (DocuSign, Stripe/QuickBooks). |
| **4.2 — Domain Type Classification Signals** | **Pass** | CORE signals met for all 4 core contexts: revenue-generating (Exhibitor, Sponsorship), industry-specific (Exhibition Space), product itself (Event). SUPPORTING signals met for Attendee/Interaction: required for operations, standard solutions exist. GENERIC signals met for Agreement/Finance: identical across industries, commodity SaaS exists. |

### Section 5: Domain Event and Saga Derivation

| Rule | Status | Evidence |
|------|--------|----------|
| **5.1 — Domain Events from Value Stream** | **Pass** | 5 value stream stages (Plan → Sell → Market → Execute → Retain) produce correctly named domain events: `FloorPlanPublished`, `SpaceAssigned`, `AgreementActivated`, `RegistrationConfirmed`, `EventConcluded`, `RebookingAccepted`. All follow `<Subject><PastTense>` convention. Cross-aggregate event propagation documented (e.g., `AgreementActivated` → Exhibition Space transitions to Assigned + Finance invoices). |
| **5.2 — Saga Participant Derivation** | **Pass** | "Exhibitor Onboarding" saga spans 6 bounded contexts (Partner, Product, Order, Exhibition Space, Agreement, Finance) with 10 steps. Compensating actions documented: `AgreementAbandoned` → release space, refund deposit. `SpaceReservationExpired` → notify partner. |

### Section 6: Agent Boundary Encoding

| Rule | Status | **Not applicable** |
|------|--------|----------|
| **6.1–6.4** | **N/A** | Agent boundary encoding (Issue #12) was added to the derivation rules *after* this overlay was written. The overlay does not include agent boundaries. This is expected — agent encoding is an extension, not a prerequisite for a valid DDD derivation. |

---

## Additional Content Beyond Rules

The overlay includes material that goes beyond the 11-step derivation but is valuable:

| Section | Content | Assessment |
|---------|---------|------------|
| Step 0 | Business object identification + BIZBOK typing question | Useful pre-derivation step; not in formal rules but sound methodology |
| Step 8 | BIZBOK↔DDD divergence analysis | Important contribution — documents CIM→PIM mapping rationale |
| Step 9 | Industry context (Events parent vertical) | UFI 5 S model, CEIR metrics — provides industry framing for domain typing |
| Step 10 | Revenue model (two-sided marketplace) | Revenue-driven domain classification — aligns with business model synthesis |
| Step 12 | Business model analytics overlay | Fact tables and dimensional model per context — feeds Stage 4 (data architecture) |
| Step 13 | Surface-system analytics overlay | Physical/digital surface mapping — enriches signal collection methodology |

---

## Validation Summary

| Category | Rules | Passed | Failed | N/A |
|----------|-------|--------|--------|-----|
| Bounded Context Identification | 1.1, 1.2, 1.3 | 3 | 0 | 0 |
| Aggregate Boundary | 2.1, 2.2, 2.3 | 3 | 0 | 0 |
| Context Map Patterns | 3.1, 3.2, 3.3 | 3 | 0 | 0 |
| Domain Type Selection | 4.1, 4.2 | 2 | 0 | 0 |
| Domain Events & Sagas | 5.1, 5.2 | 2 | 0 | 0 |
| Agent Boundaries | 6.1–6.4 | 0 | 0 | 4 |
| **Total** | **17** | **13** | **0** | **4** |

**Result: All applicable rules pass.** The 4 N/A rules (agent boundary encoding) are an extension added after this overlay was written and are not required for DDD derivation validity.

The overlay is not only compliant but exceeds the formal rules — it includes industry context, revenue model analysis, dimensional modeling, and surface-system mapping that enrich the derivation beyond the minimum specification.
