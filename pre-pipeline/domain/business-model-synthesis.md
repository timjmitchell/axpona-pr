# AXPONA — Business Model Synthesis

> **Date:** 2026-03-16
> **Method:** [business-model-synthesis.md](../../docs/research/business-model-synthesis.md)
> **Classification:** [classification.md](classification.md)
> **Signal Validation:** [axpona-signal-validation.md](../../docs/testing/axpona-signal-validation.md)
> **Issue:** [research-pr#37](https://github.com/timjmitchell/research-pr/issues/37)

---

## Investment Thesis Schema

Structured schema: [data/business-model-synthesis.yaml](data/business-model-synthesis.yaml)

---

## Synthesis Narrative

### Revenue Structure

AXPONA operates a classic two-sided marketplace where **partners fund the ecosystem**. Exhibitors and sponsors contribute an estimated 70–80% of revenue through space sales, services, and sponsorship. Attendee ticket revenue is secondary but critical — attendees are the draw that makes exhibitor investment worthwhile.

The revenue model maps cleanly to the UFI 5 S framework (industry standard for exhibition organizers):

| UFI Stream | AXPONA Expression | Domain Context |
|-----------|-------------------|----------------|
| **Space** | 5 space types, $1,500–$5,250 | Exhibition Space + Exhibitor |
| **Services** | Lead retrieval, drayage, AV, packages | Exhibitor (service orders) |
| **Sign-up** | 6 ticket types, $15–$150 | Attendee |
| **Sponsorship** | 40+ items, $500–$12,000 | Sponsorship |
| **Subscription** | Podcast, ALTI Pavilion (emerging) | Future context candidate |

### The Hard Problem: Exhibitor Lifecycle

For a tech company, the hard problem is typically algorithmic (classification, recommendation, matching). For AXPONA, the hard problem is **operational and relational**: managing the annual cycle of exhibitor acquisition, retention, and growth across 700+ brands while executing a complex multi-venue, multi-day physical event.

The rebooking rate within 30 days of show close is the canary in the coal mine — and it's now confirmed at **80%** (client data + offering memorandum: over 80% of exhibit revenue rebooks onsite, 50%+ cash collected within 4 months). This matches the CEIR industry average (~80%). It predicts:
- Next-year space revenue (primary revenue stream)
- Sponsorship inventory value (audience size determines sponsor willingness-to-pay)
- Attendee draw (exhibitor quality determines attendee experience)

Attendee re-registration is **15%**, which the client confirms is not a concern — consumer demand is not the bottleneck. The show pays travel/lodging for key press and influencers, ensuring coverage regardless of location. 85% of attendees are first-timers each year, meaning growth comes from expanding the addressable local market rather than retaining repeat visitors.

### Competitive Moat: Niche Monopoly

AXPONA's moat is not technological — it's **positional**. As North America's largest consumer audio show with a 24-year track record:

1. **No direct competitor at scale** — there is no equivalent audiophile trade show to switch to
2. **Network effects compound** — 700+ brands create the definitive annual gathering
3. **Format expertise** — the listening room model (private demo spaces) is specific to audio and cannot be replicated by generic trade show organizers
4. **Relationship depth** — 24 years of exhibitor relationships create trust and switching costs

This is a fundamentally different moat than a tech company. It's not defensible through IP or algorithms — it's defensible through market position, relationships, and domain expertise.

### Domain Typing Validation

The CORE/SUPPORTING/GENERIC classification aligns with where AXPONA invests:

| Domain | Type | Investment Signal |
|--------|------|-------------------|
| Exhibitor | CORE | Named sales team (Mark Freed, Ryan Pearson), 5 space types, rebooking mechanics |
| Sponsorship | CORE | 40+ products, 6 categories, granular pricing, heavy SOLD signals |
| Exhibition Space | CORE | Listening room format (domain-specific), floor plan optimization |
| Event | CORE | 17 editions, multi-venue logistics, programming depth |
| Attendee | SUPPORTING | External vendor (Unity Event Solutions), standard ticketing |
| Interaction | SUPPORTING | Badge scanning + lead retrieval as service, not core capability |
| Agreement | GENERIC | Downloadable contracts, standard document workflow |
| Finance | GENERIC | External payment processing, standard accounting |

The pattern is clear: **AXPONA invests in supply-side and product domains (Exhibitor, Sponsorship, Exhibition Space, Event) and commoditizes demand-side operations (Attendee, Interaction) and back-office (Agreement, Finance).**

---

## Related

- [classification.md](classification.md) — Structured classification inputs
- [axpona-reference-model.md](../../docs/testing/axpona-reference-model.md) — Engine-generated reference model
- [axpona-signal-validation.md](../../docs/testing/axpona-signal-validation.md) — Observable signal evidence
- [bizbok-ddd-overlay.md](mirror/bizbok-ddd-overlay.md) — DDD derivation (validated in Stage 3)
