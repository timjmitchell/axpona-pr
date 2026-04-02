# Signal Pattern Catalog

> **Purpose:** URL path patterns that map to signal types during source discovery (`/recon`).
> **Status:** Reference doc — future: migrate to `data/catalogs/signal-patterns/` as YAML catalogs per vertical.
> **Used by:** `_PATH_SIGNAL_MAP` in `src/research_toolkit/rag/discover.py`
> **Test case:** AXPONA engagement (#37-#44, #83)

## How It Works

During `/recon`, sitemap URLs are classified by matching their path against known patterns. A URL like `/pricing` maps to `pricing_page`, `/careers` maps to `job_postings`, etc. The classification's industry/business model determines which signal types are **priority** — but the path matching itself is universal.

The current heuristics are tuned for SaaS/tech sites. The AXPONA engagement (#37-#44) showed that event sites use completely different URL structures — `/attend/`, `/exhibit/`, `/sponsor/` — that our heuristics miss entirely (174 of 204 URLs classified as "unclassified").

This document captures learned patterns by vertical so they can eventually become loadable catalogs.

---

## Universal (all verticals)

These patterns appear on virtually every business website.

| Path Pattern | Signal Type | Confidence | Notes |
|---|---|---|---|
| `/pricing`, `/plans`, `/packages` | pricing_page | 0.7 | |
| `/about`, `/team`, `/company`, `/mission` | marketing | 0.7 | |
| `/blog`, `/press`, `/news`, `/media` | marketing | 0.7 | |
| `/careers`, `/jobs`, `/hiring`, `/join` | job_postings | 0.7 | |
| `/security`, `/compliance`, `/certifications` | certifications | 0.7 | |
| `/case-studies`, `/customers`, `/testimonials` | customer_voice | 0.7 | |

## SaaS / Platform

| Path Pattern | Signal Type | Confidence | Notes |
|---|---|---|---|
| `/docs`, `/api`, `/reference`, `/developer` | api_docs | 0.7 | |
| `/integrations`, `/partners`, `/marketplace` | integrations | 0.7 | |
| `/changelog`, `/releases`, `/whats-new` | changelog | 0.7 | |
| `/webhooks`, `/events/api` | webhook_events | 0.7 | |
| `/open-source`, `/github`, `/oss` | open_source | 0.7 | |
| `/status`, `/uptime` | certifications | 0.5 | Operational transparency |
| `/sdks`, `/libraries` | api_docs | 0.6 | |

## Events / Trade Shows / Conferences

Learned from AXPONA engagement (#37-#44). Event sites organize around the attendee and exhibitor journeys, not product features.

| Path Pattern | Signal Type | Confidence | Notes |
|---|---|---|---|
| `/attend`, `/tickets`, `/register`, `/passes` | pricing_page | 0.8 | Ticket pricing is the B2C pricing signal |
| `/exhibit`, `/exhibitors`, `/exhibitor-list` | industry_research | 0.7 | Exhibitor directory = supply side of marketplace |
| `/sponsor`, `/sponsorship`, `/become-a-sponsor` | pricing_page | 0.7 | Sponsorship catalog = B2B pricing signal |
| `/schedule`, `/agenda`, `/program`, `/sessions` | marketing | 0.6 | Show content / value proposition |
| `/speakers`, `/presenters`, `/seminars` | marketing | 0.6 | |
| `/venue`, `/hotel`, `/travel`, `/directions` | marketing | 0.5 | Logistics, low signal value |
| `/floor-plan`, `/exhibit-hall`, `/map` | industry_research | 0.5 | Space layout = capacity signal |
| `/past-shows`, `/gallery`, `/photos` | marketing | 0.4 | Historical, low priority |
| `/listening-rooms`, `/demo-rooms` | industry_research | 0.7 | AXPONA-specific: core product |
| `/car-audio`, `/headphone`, `/vinyl` | industry_research | 0.6 | AXPONA-specific: vertical segments |

## Services / Field Service

Learned from EDGE Cleaning engagement (#74-#76). Service businesses emphasize booking, coverage area, and social proof.

| Path Pattern | Signal Type | Confidence | Notes |
|---|---|---|---|
| `/book`, `/booking`, `/schedule-service`, `/get-quote` | pricing_page | 0.8 | Service booking = pricing signal |
| `/services`, `/our-services`, `/what-we-do` | marketing | 0.7 | Service catalog |
| `/areas-served`, `/service-area`, `/locations` | marketing | 0.6 | Geographic coverage |
| `/our-work`, `/portfolio`, `/before-after` | customer_voice | 0.6 | Social proof |
| `/reviews`, `/testimonials`, `/ratings` | customer_voice | 0.8 | Direct customer signal |
| `/faq`, `/how-it-works` | marketing | 0.5 | |
| `/checklist`, `/standards`, `/guarantee` | certifications | 0.6 | Quality assurance signal |

## Marketplace / E-commerce

| Path Pattern | Signal Type | Confidence | Notes |
|---|---|---|---|
| `/shop`, `/store`, `/products`, `/catalog` | pricing_page | 0.7 | Product catalog |
| `/categories`, `/collections`, `/departments` | industry_research | 0.5 | Taxonomy = business structure signal |
| `/sellers`, `/vendors`, `/brands` | industry_research | 0.6 | Supply side |
| `/deals`, `/sale`, `/promotions` | pricing_page | 0.5 | |
| `/returns`, `/shipping`, `/warranty` | marketing | 0.4 | Policy pages, low signal |

## Forums / Community (external sources)

These are platform patterns for external community sources, not the company's own site.

| Path Pattern | Signal Type | Platform | Notes |
|---|---|---|---|
| `/forums/`, `/community/`, `/discussions/` | customer_voice | generic | |
| `/threads/`, `/topic/` | customer_voice | xenforo/discourse | Individual discussions |
| `/r/`, `/comments/` | customer_voice | reddit | |
| `/reviews/`, `/product/` | customer_voice | g2/capterra | Review platforms |

---

## Future: Catalog Migration

See [#83 acceptance criteria](https://github.com/timjmitchell/research-pr/issues/83) — Signal Pattern Catalog section.
