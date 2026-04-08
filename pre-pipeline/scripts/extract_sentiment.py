"""
Sentiment extraction pipeline for AXPONA forum crawl data.

Reads bronze-layer forum crawl files, splits into individual posts,
sends post chunks to Claude for structured sentiment extraction,
deduplicates results, and writes staging-layer output.

Architecture:
    Python handles: file I/O, post splitting, chunking, dedup, output
    Claude handles: reading posts and extracting structured sentiment records

Usage:
    # Extract from all bronze forum sources
    python scripts/extract_sentiment.py

    # Extract from specific source(s)
    python scripts/extract_sentiment.py --source forum-d3a144ec88ef-raw.md

    # Dry run — show what would be extracted without calling Claude
    python scripts/extract_sentiment.py --dry-run

    # Re-extract only sources with fewer than N existing records
    python scripts/extract_sentiment.py --min-records 10

    # Force fresh extraction (ignore checkpoints from prior interrupted run)
    python scripts/extract_sentiment.py --no-resume

Resume behavior:
    The script checkpoints results to disk after each source completes
    (pre-pipeline/staging/.checkpoints/). If the process is killed mid-run,
    re-running the same command automatically resumes from where it left off —
    already-extracted sources are loaded from checkpoint, only remaining sources
    hit the API. Checkpoints are cleared after successful completion.

    Use --no-resume to ignore checkpoints and re-extract everything.

Environment:
    ANTHROPIC_API_KEY — required (or set via ~/.bashrc ANTHROPIC_API_KEY)
"""

import argparse
import hashlib
import json
import re
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

import anthropic

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

MODEL = "claude-sonnet-4-20250514"
MAX_TOKENS_PER_CHUNK = 4096  # output tokens per extraction call
CHUNK_TARGET_CHARS = 12_000  # ~3K tokens input per chunk — fits well under context
BRONZE_DIR = Path("pre-pipeline/bronze/forums")
STAGING_DIR = Path("mirror/infrastructure/data/staging")
OUTPUT_FILE = STAGING_DIR / "sentiment-extraction.json"
CHECKPOINT_DIR = Path("pre-pipeline/staging/.checkpoints")  # per-source checkpoint files

# Source metadata — maps bronze filenames to human-readable source info.
# The script will still process files not listed here, using filename as title.
SOURCE_REGISTRY: dict[str, dict] = {
    "forum-d3a144ec88ef-raw.md": {
        "title": "AudioScienceReview — AXPONA 2025",
        "url": "https://www.audiosciencereview.com/forum/index.php?threads/axpona-2025.62020/",
        "platform": "xenforo",
    },
    "forum-my-experience-at-a-hifi-audio-convention-axpona-2025.426344-raw.md": {
        "title": "diyAudio — My Experience at AXPONA 2025",
        "url": "https://www.diyaudio.com/community/threads/my-experience-at-a-hifi-audio-convention-axpona-2025.426344/",
        "platform": "xenforo",
    },
    "4176f38b95f6.md": {
        "title": "diyAudio — My Experience at AXPONA 2025",
        "url": "https://www.diyaudio.com/community/threads/my-experience-at-a-hifi-audio-convention-axpona-2025.426344/",
        "platform": "xenforo",
        "note": "Re-crawl (Apr 2)",
    },
    "forum-thoughts-and-reflections-on-axpona-2025.40730-raw.md": {
        "title": "What's Best Forum — Thoughts and Reflections on AXPONA 2025",
        "url": "https://www.whatsbestforum.com/threads/thoughts-and-reflections-on-axpona-2025.40730/",
        "platform": "xenforo",
    },
    "604b9a3dde4c.md": {
        "title": "What's Best Forum — Thoughts and Reflections on AXPONA 2025",
        "url": "https://www.whatsbestforum.com/threads/thoughts-and-reflections-on-axpona-2025.40730/",
        "platform": "xenforo",
        "note": "Re-crawl (Apr 2)",
    },
    "forum-axpona-2025-eargear-impressions-thread.976566-raw.md": {
        "title": "Head-Fi AXPONA 2025 EarGear Impressions",
        "url": "https://www.head-fi.org/threads/axpona-2025-eargear-impressions-thread.976566/",
        "platform": "xenforo",
    },
    "e313978a3751.md": {
        "title": "Head-Fi AXPONA 2025 EarGear Impressions",
        "url": "https://www.head-fi.org/threads/axpona-2025-eargear-impressions-thread.976566/",
        "platform": "xenforo",
        "note": "Re-crawl (Apr 2)",
    },
    "forum-axpona-and-eargear-2025-april-11-13-schaumburg-illinois.976367-raw.md": {
        "title": "Head-Fi AXPONA 2025 Planning Thread",
        "url": "https://www.head-fi.org/threads/axpona-and-eargear-2025-april-11-13-schaumburg-illinois.976367/",
        "platform": "xenforo",
    },
    "forum-axpona-2025.1222046-raw.md": {
        "title": "Steve Hoffman Forums — AXPONA 2025",
        "url": "https://forums.stevehoffman.tv/threads/axpona-2025.1222046/",
        "platform": "xenforo",
    },
    "forum-axpona-room-agenda-and-report.1199508-raw.md": {
        "title": "Steve Hoffman Forums — AXPONA Room Agenda and Report",
        "url": "https://forums.stevehoffman.tv/threads/axpona-room-agenda-and-report.1199508/",
        "platform": "xenforo",
    },
    "forum-favorite-axpona-rooms.1199598-raw.md": {
        "title": "Steve Hoffman Forums — Favorite AXPONA Rooms",
        "url": "https://forums.stevehoffman.tv/threads/favorite-axpona-rooms.1199598/",
        "platform": "xenforo",
    },
    "forum-axpona-2025-report.41089-raw.md": {
        "title": "What's Best Forum — AXPONA 2025 Report",
        "url": "https://www.whatsbestforum.com/threads/axpona-2025-report.41089/",
        "platform": "xenforo",
    },
    "61e9f7aafba4.md": {
        "title": "What's Best Forum — AXPONA 2025 Report",
        "url": "https://www.whatsbestforum.com/threads/axpona-2025-report.41089/",
        "platform": "xenforo",
        "note": "Re-crawl (Apr 2)",
    },
    "forum-axpona-2025-report.26607-raw.md": {
        "title": "AudioShark — AXPONA 2025 Report",
        "url": "https://www.audioshark.org/threads/axpona-2025-report.26607/",
        "platform": "xenforo",
    },
    "1410dedf3273.md": {
        "title": "AudioShark — AXPONA 2025 Report",
        "url": "https://www.audioshark.org/threads/axpona-2025-report.26607/",
        "platform": "xenforo",
        "note": "Re-crawl (Apr 2)",
    },
    "forum-6c72868eeca4-raw.md": {
        "title": "Audiophile Style — AXPONA 2025 Forum Thread",
        "url": "https://audiophilestyle.com/forums/topic/70920-axpona-2025-is-here/",
        "platform": "invision",
    },
    "forum-tariff-panic-raw.md": {
        "title": "Audiogon — Tariff Panic at AXPONA 25?",
        "url": "https://forum.audiogon.com/discussions/tariff-panic-at-axpona-25",
        "platform": "other",
    },
    "forum-favorite-room-raw.md": {
        "title": "Audiogon — Your Favorite Room at AXPONA 2025",
        "url": "https://forum.audiogon.com/discussions/your-favorite-room-at-axpona-2025",
        "platform": "other",
    },
}

# Categories Claude should use (matches existing schema)
VALID_CATEGORIES = ["room", "product", "venue", "logistics", "value", "experience", "industry"]
VALID_SENTIMENTS = ["positive", "negative", "neutral", "mixed"]

# ---------------------------------------------------------------------------
# Post splitting
# ---------------------------------------------------------------------------


def split_into_posts(text: str, filename: str) -> list[dict]:
    """Split a raw forum crawl file into individual posts.

    Handles multiple forum formats:
      - XenForo standard (WBF, diyAudio, ASR, Head-Fi, AudioShark): #### [user](url)
      - XenForo Steve Hoffman variant: ###  [user](url) with numbered list prefixes
      - Invision (Audiophile Style): [Posted date](url) boundaries
      - Audiogon / other: falls back to page-level chunks

    Returns list of dicts: {text, page, post_number, author}
    """
    posts = []

    # Split by page first
    pages = re.split(r"^--- Page (\d+) ---$", text, flags=re.MULTILINE)

    # pages = ['header', '1', 'page1_content', '2', 'page2_content', ...]
    if len(pages) < 3:
        # No page markers — treat whole file as one page
        page_contents = [(1, text)]
    else:
        page_contents = []
        for i in range(1, len(pages), 2):
            page_num = int(pages[i])
            page_text = pages[i + 1] if i + 1 < len(pages) else ""
            page_contents.append((page_num, page_text))

    for page_num, page_text in page_contents:
        page_posts = _split_page_into_posts(page_text)
        for p in page_posts:
            p["page"] = page_num
            posts.append(p)

    return posts


def _split_page_into_posts(page_text: str) -> list[dict]:
    """Try multiple splitting strategies in order of specificity."""

    # Strategy 1: XenForo h4 pattern — #### [username](url)
    # Used by: WBF, diyAudio, ASR, Head-Fi, AudioShark
    post_splits = re.split(r"(?=#### \[[\w\s\-_.]+\]\(https?://)", page_text)
    if len(post_splits) > 2:
        return _extract_posts_from_splits(post_splits, heading_level=4)

    # Strategy 2: Steve Hoffman h3 pattern — ###  [username](url)
    # These have numbered list prefixes (  1. [![avatar]...) before the heading
    # Split on the numbered avatar line that precedes each post
    post_splits = re.split(r"(?=\s+\d+\.\s+\[!\[)", page_text)
    if len(post_splits) > 2:
        return _extract_posts_from_splits(post_splits, heading_level=3)

    # Strategy 3: Invision (Audiophile Style) — [Posted date](url) boundaries
    post_splits = re.split(r"(?=\[Posted [A-Z][a-z]+ \d+)", page_text)
    if len(post_splits) > 2:
        return _extract_posts_from_splits(post_splits, heading_level=3)

    # Strategy 4: Fallback — use page as a single chunk
    clean = _strip_chrome(page_text)
    if len(clean) > 100:
        return [{"text": clean, "post_number": None, "author": ""}]

    return []


def _extract_posts_from_splits(splits: list[str], heading_level: int) -> list[dict]:
    """Extract post metadata from split chunks."""
    posts = []
    # Build regex for author extraction based on heading level
    author_re = re.compile(rf"#{{{heading_level}}}\s+\[([\w\s\-_.?&]+)\]")

    for chunk in splits:
        chunk = chunk.strip()
        if len(chunk) < 50:
            continue  # Skip navigation fragments

        # Extract author
        author_match = author_re.search(chunk)
        author = author_match.group(1).strip() if author_match else ""

        # Extract post number — try both [#N] and [ #N ] patterns
        post_match = re.search(r"\[#(\d+)\]|\[ #(\d+) \]", chunk)
        post_num = None
        if post_match:
            post_num = int(post_match.group(1) or post_match.group(2))

        posts.append({
            "text": chunk,
            "post_number": post_num,
            "author": author,
        })

    return posts

    return posts


def _strip_chrome(text: str) -> str:
    """Remove common forum navigation chrome from page text."""
    # Remove markdown link clusters (nav bars)
    text = re.sub(r"(\[[\w\s]+\]\(https?://[^\)]+\)\s*){5,}", "", text)
    # Remove image-only lines
    text = re.sub(r"^\s*!\[.*?\]\(.*?\)\s*$", "", text, flags=re.MULTILINE)
    # Collapse excessive whitespace
    text = re.sub(r"\n{4,}", "\n\n\n", text)
    return text.strip()


# ---------------------------------------------------------------------------
# Chunking — group posts into chunks for Claude
# ---------------------------------------------------------------------------


def chunk_posts(posts: list[dict], target_chars: int = CHUNK_TARGET_CHARS) -> list[list[dict]]:
    """Group posts into chunks that fit within target character count."""
    chunks = []
    current_chunk = []
    current_size = 0

    for post in posts:
        post_size = len(post["text"])
        if current_size + post_size > target_chars and current_chunk:
            chunks.append(current_chunk)
            current_chunk = []
            current_size = 0
        current_chunk.append(post)
        current_size += post_size

    if current_chunk:
        chunks.append(current_chunk)

    return chunks


# ---------------------------------------------------------------------------
# Claude extraction
# ---------------------------------------------------------------------------

EXTRACTION_SYSTEM = """You are extracting structured sentiment data from audiophile forum posts about AXPONA 2025 (a hi-fi audio trade show).

For each distinct sentiment signal in the posts, extract a JSON record. One post may contain multiple sentiments (e.g., positive about a product AND negative about venue acoustics).

Skip posts that contain NO sentiment signal — pure logistics questions, navigation text, or equipment spec lists without opinion language.

Each record must have these fields:
{
  "topic": "Brief description of what the sentiment is about",
  "sentiment": "positive | negative | neutral | mixed",
  "intensity": 1-5,  // 1=mild, 3=moderate, 5=strong
  "quote": "The exact or near-exact text expressing this sentiment (keep under 200 chars)",
  "topic_category": "room | product | venue | logistics | value | experience | industry",
  "author": "Forum username if visible",
  "post_number": null,  // Post # if visible (e.g., #42)
  "topic_entity": "Named entity if mentioned (brand, product, room name)",
  "topic_entity_type": "Product | Brand | Room | Venue | Event | Person | Organization | "
}

Rules:
- Extract ONLY genuine opinion/sentiment — not equipment lists, specs, or factual statements
- If a post lists equipment without commentary, skip it (this is a known false-positive pattern)
- "Cloudflare" is anti-bot noise — never extract it as an entity
- Keep quotes verbatim from the source text when possible
- One record per distinct sentiment signal (don't merge positive + negative into "mixed" — split them)
- If a post has no extractable sentiment, skip it entirely

Return a JSON array of records. If no sentiments found, return [].
"""


def extract_chunk(
    client: anthropic.Anthropic,
    posts: list[dict],
    source_title: str,
    source_url: str,
) -> list[dict]:
    """Send a chunk of posts to Claude for sentiment extraction."""
    # Build the content
    post_texts = []
    for p in posts:
        header = f"[Page {p['page']}"
        if p["post_number"]:
            header += f", Post #{p['post_number']}"
        if p["author"]:
            header += f", Author: {p['author']}"
        header += "]"
        post_texts.append(f"{header}\n{p['text']}")

    content = f"Source: {source_title}\nURL: {source_url}\n\n" + "\n\n---\n\n".join(post_texts)

    response = client.messages.create(
        model=MODEL,
        max_tokens=MAX_TOKENS_PER_CHUNK,
        temperature=0.1,
        system=EXTRACTION_SYSTEM,
        messages=[{"role": "user", "content": content}],
    )

    text = response.content[0].text
    usage = response.usage

    # Parse JSON from response (handle markdown code fences and extra text)
    text = text.strip()
    if text.startswith("```"):
        text = re.sub(r"^```(?:json)?\s*", "", text)
        text = re.sub(r"\s*```\s*$", "", text)

    # Find JSON array in response — Claude sometimes adds explanation text
    json_match = re.search(r"(\[[\s\S]*\])", text)
    if json_match:
        text = json_match.group(1)

    try:
        records = json.loads(text)
    except json.JSONDecodeError:
        print(f"  WARNING: Failed to parse JSON from response ({len(text)} chars)")
        print(f"  First 200 chars: {text[:200]}")
        return [], usage

    # Add source metadata to each record
    for r in records:
        r["source_url"] = source_url
        r["source_title"] = source_title

    return records, usage


# ---------------------------------------------------------------------------
# Deduplication
# ---------------------------------------------------------------------------


def dedup_key(record: dict) -> str:
    """Generate a dedup key from source + topic + quote."""
    raw = f"{record.get('source_title', '')}|{record.get('topic', '')}|{record.get('quote', '')}"
    return hashlib.md5(raw.encode()).hexdigest()


def deduplicate(records: list[dict]) -> list[dict]:
    """Remove duplicate sentiment records."""
    seen = set()
    unique = []
    for r in records:
        key = dedup_key(r)
        if key not in seen:
            seen.add(key)
            unique.append(r)
    return unique


# ---------------------------------------------------------------------------
# Quality filters
# ---------------------------------------------------------------------------


def apply_quality_filters(records: list[dict]) -> tuple[list[dict], dict]:
    """Apply data quality filters. Returns (filtered_records, filter_stats)."""
    stats = {"equipment_list": 0, "cloudflare": 0, "invalid_category": 0, "invalid_sentiment": 0}
    filtered = []

    for r in records:
        # Filter Cloudflare noise
        if "cloudflare" in (r.get("topic_entity") or "").lower():
            stats["cloudflare"] += 1
            continue

        # Normalize and validate category
        cat = (r.get("topic_category") or "").lower().strip()
        if cat not in VALID_CATEGORIES:
            stats["invalid_category"] += 1
            # Try to map common variants
            cat_map = {"rooms": "room", "products": "product", "venues": "venue"}
            cat = cat_map.get(cat, "experience")  # default to experience
        r["topic_category"] = cat

        # Normalize sentiment
        sent = (r.get("sentiment") or "").lower().strip()
        if sent not in VALID_SENTIMENTS:
            stats["invalid_sentiment"] += 1
            sent = "neutral"
        r["sentiment"] = sent

        # Clamp intensity
        intensity = r.get("intensity", 3)
        if not isinstance(intensity, int):
            try:
                intensity = int(intensity)
            except (ValueError, TypeError):
                intensity = 3
        r["intensity"] = max(1, min(5, intensity))

        filtered.append(r)

    return filtered, stats


# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------


def build_output(records: list[dict]) -> dict:
    """Build the output JSON matching the existing schema."""
    by_sentiment = {}
    by_category = {}
    by_source = {}

    for r in records:
        sent = r["sentiment"]
        by_sentiment[sent] = by_sentiment.get(sent, 0) + 1

        cat = r["topic_category"]
        by_category[cat] = by_category.get(cat, 0) + 1

        src = r["source_title"]
        by_source[src] = by_source.get(src, 0) + 1

    return {
        "count": len(records),
        "extracted_at": datetime.now(timezone.utc).isoformat(),
        "model": MODEL,
        "by_sentiment": dict(sorted(by_sentiment.items())),
        "by_category": dict(sorted(by_category.items())),
        "by_source": dict(sorted(by_source.items())),
        "records": records,
    }


# ---------------------------------------------------------------------------
# Checkpointing — write per-source results to disk for resume on crash
# ---------------------------------------------------------------------------


def _checkpoint_path(source_title: str) -> Path:
    """Return the checkpoint file path for a given source title."""
    slug = re.sub(r"[^a-zA-Z0-9]+", "_", source_title).strip("_").lower()
    return CHECKPOINT_DIR / f"{slug}.json"


def save_checkpoint(source_title: str, records: list[dict], usage: dict) -> None:
    """Write extraction results for one source to a checkpoint file."""
    CHECKPOINT_DIR.mkdir(parents=True, exist_ok=True)
    data = {
        "source_title": source_title,
        "extracted_at": datetime.now(timezone.utc).isoformat(),
        "model": MODEL,
        "record_count": len(records),
        "usage": usage,
        "records": records,
    }
    with open(_checkpoint_path(source_title), "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)


def load_checkpoint(source_title: str) -> list[dict] | None:
    """Load checkpoint for a source. Returns records list, or None if no checkpoint."""
    path = _checkpoint_path(source_title)
    if not path.exists():
        return None
    with open(path) as f:
        data = json.load(f)
    return data.get("records", [])


def clear_checkpoints() -> None:
    """Remove all checkpoint files (called after successful completion)."""
    if CHECKPOINT_DIR.exists():
        for f in CHECKPOINT_DIR.glob("*.json"):
            f.unlink()
        CHECKPOINT_DIR.rmdir()


# ---------------------------------------------------------------------------
# Source resolution
# ---------------------------------------------------------------------------


def resolve_source(filename: str) -> dict:
    """Resolve a bronze filename to source metadata."""
    if filename in SOURCE_REGISTRY:
        return SOURCE_REGISTRY[filename]

    # Try to extract source from file header comment
    filepath = BRONZE_DIR / filename
    if filepath.exists():
        head = filepath.read_text()[:500]
        url_match = re.search(r"<!-- source: (https?://\S+) -->", head)
        if url_match:
            url = url_match.group(1)
            return {"title": filename, "url": url, "platform": "unknown"}

    return {"title": filename, "url": "", "platform": "unknown"}


def pick_best_source(sources_by_title: dict[str, list[str]]) -> dict[str, str]:
    """When multiple files map to the same source, pick the largest."""
    best = {}
    for title, filenames in sources_by_title.items():
        if len(filenames) == 1:
            best[title] = filenames[0]
        else:
            # Pick the largest file
            largest = max(filenames, key=lambda f: (BRONZE_DIR / f).stat().st_size)
            best[title] = largest
            others = [f for f in filenames if f != largest]
            print(f"  {title}: using {largest}, skipping {others} (smaller re-crawl)")
    return best


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser(description="Extract sentiment from AXPONA forum crawls")
    parser.add_argument("--source", nargs="+", help="Specific bronze file(s) to process")
    parser.add_argument("--dry-run", action="store_true", help="Show plan without calling Claude")
    parser.add_argument("--min-records", type=int, default=0,
                        help="Only re-extract sources with fewer than N existing records")
    parser.add_argument("--append", action="store_true",
                        help="Append to existing extraction instead of replacing")
    parser.add_argument("--no-resume", action="store_true",
                        help="Ignore checkpoints and re-extract everything")
    args = parser.parse_args()

    # Clear checkpoints if --no-resume
    if args.no_resume:
        clear_checkpoints()

    # Discover bronze sources
    if args.source:
        filenames = args.source
    else:
        filenames = sorted(f.name for f in BRONZE_DIR.glob("*.md"))

    if not filenames:
        print("No bronze forum files found.")
        sys.exit(1)

    # Resolve sources and deduplicate (pick largest when multiple files → same source)
    sources_by_title: dict[str, list[str]] = {}
    for fn in filenames:
        meta = resolve_source(fn)
        title = meta["title"]
        sources_by_title.setdefault(title, []).append(fn)

    best_files = pick_best_source(sources_by_title)

    # Load existing extraction for --min-records filtering
    existing_by_source = {}
    if args.min_records > 0 and OUTPUT_FILE.exists():
        with open(OUTPUT_FILE) as f:
            existing = json.load(f)
        existing_by_source = existing.get("by_source", {})

    # Build extraction plan
    plan = []
    for title, filename in sorted(best_files.items()):
        meta = resolve_source(filename)
        filepath = BRONZE_DIR / filename
        size = filepath.stat().st_size
        existing_count = existing_by_source.get(title, 0)

        if args.min_records > 0 and existing_count >= args.min_records:
            print(f"  SKIP {title}: {existing_count} existing records >= {args.min_records}")
            continue

        plan.append({
            "filename": filename,
            "title": title,
            "url": meta["url"],
            "size": size,
            "existing_records": existing_count,
        })

    # Report plan
    print(f"\n{'='*60}")
    print(f"Sentiment Extraction Plan")
    print(f"{'='*60}")
    print(f"Sources to process: {len(plan)}")
    print(f"Model: {MODEL}")
    print()
    for p in plan:
        print(f"  {p['title']}")
        print(f"    File: {p['filename']} ({p['size']:,} bytes)")
        print(f"    Existing: {p['existing_records']} records")
        print()

    if args.dry_run:
        print("DRY RUN — no API calls made.")

        # Still show post split stats
        for p in plan:
            text = (BRONZE_DIR / p["filename"]).read_text()
            posts = split_into_posts(text, p["filename"])
            chunks = chunk_posts(posts)
            print(f"  {p['title']}: {len(posts)} posts → {len(chunks)} chunks")

        sys.exit(0)

    # Execute extraction with per-source checkpointing
    client = anthropic.Anthropic()
    all_records = []
    total_input = 0
    total_output = 0
    resumed_count = 0

    for p in plan:
        # Check for checkpoint (resume from prior interrupted run)
        cached = load_checkpoint(p["title"])
        if cached is not None:
            print(f"\n--- Resumed from checkpoint: {p['title']} ({len(cached)} records) ---")
            all_records.extend(cached)
            resumed_count += len(cached)
            continue

        print(f"\n--- Extracting: {p['title']} ---")
        text = (BRONZE_DIR / p["filename"]).read_text()

        # Split and chunk
        posts = split_into_posts(text, p["filename"])
        chunks = chunk_posts(posts)
        print(f"  {len(posts)} posts → {len(chunks)} chunks")

        source_records = []
        source_input = 0
        source_output = 0
        for i, chunk in enumerate(chunks):
            print(f"  Chunk {i+1}/{len(chunks)} ({sum(len(p['text']) for p in chunk):,} chars)...", end=" ")
            records, usage = extract_chunk(client, chunk, p["title"], p["url"])
            source_input += usage.input_tokens
            source_output += usage.output_tokens
            total_input += usage.input_tokens
            total_output += usage.output_tokens
            print(f"{len(records)} records (in:{usage.input_tokens} out:{usage.output_tokens})")
            source_records.extend(records)

            # Rate limit courtesy
            if i < len(chunks) - 1:
                time.sleep(0.5)

        # Add page_number from post metadata where missing
        for r in source_records:
            if "page_number" not in r or r["page_number"] is None:
                r.setdefault("page_number", None)

        # Checkpoint — write this source's results to disk immediately
        save_checkpoint(p["title"], source_records,
                        {"input_tokens": source_input, "output_tokens": source_output})

        all_records.extend(source_records)
        print(f"  Total for source: {len(source_records)} records (checkpointed)")

    if resumed_count > 0:
        print(f"\nResumed {resumed_count} records from checkpoints")

    # Post-processing
    print(f"\n{'='*60}")
    print(f"Post-processing")
    print(f"{'='*60}")

    print(f"Raw records: {len(all_records)}")

    # Deduplicate
    all_records = deduplicate(all_records)
    print(f"After dedup: {len(all_records)}")

    # Quality filters
    all_records, filter_stats = apply_quality_filters(all_records)
    print(f"After quality filters: {len(all_records)}")
    for k, v in filter_stats.items():
        if v > 0:
            print(f"  Filtered {k}: {v}")

    # Merge with existing if --append
    if args.append and OUTPUT_FILE.exists():
        with open(OUTPUT_FILE) as f:
            existing = json.load(f)
        existing_records = existing.get("records", [])
        print(f"Appending to {len(existing_records)} existing records...")
        all_records = existing_records + all_records
        all_records = deduplicate(all_records)
        print(f"After merge + dedup: {len(all_records)}")

    # Build output
    output = build_output(all_records)

    # Cost summary
    cost = (total_input / 1_000_000) * 3.0 + (total_output / 1_000_000) * 15.0
    print(f"\nAPI usage: {total_input:,} input + {total_output:,} output tokens")
    print(f"Estimated cost: ${cost:.4f}")

    # Write output
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT_FILE, "w") as f:
        json.dump(output, f, indent=2, ensure_ascii=False)
    print(f"\nWrote {output['count']} records to {OUTPUT_FILE}")

    # Clean up checkpoints after successful write
    clear_checkpoints()
    print("Checkpoints cleared.")

    # Summary table
    print(f"\n{'='*60}")
    print(f"Extraction Summary")
    print(f"{'='*60}")
    print(f"{'Source':<55} {'Count':>5}")
    print(f"{'-'*55} {'-'*5}")
    for src, count in sorted(output["by_source"].items()):
        print(f"{src:<55} {count:>5}")
    print(f"{'-'*55} {'-'*5}")
    print(f"{'TOTAL':<55} {output['count']:>5}")
    print()
    print(f"By sentiment: {output['by_sentiment']}")
    print(f"By category:  {output['by_category']}")


if __name__ == "__main__":
    main()
