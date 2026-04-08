# AXPONA — 1P Context Brief

> **Target:** AXPONA (JD Events LLC)
> **Mode:** consulting
> **Purpose:** Capture known 1P intelligence for `/synthesize` consumption

## Owner Context

- **Parent company:** JD Events LLC (Fairfield, CT)
- **Portfolio:** 3 shows — AXPONA, Plant Based World Expo, Healthcare Facilities Symposium
- **Founded:** 2002 (24 editions by 2026)
- **Staff:** ~25 across the portfolio
- **Acquisition context:** Purchase due diligence completed (offering memorandum, APA, legal research in `docs/purchase/`)

## Confirmed Financials (from offering memorandum)

- **2025 Revenue:** $2,145,300 (15% YoY growth)
- **2025 EBITDA:** $781,484 (36% margin)
- **Projected 2026 Revenue:** $2,415,000 (13% growth)
- **Projected 2026 EBITDA:** $943,175 (39% margin)
- **Revenue breakdown (2025):** Listening Rooms $1.4M (65%), Tickets $272K (13%), Booths $191K (9%), Sponsorships $164K (8%), Ads $81K (4%), Other $37K (2%)
- **Direct staff:** 3 (VP Marketing & Event Director, VP Sales & Business Development, Sales Director)
- **Employee compensation (2025):** $263,000
- **Gross margin:** 49% (2025), trending upward from 34% (2022)
- **Revenue CAGR (post-COVID):** ~22% (2022-2025)
- **Scale tier:** <$5M — NOT $5M-$20M as originally estimated

### Operational Metrics (from client data + offering memorandum)

- **Exhibitor rebooking rate:** 80% within 30 days of show close (matches CEIR average)
- **Onsite rebook revenue:** >80% of exhibit revenue rebooks onsite
- **Cash collection:** 50%+ within 4 months of show close
- **Attendee re-registration:** 15% (not a concern — 85% first-timers each year)
- **Attendee count:** 8,600 (2025 — OM figure; earlier estimate was 10,910)
- **Exhibitor count:** 750 brands (2025)
- **Listening rooms:** 213 at ~$6,577 avg (calculated: $1.4M / 213)
- **Booth units:** 144
- **Sponsorships:** 42 paid
- **Educational sessions:** 33
- **Space types:** 5 (listening_room, expo, ear_gear, car_audio, alti)
- **Sponsorship inventory:** 40+ items, 6 categories, $500-$12,000
- **Ticket types:** 6 (general_admission, friday/saturday/sunday_pass, vip, trade_pass), $15-$150

## Key Personnel (from public sources)

- Mark Freed — exhibitor sales
- Ryan Pearson — exhibitor sales

## Competitive Position

- North America's largest consumer audio show — niche monopoly
- No direct competitor at scale
- Listening room format is domain-specific innovation (private demo spaces)
- 24-year track record creates relationship-based moat

## Known Strategic Signals

- **Show timing/location research:** Extensive analysis in `mirror/presentation/show-timing-location-research.md` (84K)
- **Venue:** Renaissance Schaumburg Convention Center (Chicago area)
- **Press strategy:** Show pays travel/lodging for key press and influencers
- **Emerging formats:** ALTI Pavilion (new space type), podcast potential (UFI "Subscription" category)

## Community Sentiment (from forum crawl analysis)

- **202 deduplicated signals** from 13 threads across 7 platforms
- **Sentiment:** 73.8% positive, 9.9% negative, 15.3% neutral
- **Key negative clusters:** tariff/pricing anxiety (Audiogon), venue acoustics (sound bleed), source material quality
- **Key positive:** Product impressions (77 signals) and overall experience (56) overwhelmingly positive
- **Due diligence signal:** Venue complaints confirm AXPONA is pushing physical limits of current venue; tariff thread reveals supply-chain anxiety that may flow to booth/product pricing

## Gap Analysis Findings (from TOGAF-style predicted vs. observed)

- **8/8 bounded contexts confirmed** — no unpredicted or absent domains
- **16/21 CORE entities confirmed** — 2 internal-only (PriorityPoints, Commission), 1 may not exist (MatchmakingAppointment), 2 partial
- **3 GENERIC entities are false positives** — Warehouse, Shipment, Inventory (APQC 4.0 predicts but doesn't apply to trade shows)
- **Tech stack:** WordPress + Unity Event Solutions + spreadsheets — minimal, appropriate for scale
- **Data management:** No formal strategy, governance, or analytics infrastructure — as expected for <$5M

## Data Sources Collected

- **Bronze:** 53 raw crawl files (18 forum + 35 on-site captures)
- **Staging:** 4 structured extractions (regex → Ollama → Claude 3-tier pipeline)
- **Sources registry:** `mirror/infrastructure/data/sources.json` with reliability scores
- **Forum signals:** AudioKarma, Hi-Fi+, Head-Fi — demand-side sentiment and preference data
