# AXPONA (JD Events LLC)

> **Industry:** Trade shows (audio/hi-fi)
> **Classification:** B2B2C marketplace, events/trade_shows, audio vertical
> **Revenue:** $5M-$20M (estimated) | ~25 employees
> **Parent:** JD Events LLC, Fairfield CT (since 2002)
> **Portfolio:** AXPONA, Plant Based World Expo, Healthcare Facilities Symposium

## Company Overview

AXPONA is North America's largest consumer audio show, held annually in Chicago. It operates as a two-sided marketplace: exhibitors (700+ brands) pay for space to demo products, and attendees (10,910 in 2025, 5% YoY growth) pay for access. Sponsorship (40+ items, $500-$12K) and exhibitor services round out the revenue model.

**Competitive moat:** Niche monopoly -- no direct competitor at comparable scale in audiophile trade shows. The moat compounds through exhibitor network effects, 24 years of relationship depth, and the listening room format (private audio demo spaces) that generic trade show organizers cannot replicate.

**Hard problem:** Exhibitor lifecycle management. The rebooking rate within 30 days of show close is the single most important leading indicator -- confirmed at **80%** (at CEIR industry average), with over 80% of exhibit revenue rebooking onsite and 50%+ cash collected within 4 months. Attendee re-registration is 15%, but consumer demand is not the bottleneck -- the show pays travel/lodging for key press and influencers.

## Purpose

I am working for a consulting client who is purchasing this company and will be operating it. This repo is the beginning of building a knowledgebase and an operations based on SemOps for this company.

## Business Domains

The business breaks down into 8 functional areas, ranked by strategic importance:

| Domain | Importance | Why |
|--------|------------|-----|
| Exhibitor | Differentiating | Supply side -- 700+ brands, 5 space types, rebooking mechanics drive 70-80% of revenue |
| Sponsorship | Differentiating | Highest margin -- 40+ products, demand exceeds supply on premiums |
| Exhibition Space | Differentiating | The physical product -- listening rooms, expo hall, Ear Gear, Car Audio, ALTI |
| Event | Differentiating | Each annual edition is a discrete project with its own P&L and logistics |
| Attendee | Necessary | Demand side -- registration/ticketing handled by external vendor (Unity Event Solutions) |
| Interaction | Necessary | Lead capture and matchmaking -- sold as exhibitor service |
| Agreement | Commodity | Standard contract management |
| Finance | Commodity | Standard payment processing and accounting |

57 business entities were identified across these domains. See [docs/testing/axpona-reference-model.md](docs/testing/axpona-reference-model.md) for the full model and [mirror/bizbok-ddd-overlay.md](mirror/bizbok-ddd-overlay.md) for the formal DDD derivation.

## Key Findings

- **Sponsorship is a major revenue driver** -- 40+ items across 6 categories with heavy demand; premium inventory sells out
- **Revenue model maps cleanly** to the UFI 5 S framework: Space, Services, Sign-up, Sponsorship, Subscription
- **Tech stack is minimal** -- WordPress site, Unity Event Solutions for registration, no custom engineering

## Search Corpus

A searchable vector collection (`ephemeral_axpona` in Qdrant) was built from 18 web sources via Crawl4AI, producing 113 cleaned chunks. Source manifest: [mirror/domain/sources.json](mirror/domain/sources.json).

**Sources:** AXPONA marketing pages, exhibitor/sponsorship/ticket pricing pages, GlobeNewsWire press release (2025 attendance records), Head-Fi and AudioScienceReview forum threads, Stereophile and The Absolute Sound show reports.

**Example queries the corpus can answer:**
- "What space types and pricing does AXPONA offer exhibitors?" -- returns booth/room options from $1,500 to $5,250
- "What do attendees say about the show experience?" -- surfaces forum sentiment from audiophile communities
- "What record-breaking metrics did AXPONA report in 2025?" -- returns press release data (10,910 attendees, 700+ brands)
- "What sponsorship categories are available?" -- returns inventory across signage, digital, experiential, and more

A Neo4j knowledge graph was also extracted (92 nodes, 35 relationships) capturing brand-to-product links (e.g., TechDAS Air Force turntables, Constellation amplifiers), exhibitor details, and community member activity.

## Analysis Documents

### Analysis

| File | Description |
|------|-------------|
| [classification.md](classification.md) | Formal `Classification` object with field rationale |
| [business-model-synthesis.md](business-model-synthesis.md) | Investment thesis: revenue streams, competitive moat, hard problem, domain typing |
| [docs/testing/axpona-reference-model.md](docs/testing/axpona-reference-model.md) | Engine-generated reference model (57 entities, 8 domains, system mix, capabilities) |
| [mirror/bizbok-ddd-overlay.md](mirror/bizbok-ddd-overlay.md) | Full BIZBOK-to-DDD derivation -- the original worked example (DDD-specific terminology) |
| [mirror/data-architecture-spec.md](mirror/data-architecture-spec.md) | Medallion pipeline, dimensional models, integration patterns, mirror architecture |
| [gap-analysis.md](gap-analysis.md) | Gap analysis: top-down prediction vs. bottom-up signals, with priority roadmap |
| [docs/testing/tech-profile.md](docs/testing/tech-profile.md) | Tech stack profile (34 technologies detected across 18 URLs) |

### Process Validation

| File | What it tests |
|------|---------------|
| [docs/testing/axpona-signal-validation.md](docs/testing/axpona-signal-validation.md) | First full-cycle test of signal collection workflow (Issue #4) |
| [mirror/ddd-derivation-validation.md](mirror/ddd-derivation-validation.md) | DDD overlay validated against formalized derivation rules -- 13/13 pass (Issue #37) |
| [docs/testing/automated-vs-manual-validation.md](docs/testing/automated-vs-manual-validation.md) | Automated pipeline vs manual analysis comparison (Issue #39) |
| [docs/testing/graph-extract.md](docs/testing/graph-extract.md) | Neo4j entity extraction from ephemeral corpus (Issue #39) |
| [docs/testing/extraction-validation-report.md](docs/testing/extraction-validation-report.md) | Post-extraction validation heuristics evaluation (Issue #43) |
| [docs/testing/tier3-synthesis.md](docs/testing/tier3-synthesis.md) | Structured extraction validated against reference model (Issue #44) |

### Data

Raw scraped pages, structured extractions, and source manifests live in [data/](data/).

| File | Contents |
|------|----------|
| [mirror/domain/sources.json](mirror/domain/sources.json) | Ephemeral corpus source manifest (18 URLs) |
| [data/business-model-synthesis.yaml](data/business-model-synthesis.yaml) | Structured investment thesis schema |
| [mirror/staging/structured-extraction.json](mirror/staging/structured-extraction.json) | Extracted brands (588), sponsorships (51), tickets (6) |
| [mirror/staging/enriched-extraction.json](mirror/staging/enriched-extraction.json) | LLM-enriched version of structured extraction |
| [data/exhibitor-directory-raw.md](data/exhibitor-directory-raw.md) | Raw exhibitor-by-brand page |
| [data/sponsorship-inventory-raw.md](data/sponsorship-inventory-raw.md) | Raw sponsorship page |
| [data/ticket-pricing-raw.md](data/ticket-pricing-raw.md) | Raw ticket pricing page |
| [data/exhibitor-spaces-raw.md](data/exhibitor-spaces-raw.md) | Raw exhibit/space pricing page |
| [data/demographics-raw.md](data/demographics-raw.md) | GlobeNewsWire press release (2025 attendance records) |

## Related Issues

- [research-pr#37](https://github.com/timjmitchell/research-pr/issues/37) -- Pipeline formalization (5-stage method)
- [research-pr#39](https://github.com/timjmitchell/research-pr/issues/39) -- Ephemeral corpus collection and automated observe/diagnose
- [research-pr#41](https://github.com/timjmitchell/research-pr/issues/41) -- Tech stack profiling
- [research-pr#43](https://github.com/timjmitchell/research-pr/issues/43) -- Ingestion quality and extraction validation
- [research-pr#44](https://github.com/timjmitchell/research-pr/issues/44) -- Structured extraction from raw pages
- [research-pr#4](https://github.com/timjmitchell/research-pr/issues/4) -- Signal collection validation (original)
- [research-pr#21](https://github.com/timjmitchell/research-pr/issues/21) -- Pipeline validation (parent methodology)
