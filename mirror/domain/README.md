# Domain Layer — Raw Data Sources

**Status:** Active
**DDD Analog:** Domain events, raw facts
**Medallion:** Bronze

## What Belongs Here

Raw, untransformed data captures from public signals:

- **Website pages** — crawled markdown from axpona.com (pricing, exhibitor info, demographics)
- **Forum threads** — community discussion captures from ASR, Head-Fi, WBF, SBAF, Reddit, Audiophile Style
- **Source manifest** — `sources.json` declaring all crawl targets with signal metadata

## Rules

1. **No transformation** — files are verbatim Crawl4AI/Playwright captures
2. **Naming convention** — `{source_type}-{slug}-raw.md` for crawled content
3. **Source attribution** — every file traces to a URL in `sources.json`
4. **Deduplication** — by URL; re-crawls replace existing files

## Key Files

| File | Description |
|------|-------------|
| `sources.json` | 29 crawl targets with signal_source, tags, reliability scores |
| `*-raw.md` | Raw crawled markdown (website pages and forum threads) |
| `manifest.yaml` | Layer manifest with contents inventory |

## Signal Sources

- 3 pricing pages (exhibitor spaces, sponsorship, tickets)
- 7 marketing pages (homepage, about, etc.)
- 13 community forum threads
- 3 industry/regulatory pages
