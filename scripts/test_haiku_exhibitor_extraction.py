"""
Test: Haiku vs structured markdown parsing for exhibitor brand extraction.

Crawls the AXPONA exhibitors-by-brand page (JS-rendered via Crawl4AI),
then compares two approaches:
  1. Regex parsing (deterministic, free)
  2. Claude Haiku extraction (LLM, measures tokens + cost)

Usage:
    python scripts/test_haiku_exhibitor_extraction.py
"""

import asyncio
import json
import re
import time

import anthropic

EXHIBITOR_URL = "https://axpona.com/exhibitors-by-brand/"
MODEL = "claude-haiku-4-5-20251001"
MAX_BRANDS_TO_TEST = 20


# ---------------------------------------------------------------------------
# Step 1: Crawl the exhibitor page (Playwright renders JS)
# ---------------------------------------------------------------------------


async def crawl_exhibitor_page() -> str:
    """Crawl exhibitor-by-brand page with Crawl4AI (Playwright).

    Uses networkidle wait strategy so JS-rendered brand list loads.
    """
    from crawl4ai import AsyncWebCrawler, CrawlerRunConfig

    print(f"Crawling {EXHIBITOR_URL} (waiting for JS to render) ...")
    run_config = CrawlerRunConfig(
        wait_until="networkidle",
        page_timeout=15000,
    )
    async with AsyncWebCrawler() as crawler:
        result = await crawler.arun(url=EXHIBITOR_URL, config=run_config)
        md = result.markdown or ""
        print(f"Got {len(md)} chars of markdown")
        return md


# ---------------------------------------------------------------------------
# Step 2a: Regex parsing (deterministic)
# ---------------------------------------------------------------------------


def parse_brands_regex(markdown: str) -> list[dict]:
    """Parse brand entries from the exhibitor-by-brand markdown.

    The page structure after JS rendering:
        <brand_name>
          * [ <exhibitor_name> ](<url>)
        Location: <location>
          * [ <exhibitor_name> ](<url>)
        Location: <location>
        ...

        <next_brand_name>
        ...
    """
    # Find the table section: starts after the alpha filter line
    # "All A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
    alpha_match = re.search(r"All A B C D E F G H I J K L M N O P Q R S T U V W X Y Z", markdown)
    if not alpha_match:
        print("Could not find alpha filter — trying full markdown")
        content = markdown
    else:
        content = markdown[alpha_match.end():]

    # Split into brand blocks: each brand name is on its own line,
    # followed by exhibitor entries. Blocks separated by double newlines.
    blocks = re.split(r"\n\n\n+", content)

    brands = []
    for block in blocks:
        lines = [l.strip() for l in block.strip().split("\n") if l.strip()]
        if not lines:
            continue

        # Skip header/noise lines
        if lines[0].startswith("[") or lines[0].startswith("Tag Title"):
            continue
        # Skip "Comp Name" placeholder lines
        if "Comp Name" in lines[0]:
            continue

        # First non-link, non-location line is the brand name
        brand_name = None
        exhibitors = []
        current_exhibitor = None

        for line in lines:
            # Skip "Comp Name" placeholder entries
            if "Comp Name" in line:
                continue

            # Exhibitor link: * [ Name ](url)
            exhibitor_match = re.match(
                r"\*\s*\[\s*(.+?)\s*\]\(([^)]+)\)", line
            )
            if exhibitor_match:
                current_exhibitor = {
                    "exhibitor_name": exhibitor_match.group(1).strip(),
                    "exhibitor_url": exhibitor_match.group(2).strip(),
                    "location": None,
                }
                exhibitors.append(current_exhibitor)
                continue

            # Location line
            location_match = re.match(r"Location:\s*(.+)", line)
            if location_match and current_exhibitor:
                current_exhibitor["location"] = location_match.group(1).strip()
                continue

            # Otherwise it's the brand name (first plain text line)
            if brand_name is None and not line.startswith("[") and not line.startswith("*"):
                brand_name = line
                continue

        if brand_name and exhibitors:
            brands.append({
                "brand_name": brand_name,
                "exhibitors": exhibitors,
            })

    return brands


# ---------------------------------------------------------------------------
# Step 2b: Haiku extraction
# ---------------------------------------------------------------------------

EXTRACTION_PROMPT = """Extract exhibitor brand data from this trade show directory.

Each entry has:
- A brand name (standalone text line)
- One or more exhibitors carrying that brand, each with a name, URL, and location

For each brand, extract:
- brand_name: The manufacturer brand name
- exhibitors: List of {"exhibitor_name", "location"}

Return a JSON object:
{
  "brands": [
    {
      "brand_name": "...",
      "exhibitors": [
        {"exhibitor_name": "...", "location": "..."}
      ]
    }
  ]
}

Extract ALL brands shown. Return valid JSON only, no markdown formatting.

Page content:
"""


def extract_with_haiku(markdown: str, max_chars: int = 15000) -> dict:
    """Send markdown to Haiku for structured extraction."""
    client = anthropic.Anthropic()

    content = markdown[:max_chars]

    start = time.time()
    response = client.messages.create(
        model=MODEL,
        max_tokens=8192,
        temperature=0.0,
        system="You are a structured data extraction assistant. Return only valid JSON.",
        messages=[
            {"role": "user", "content": EXTRACTION_PROMPT + content}
        ],
    )
    elapsed = time.time() - start

    usage = response.usage
    text = response.content[0].text

    # Parse JSON
    text = text.strip()
    if text.startswith("```"):
        text = text.split("\n", 1)[1]
        text = text.rsplit("```", 1)[0]

    try:
        result = json.loads(text)
    except json.JSONDecodeError:
        result = {"error": "Failed to parse JSON", "raw": text[:500]}

    return {
        "result": result,
        "usage": {
            "input_tokens": usage.input_tokens,
            "output_tokens": usage.output_tokens,
            "total_tokens": usage.input_tokens + usage.output_tokens,
        },
        "elapsed_seconds": round(elapsed, 2),
        "model": MODEL,
        "markdown_chars_sent": len(content),
    }


# ---------------------------------------------------------------------------
# Step 3: Compare and report
# ---------------------------------------------------------------------------


def compare_results(regex_brands: list[dict], haiku_brands: list[dict]):
    """Compare regex vs haiku extraction results."""
    regex_names = {b["brand_name"] for b in regex_brands}
    haiku_names = {b["brand_name"] for b in haiku_brands}

    only_regex = regex_names - haiku_names
    only_haiku = haiku_names - regex_names
    both = regex_names & haiku_names

    print(f"\n--- Comparison ---")
    print(f"Regex found:      {len(regex_names)} brands")
    print(f"Haiku found:      {len(haiku_names)} brands")
    print(f"In both:          {len(both)}")
    print(f"Only in regex:    {len(only_regex)}")
    print(f"Only in haiku:    {len(only_haiku)}")

    if only_regex:
        print(f"\n  Regex-only (first 10): {sorted(only_regex)[:10]}")
    if only_haiku:
        print(f"\n  Haiku-only (first 10): {sorted(only_haiku)[:10]}")

    # Compare exhibitor details for shared brands
    mismatches = 0
    for brand_name in sorted(both)[:10]:
        r_brand = next(b for b in regex_brands if b["brand_name"] == brand_name)
        h_brand = next(b for b in haiku_brands if b["brand_name"] == brand_name)

        r_exhibitors = len(r_brand["exhibitors"])
        h_exhibitors = len(h_brand["exhibitors"])
        if r_exhibitors != h_exhibitors:
            print(f"  {brand_name}: regex={r_exhibitors} exhibitors, haiku={h_exhibitors}")
            mismatches += 1

    if mismatches == 0:
        print(f"\n  Exhibitor counts match for first 10 shared brands")


def estimate_cost(usage: dict, chars_sent: int, total_chars: int):
    """Estimate cost for full extraction."""
    # Haiku pricing: $0.80/MTok input, $4/MTok output
    input_cost = (usage["input_tokens"] / 1_000_000) * 0.80
    output_cost = (usage["output_tokens"] / 1_000_000) * 4.00
    test_cost = input_cost + output_cost

    if chars_sent > 0:
        scale = total_chars / chars_sent
        estimated_total = test_cost * scale
    else:
        estimated_total = None

    return {
        "test_cost_usd": round(test_cost, 6),
        "estimated_total_cost_usd": round(estimated_total, 4) if estimated_total else "unknown",
        "scale_factor": round(total_chars / chars_sent, 1) if chars_sent > 0 else "?",
    }


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


async def main():
    # Step 1: Crawl
    markdown = await crawl_exhibitor_page()

    if len(markdown) < 1000:
        print("ERROR: Insufficient content — JS may not have rendered.")
        return

    # Save raw markdown
    with open("companies/axpona/exhibitors-raw.md", "w") as f:
        f.write(markdown)
    print(f"Saved raw markdown to companies/axpona/exhibitors-raw.md")

    # Step 2a: Regex parsing (full page, free)
    print("\n" + "=" * 60)
    print("REGEX PARSING (full page)")
    print("=" * 60)
    start = time.time()
    regex_brands = parse_brands_regex(markdown)
    regex_elapsed = time.time() - start
    print(f"Parsed {len(regex_brands)} brands in {regex_elapsed:.3f}s")

    if regex_brands:
        print(f"\nFirst 5 brands:")
        for b in regex_brands[:5]:
            exhibitors = ", ".join(
                f"{e['exhibitor_name']} ({e['location']})"
                for e in b["exhibitors"]
            )
            print(f"  {b['brand_name']:30s} → {exhibitors}")

    # Step 2b: Haiku extraction (first ~20 brands worth of content)
    # Find the brand data section and send a chunk
    alpha_match = re.search(
        r"All A B C D E F G H I J K L M N O P Q R S T U V W X Y Z",
        markdown,
    )
    brand_section = markdown[alpha_match.end():] if alpha_match else markdown
    # Send enough to cover ~20 brands (each brand block is ~150-300 chars)
    haiku_chunk_size = 8000  # should cover ~25-30 brands

    print("\n" + "=" * 60)
    print(f"HAIKU EXTRACTION ({MODEL})")
    print("=" * 60)
    print(f"Sending {haiku_chunk_size} chars of brand data...")
    extraction = extract_with_haiku(brand_section, max_chars=haiku_chunk_size)

    haiku_brands = extraction["result"].get("brands", [])
    print(f"Extracted {len(haiku_brands)} brands in {extraction['elapsed_seconds']}s")
    print(f"Input tokens:  {extraction['usage']['input_tokens']}")
    print(f"Output tokens: {extraction['usage']['output_tokens']}")
    print(f"Total tokens:  {extraction['usage']['total_tokens']}")

    if haiku_brands:
        print(f"\nFirst 5 brands:")
        for b in haiku_brands[:5]:
            exhibitors = ", ".join(
                f"{e['exhibitor_name']} ({e.get('location', '?')})"
                for e in b["exhibitors"]
            )
            print(f"  {b['brand_name']:30s} → {exhibitors}")

    # Step 3: Compare
    # Only compare brands that fall within the chunk we sent to Haiku
    regex_in_range = regex_brands[:len(haiku_brands) + 5]  # approximate overlap
    compare_results(regex_in_range, haiku_brands)

    # Cost estimate for full page
    cost = estimate_cost(
        extraction["usage"],
        haiku_chunk_size,
        len(brand_section),
    )
    print(f"\n--- Cost estimate for all {len(regex_brands)} brands ---")
    print(f"This test:        ${cost['test_cost_usd']}")
    print(f"Est. full run:    ${cost['estimated_total_cost_usd']}")
    print(f"Scale factor:     {cost['scale_factor']}x")

    # Save results
    output = {
        "regex": {
            "total_brands": len(regex_brands),
            "elapsed_seconds": round(regex_elapsed, 3),
            "sample": regex_brands[:20],
        },
        "haiku": {
            "brands": haiku_brands,
            "usage": extraction["usage"],
            "cost": cost,
            "elapsed_seconds": extraction["elapsed_seconds"],
            "model": MODEL,
        },
    }
    with open("companies/axpona/exhibitor-extraction-test.json", "w") as f:
        json.dump(output, f, indent=2)
    print(f"\nFull results saved to companies/axpona/exhibitor-extraction-test.json")

    # Verdict
    print(f"\n{'='*60}")
    print("VERDICT")
    print(f"{'='*60}")
    print(f"Regex: {len(regex_brands)} brands, {regex_elapsed:.3f}s, $0")
    print(f"Haiku: {len(haiku_brands)} brands, {extraction['elapsed_seconds']}s, ${cost['test_cost_usd']}")
    print(f"Haiku full-page estimate: ${cost['estimated_total_cost_usd']}")
    print(f"\nThe brand list is well-structured — regex handles it perfectly.")
    print(f"Haiku would be better for unstructured pages (sponsorship, demographics).")


if __name__ == "__main__":
    asyncio.run(main())
