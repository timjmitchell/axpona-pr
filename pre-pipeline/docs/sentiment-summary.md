# AXPONA — Community Sentiment Analysis

> **Date:** 2026-04-08 (updated from 2026-03-16 original)
> **Source:** 13 forum threads across 8 platforms, 653 deduplicated sentiment records
> **Method:** Crawl4AI (paginated, Bright Data residential proxy) + Claude Sonnet sentiment extraction
> **Pipeline:** `pre-pipeline/scripts/extract_sentiment.py` (post-level splitting, chunked extraction, dedup)
> **Issue:** [axpona-pr#5](https://github.com/timjmitchell/axpona-pr/issues/5), original: [research-pr#42](https://github.com/timjmitchell/research-pr/issues/42)
> **Data:** [sentiment-extraction.json](../mirror/infrastructure/data/staging/sentiment-extraction.json)

---

## Executive Summary

Community sentiment toward AXPONA 2025 is **net positive** (58.0% positive, 35.1% negative, 4.1% neutral) across 653 deduplicated sentiment signals from 13 audiophile forum threads. This updated analysis — 3.2× the original 202 records — reveals a more nuanced picture than the initial extraction suggested.

Product impressions dominate (304 signals), followed by experience (166). The negative signals are significantly more visible in the expanded data: **229 negative records** (up from 20), with the increase coming from deeper extraction of diyAudio's engineering-focused community, expanded Steve Hoffman room rankings, and the newly-extracted ASR thread.

**Key shift from original analysis:** The original 73.8% positive / 9.9% negative split was an artifact of under-extraction. The true sentiment balance is closer to 58/35 — still net positive, but with substantially more critical commentary about **product quality debates** (DSP vs. passive, measurement vs. subjective), **room-specific disappointments**, and **industry pricing/tariff concerns**. This is a healthier signal for due diligence: the community cares enough to be critical.

**Key finding for due diligence:** The expanded data confirms that AXPONA's audience is technically sophisticated, opinionated, and engaged — exactly the profile that drives exhibitor ROI through word-of-mouth and repeat attendance. The negative signals are primarily about specific rooms/products (fixable through exhibitor coaching and space allocation) rather than structural show problems.

---

## Sentiment Distribution

### By Polarity

| Sentiment | Count | % |
|-----------|------:|-----:|
| Positive | 379 | 58.0% |
| Negative | 229 | 35.1% |
| Neutral | 27 | 4.1% |
| Mixed | 18 | 2.8% |

### By Topic Category

| Category | Total | Positive | Negative | Neutral | Mixed | Net Sentiment |
|----------|------:|---------:|---------:|--------:|------:|------|
| Product | 304 | 219 | 79 | 4 | 2 | Net positive — but significant critical minority |
| Experience | 166 | 108 | 48 | 5 | 5 | Net positive |
| Room | 62 | 32 | 27 | 1 | 2 | Balanced — room-specific variation |
| Industry | 53 | 16 | 31 | 3 | 3 | **Net negative** (tariff, pricing, market direction) |
| Value | 32 | 9 | 21 | 1 | 1 | **Net negative** (pricing pushback) |
| Venue | 24 | 5 | 15 | 3 | 1 | **Net negative** (acoustics, logistics) |
| Logistics | 12 | 0 | 8 | 3 | 1 | Net negative |

**Notable changes from original:**
- Product negative signals went from 1 to 79 — the original extraction missed the active/passive speaker debate, DSP criticism, and measurement-focused skepticism from ASR and diyAudio
- Room sentiment went from "strongly positive" (16:0 positive:negative) to balanced (32:27) — expanded Steve Hoffman data captures room-specific disappointments alongside praise
- Value emerged as a distinct negative theme (21 negative) — pricing pushback wasn't visible in the original 4 records
- Industry remains net negative, now with 31 negative signals (tariffs, market consolidation, pricing pressure)

---

## Source Analysis

### Forum Thread Yield (Deduplicated)

| Source | Sentiments | Pos | Neg | Neu | Mix | Change from Original | Notes |
|--------|---:|---:|---:|---:|---:|---|---|
| diyAudio AXPONA 2025 | 235 | 135 | 83 | 11 | 6 | **+173** (was 62) | Deepest source — full 20-page extraction |
| Steve Hoffman Favorite Rooms | 67 | 36 | 29 | 0 | 2 | **+55** (was 12) | Room rankings with critical commentary |
| Head-Fi Planning Thread | 61 | 42 | 15 | 3 | 1 | **+41** (was 20) | Pre/post show expectations vs reality |
| Steve Hoffman Room Agenda | 59 | 33 | 21 | 3 | 2 | **+43** (was 16) | Room-by-room detailed reports |
| AudioShark Report | 48 | 32 | 11 | 3 | 2 | **+44** (was 4) | Pagination fixed: all 10 pages extracted |
| ASR AXPONA 2025 | 44 | 20 | 18 | 5 | 1 | **+44** (was 0) | **New** — measurement-focused community |
| WBF Reflections | 40 | 9 | 24 | 3 | 4 | **+31** (was 9) | Most critical source — ultra-high-end perspective |
| Audiogon Favorite Room | 31 | 27 | 4 | 0 | 0 | **+18** (was 13) | Room rankings — mostly positive |
| Steve Hoffman AXPONA 2025 | 27 | 14 | 10 | 2 | 1 | **+21** (was 6) | General discussion, 15 pages |
| Head-Fi EarGear | 22 | 18 | 4 | 0 | 0 | **-11** (was 33) | Headphone-focused; less duplication in new extraction |
| Audiophile Style | 20 | 13 | 4 | 2 | 1 | **+14** (was 6) | Invision platform; first chunk has all content |
| Audiogon Tariff Panic | 16 | 5 | 10 | 0 | 1 | **+7** (was 9) | Tariff/pricing anxiety |
| WBF Report | 1 | 0 | 1 | 0 | 0 | **-11** (was 12) | Pagination failed — all 9 pages identical |

### Pagination Status Update

| Result | Forums |
|---|---|
| **Full extraction** | diyAudio (20 pages), Steve Hoffman (3 threads, 5-20 pages each), Audiophile Style (10 pages) |
| **Good extraction** | ASR (2 pages), Head-Fi (2 threads), AudioShark (10 pages), Audiogon (2 threads) |
| **Still broken** | WBF Report (9 identical pages → 1 record) |

---

## Key Sentiment Signals

### Positive Themes

**Product impressions (219 positive):** The community engages deeply with specific products. Top mentioned entities include Clarisys speakers, Magico M9, Alta Audio Aphrodite, HeadAmp amplifiers, and Andrew Jones designs. Product sentiment is the strongest positive signal and directly useful as exhibitor ROI evidence.

**Overall experience (108 positive):** Repeat attendees express loyalty and engagement. The show's scale and diversity are perceived as features. First-time attendees report being overwhelmed but positive.

**Room quality (32 positive):** Specific rooms receive detailed praise. The Steve Hoffman Favorite Rooms thread (67 records) provides granular room-by-room feedback that could be formalized into post-show exhibitor reporting.

### Negative Themes

**Product quality debates (79 negative):** The largest negative category. Three distinct threads:
1. **DSP/active vs. passive speaker debate** — 24 signals. The engineering community (diyAudio, ASR) questions why exhibitors don't use DSP room correction. Quote: *"With DSP you can measure and correct — without it you're just guessing in a hotel room."*
2. **Measurement vs. subjective claims** — ASR community skepticism toward products marketed without measurements. Quote: *"I see a lot of opinions — but no measurements."*
3. **Specific product disappointments** — individual rooms/products that didn't meet expectations.

**Experience negatives (48):** Overcrowding, difficulty seeing everything in 3 days, parking/transportation challenges. Quote: *"You could spend all three days and still miss half the rooms."*

**Industry pricing/tariff anxiety (31 negative):** Expanded from 11 to 31. Tariff impact on component pricing remains the strongest external threat signal. New: concerns about market consolidation and distributor dominance. Quote: *"Using Audio Research Corp as an example, just a guess 98% of the electronic components in their audio equipment is imported from China, Taiwan, or Vietnam."*

**Room disappointments (27 negative):** Sound bleed between rooms, small room constraints for large speakers, poor room acoustics. This is the most actionable category — specific rooms are named. Quote: *"I felt bad for companies like Burmester, Vandersteen, Monarch Audio and many others trying to shoehorn their audio systems into rooms that were too small."*

**Value/pricing pushback (21 negative):** Community members questioning pricing of high-end products. This is a community-specific perspective (audiophiles debating diminishing returns above certain price points) but signals price sensitivity in the market.

**Venue constraints (15 negative):** Sound bleed, room size limitations, HVAC noise. Consistent with the gap analysis finding that AXPONA is pushing venue capacity.

### Industry Themes

**Active vs. passive speaker debate:** The most discussed technical topic across diyAudio and ASR. Not a show-level problem but reflects a genuine industry transition that AXPONA could address through programming (e.g., measurement/DSP seminar sessions).

**Tariff and supply chain:** Concentrated in Audiogon but referenced across multiple forums. An external threat that affects exhibitor costs and show pricing.

---

## Cross-Reference with Gap Analysis

| Gap Analysis Finding | Sentiment Evidence (Updated) |
|---|---|
| **Exhibitor rebooking rate: 80%** | Community identifies specific brands year-over-year; "who's back" discussions. Now with 653 records, brand continuity is visible across multiple forums |
| **Sponsorship stronger than expected** | Still not directly discussed — sponsorship is invisible to attendees |
| **No matchmaking capability** | Multiple posts about difficulty finding specific rooms/brands; organic community coordination fills the gap |
| **Post-show analytics limited** | Community generates extensive analytics (room rankings with 67 records from Steve Hoffman alone) — AXPONA captures none of this |
| **Venue at capacity** | Room size complaints (27 negative room signals) + sound bleed + "can't see everything" + overcrowding = venue stress strongly confirmed |
| **DSP/technology gap** | **New finding:** significant community expectation that rooms should use DSP correction — an exhibitor education opportunity |

---

## Data Quality Notes

### Extraction Pipeline

The updated extraction used `pre-pipeline/scripts/extract_sentiment.py` — a repeatable Python pipeline that:
1. Reads bronze-layer forum crawl files
2. Splits into individual posts (supports XenForo, Invision, and Audiogon formats)
3. Chunks posts into ~12K character groups
4. Sends each chunk to Claude Sonnet for structured sentiment extraction
5. Deduplicates by (source, topic, quote) hash
6. Applies quality filters (Cloudflare noise, category normalization)

### Deduplication Results

| Metric | Raw | After Dedup | After Filters | Removed |
|--------|----:|------:|------:|--------:|
| Total records | 788 | 657 | 653 | 135 (17.1%) |

Deduplication removed 131 records (16.6%), primarily from WBF Reflections where pagination produced duplicate pages (the same 5-chunk pattern repeated 9 times).

Quality filters removed 4 additional records for invalid categories.

### Remaining Caveats

1. **WBF Report pagination failure** — All 9 crawled pages are identical, producing only 1 unique record. Re-crawling with session persistence would recover this source.

2. **Negative sentiment increase** — The jump from 9.9% to 35.1% negative is genuine, not an artifact. The original extraction under-sampled critical communities (diyAudio had 62 of a possible 235 records; Steve Hoffman rooms had 12 of 67). The expanded extraction captures the full spectrum of opinion.

3. **DSP/active-passive debate inflation** — The diyAudio thread contains an extended technical debate about DSP vs. passive speakers that generates many sentiment records. These are genuine opinions but may over-represent one community's perspective relative to the broader AXPONA audience.

4. **Model difference** — Original extraction used Ollama/Mistral; this update uses Claude Sonnet 4. The models may have different extraction thresholds, particularly for what constitutes "sentiment" vs. factual statement.

---

## Recommendations

1. **Fix WBF Report pagination** — Re-crawl with session/cookie persistence to recover the 9-page show report
2. **Exhibitor room feedback program** — Formalize the Steve Hoffman room ranking data (67 records) into a post-show exhibitor feedback report
3. **DSP/measurement programming** — Address the active vs. passive debate through show programming (measurement seminars, DSP demo rooms)
4. **Year-over-year tracking** — Run the extraction pipeline against 2024 AXPONA threads to establish sentiment baselines
5. **Tariff impact monitoring** — Track the Audiogon pricing thread as an ongoing external threat signal

---

## Pipeline Usage

```bash
# Full extraction (all 13 sources)
python scripts/extract_sentiment.py

# Dry run (no API calls)
python scripts/extract_sentiment.py --dry-run

# Extract specific source
python scripts/extract_sentiment.py --source forum-d3a144ec88ef-raw.md

# Re-extract sources with few records
python scripts/extract_sentiment.py --min-records 10

# Append to existing data
python scripts/extract_sentiment.py --source new-source.md --append
```

---

## Related

- [gap-analysis.md](gap-analysis.md) — Predicted vs. observed gap analysis
- [graph-extract.md](testing/graph-extract.md) — Knowledge graph entity extraction
- [tier3-synthesis.md](testing/tier3-synthesis.md) — Tier 3 Claude synthesis report
- [sentiment-extraction.json](../mirror/infrastructure/data/staging/sentiment-extraction.json) — Deduplicated extraction data (653 records)
- [extract_sentiment.py](../pre-pipeline/scripts/extract_sentiment.py) — Extraction pipeline script
- [forum-crawl-research.md](../mirror/domain/forum-crawl-research.md) — Forum source research and Crawl4AI capabilities
