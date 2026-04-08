# Issue #5: Update sentiment analysis with expanded bronze data

> **Issue:** [axpona-pr#5](https://github.com/timjmitchell/axpona-pr/issues/5)
> **Status:** Complete

## 2026-04-08
<!-- @appended by /issue on 2026-04-08T00:00:00Z -->

### Context

The original sentiment analysis (March 16) extracted 202 deduplicated records from 13 forum threads using Ollama/Mistral. Since then, bronze layer data expanded to 18 forum crawl files with improved pagination. Known gaps included ASR under-extraction, AudioShark pagination failure, equipment-list false positives, and 8K truncation on large threads.

### Work Done

- **Audited bronze vs. staging coverage** — mapped 18 bronze forum files to 13 unique sources. 5 files were April 2 re-crawls (smaller duplicates auto-skipped by script).
- **Built repeatable extraction pipeline** — `pre-pipeline/scripts/extract_sentiment.py`:
  - Post-level splitting with support for XenForo (h3 and h4 variants), Invision, and Audiogon formats
  - Fixed Steve Hoffman post splitting (was detecting 1-5 posts from 100K+ files, now detects 26-55)
  - Chunked extraction via Claude Sonnet API with structured JSON output
  - MD5-based dedup on (source, topic, quote)
  - Quality filters for Cloudflare noise, category normalization, null safety
  - Dry-run mode, per-source filtering, append mode
- **Extracted 653 records** from all 13 sources (up from 202):
  - ASR: 44 (was 0), AudioShark: 48 (was 4), Steve Hoffman Favorites: 67 (was 12)
  - diyAudio: 235 (was 62), WBF Reflections: 40 (was 9)
  - API cost: ~$4.53 (1M input + 102K output tokens)
- **Updated sentiment-summary.md** — complete rewrite with new distributions, source analysis, key themes, and cross-reference with gap analysis
- **Updated staging artifacts** — manifest.yaml, README.md, sentiment-extraction.json
- **Key finding shift** — original 73.8% positive / 9.9% negative was under-extraction artifact. True balance is 58% / 35% — still net positive but with significantly more critical commentary about product quality debates, room disappointments, and pricing concerns
- **WBF Report still broken** — pagination produces 9 identical pages (1 unique record). Needs session/cookie persistence to fix.

### Next Steps

- Fix WBF Report pagination (re-crawl with session persistence)
- Year-over-year comparison with 2024 AXPONA threads
- Formalize Steve Hoffman room ranking data into exhibitor feedback report
- Consider DSP/measurement programming recommendations for AXPONA
