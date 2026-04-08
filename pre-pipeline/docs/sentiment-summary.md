# AXPONA — Community Sentiment Analysis

> **Date:** 2026-03-16
> **Source:** 13 forum threads across 7 platforms, 202 deduplicated sentiment records
> **Method:** Crawl4AI (paginated, Bright Data residential proxy) + Ollama/Mistral sentiment extraction
> **Issue:** [research-pr#42](https://github.com/timjmitchell/research-pr/issues/42)
> **Data:** [sentiment-extraction.json](mirror/staging/sentiment-extraction.json)

---

## Executive Summary

Community sentiment toward AXPONA 2025 is **strongly positive** (73.8% positive, 9.9% negative, 15.3% neutral) across 202 deduplicated sentiment signals from 13 audiophile forum threads. Product impressions dominate (77 signals), followed by overall experience (56). The negative signals cluster around three areas: **tariff/pricing anxiety** (9 signals from Audiogon), **venue acoustics** (sound bleed, room constraints), and **source material quality** (streaming vs. vinyl).

**Key finding for due diligence:** The community's negative signals align precisely with the gap analysis. Venue complaints confirm that AXPONA is pushing the physical limits of its current venue. The Audiogon tariff thread reveals supply chain anxiety specific to the audio industry — exhibitors face component cost increases that may flow through to booth pricing and product pricing at future shows. Meanwhile, the overwhelming product and experience positivity — from skeptical, technically literate audiences — validates genuine exhibitor and attendee satisfaction that isn't visible in press releases alone.

---

## Sentiment Distribution

### By Polarity

| Sentiment | Count | % |
|-----------|------:|-----:|
| Positive | 149 | 73.8% |
| Neutral | 31 | 15.3% |
| Negative | 20 | 9.9% |
| Mixed | 2 | 1.0% |

### By Topic Category

| Category | Total | Positive | Negative | Neutral | Mixed | Net Sentiment |
|----------|------:|---------:|---------:|--------:|------:|------|
| Product | 77 | 71 | 1 | 5 | 0 | Strongly positive |
| Experience | 56 | 48 | 3 | 4 | 1 | Strongly positive |
| Industry | 23 | 8 | 11 | 4 | 0 | **Net negative** (tariff anxiety) |
| Logistics | 19 | 1 | 3 | 15 | 0 | Neutral-negative |
| Room | 17 | 16 | 0 | 1 | 0 | Strongly positive |
| Venue | 6 | 2 | 2 | 2 | 0 | Neutral |
| Value | 4 | 3 | 0 | 0 | 1 | Net positive |

**Notable:** Industry sentiment flipped to net negative after adding the Audiogon tariff thread (9 negative signals about tariff/supply chain impact). This is the only external threat signal in the data — all other negatives are operational (venue, logistics). Room sentiment is strongly positive with 17 signals after adding Audiogon's room ranking thread.

---

## Source Analysis

### Forum Thread Yield (Deduplicated)

| Source | Sentiments | Pos | Neg | Neu | Unique Pages | Notes |
|--------|---:|---:|---:|---:|---:|---|
| diyAudio AXPONA 2025 | 62 | 47 | 5 | 9 | 18/20 | **Best source overall** — deep, varied, good polarity mix |
| Head-Fi EarGear Impressions | 33 | 30 | 1 | 1 | 3/10 | Headphone-focused; pagination partially failed |
| Head-Fi Planning Thread | 20 | 19 | 0 | 1 | 2/2 | Pre-show expectations |
| Steve Hoffman Room Agenda | 16 | 2 | 0 | 14 | 5/5 | Mostly neutral room listings (pagination worked) |
| WBF AXPONA 2025 Report | 12 | 12 | 0 | 0 | 2/9 | Equipment lists classified as positive (see caveats) |
| Steve Hoffman Favorite Rooms | 12 | 10 | 0 | 2 | 5/5 | Room rankings (pagination worked) |
| WBF Thoughts & Reflections | 9 | 4 | 4 | 1 | 2/10 | **Most critical source** — best negative signal |
| Steve Hoffman AXPONA 2025 | 6 | 2 | 1 | 3 | 1/1 | Single page only (pre-show) |
| Audiophile Style | 6 | 6 | 0 | 0 | 10/10 | All unique pages; light content |
| Audiogon Favorite Room | 13 | 13 | 0 | 0 | 1/1 | **Room rankings** — crawled without proxy |
| Audiogon Tariff Panic | 9 | 0 | 9 | 0 | 1/1 | **All negative** — unique tariff/pricing angle |
| AudioShark Report | 4 | 4 | 0 | 0 | 1/10 | Pagination failed completely |
| ASR AXPONA 2025 | — | — | — | — | — | Under-extracted |

### Pagination Issues

A key finding from this crawl: **XenForo pagination through residential proxy fails for many forums.** Some forums return page 1 content regardless of the `/page-N` URL when the request lacks valid session cookies. The proxy strips or doesn't propagate cookies between requests.

| Pagination Result | Forums |
|---|---|
| **Worked** (all pages unique) | Steve Hoffman (all 3 threads), Audiophile Style, Head-Fi Planning |
| **Partially failed** (some duplicates) | diyAudio (18/20), Head-Fi EarGear (3/10), WBF Reflections (2/10), WBF Report (2/9) |
| **Fully failed** (all duplicates) | AudioShark (1/10) |
| **Blocked by proxy** | Audiogon (both threads) |

### Sources That Required Direct Crawl

| Source | Issue | Resolution |
|--------|-------|------------|
| Audiogon — Favorite Room | `ERR_TUNNEL_CONNECTION_FAILED` via proxy | Crawled without proxy (`use_proxy: false` in manifest) |
| Audiogon — Tariff Panic | Same proxy block | Same — Audiogon blocks Bright Data residential IPs |

---

## Key Sentiment Signals

### Positive Themes

**Product impressions (62 positive):** The community is deeply engaged with specific products. Mentions are concrete and brand-specific — VPI turntables, HeadAmp amplifiers, Studio Electric speakers, Dan Clark Audio headphones. Product sentiment is the strongest signal category and directly useful as exhibitor ROI evidence.

**Overall experience (48 positive):** Repeat attendees express loyalty ("can't wait for next year," "you can easily spend all three days"). First-timers seek advice and express excitement. The show's scale is perceived as a feature, not a burden.

**Room quality (12 positive):** Specific exhibitor rooms receive praise. Room rankings emerge organically in multiple threads — a natural community behavior that AXPONA could formalize in post-show reporting.

### Negative Themes

**Tariff and supply chain anxiety (9 negative, all from Audiogon):** The strongest negative cluster. The audiophile community is concerned about tariff impact on component pricing — most high-end audio components rely on parts from China, Taiwan, and Vietnam. Quote: *"Using Audio Research Corp as an example, just a guess 98% of the electronic components in their audio equipment is imported from China, Taiwan, or Vietnam."* This is an **external threat** to AXPONA's exhibitor base: if component costs rise, exhibitor margins shrink and booth ROI decreases.

**Venue and room acoustics (2 negative venue + related complaints):** Sound bleed between rooms, poor room acoustics in some hotel spaces. Quote: *"The venue's acoustics were a bit of a letdown. Some rooms sounded muddied and lacking in detail."* — Head-Fi. Quote: *"I felt bad for companies like Burmester, Vandersteen, Monarch Audio and many others trying to shoehorn their audio systems into rooms that were too small."* — WBF.

**Source material quality (logistics, 3 negative):** Audiophiles are frustrated that exhibitors use streaming rather than vinyl/physical media for demos. Quote: *"Ugh. Streaming, more often than not, was the name of the game."* — WBF. This is a community-specific complaint but signals that AXPONA's core audience values physical media demo quality.

**Measurement vs. subjective debate (experience, 3 negative from diyAudio):** The DIY/engineering community is skeptical of subjective audio claims without measurements. Quote: *"I see a lot of opinions — but no measurements (on-axis or better yet — polar sonograms)."* This is a community-specific perspective rather than a show-level problem.

### Industry Themes

**Active vs. passive speaker debate (14 industry signals):** A significant thread in diyAudio about active vs. passive speaker systems at the show. Net positive for the industry category, but reflects a genuine community divide about technology direction.

---

## Cross-Reference with Gap Analysis

| Gap Analysis Finding | Sentiment Evidence |
|---|---|
| **Exhibitor rebooking rate: 80%** (confirmed via client data) | Community identifies specific brands year-over-year; organic "who's back" discussions align with the confirmed 80% re-registration rate (CEIR industry average) |
| **Sponsorship stronger than expected** | Not directly discussed in forums — sponsorship is invisible to attendees (positive for sponsors) |
| **No matchmaking capability** | Multiple posts about difficulty finding specific rooms/brands; organic community coordination fills the gap |
| **Post-show analytics limited** | Community generates its own analytics (room rankings, best-of lists, photo reports) — AXPONA captures none of this |
| **Venue at capacity** | Room size complaints + "can't see everything in 3 days" + sound bleed between rooms = venue stress confirmed |

---

## Data Quality Notes

### Deduplication Applied

The initial extraction produced 457 records. Post-analysis revealed that proxy-based pagination failed for several forums, causing the same page to be crawled and extracted multiple times. After deduplication:

| Metric | Before | After Dedup | + Audiogon | Removed |
|--------|-------:|------:|------:|--------:|
| Total records | 457 | 180 | 202 | 255 (55.8%) |
| Positive | 354 | 136 | 149 | 205 |
| Negative | 46 | 11 | 20 | 26 |
| Neutral | 50 | 31 | 31 | 19 |

Deduplication used two methods:
1. **Page-level:** Mid-content hashing to identify duplicate page crawls (forum chrome at page start is always identical)
2. **Record-level:** Matching on (source, topic, quote) to remove same sentiment extracted from duplicate pages

### Remaining Caveats

1. **Equipment lists as sentiment:** WBF Report contains a reviewer's gear list (Zellaton speakers, Quad 303 amp, etc.) that Mistral classified as "positive product sentiment" with intensity 5. These are factual inventory items, not opinions. ~12 records are affected.

2. **Under-extraction on paginated sources:** Sources where pagination failed (Head-Fi EarGear, WBF, AudioShark) have significantly fewer sentiments than their thread depth warrants. Re-crawling with session/cookie persistence would improve coverage.

3. **Entity noise:** "Cloudflare" appears as a linked brand entity — anti-bot challenge page content leaking through the cleaner.

4. **8K char window:** The per-page extraction window truncates large forum pages before reaching all posts. Post-level splitting (parsing individual forum posts before extraction) would improve yield.

---

## Recommendations

1. **Fix pagination** — Investigate Crawl4AI cookie/session persistence to maintain forum login state across page requests. Steve Hoffman forums work correctly; apply the same pattern to others.
2. **Re-extract with post splitting** — Parse individual XenForo posts before sending to LLM, rather than sending raw page HTML. This avoids the 8K truncation problem and gives cleaner input.
3. ~~**Crawl Audiogon directly**~~ — Done. Added `use_proxy: false` to manifest; both threads crawled successfully without proxy.
4. **Add year-over-year comparison** — Crawl 2024 AXPONA threads from the same forums to track sentiment trends.
5. **Filter equipment lists** — Add a pre-extraction rule to detect and skip gear-list signatures (bulleted product names without opinion language).

---

## Related

- [gap-analysis.md](gap-analysis.md) — Predicted vs. observed gap analysis
- [graph-extract.md](../../docs/testing/graph-extract.md) — Knowledge graph entity extraction
- [tier3-synthesis.md](../../docs/testing/tier3-synthesis.md) — Tier 3 Claude synthesis report
- [sentiment-extraction.json](mirror/staging/sentiment-extraction.json) — Deduplicated extraction data (202 records)
- [forum-crawl-research.md](mirror/domain/forum-crawl-research.md) — Forum source research and Crawl4AI capabilities
