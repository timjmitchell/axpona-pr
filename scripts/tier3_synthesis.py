"""
Tier 3: Claude synthesis on structured extraction data.

Cross-source analysis that requires reasoning, not just classification:
1. Reference model validation — which predicted entities now have concrete evidence?
2. Exhibitor-sponsor overlap — revenue intelligence
3. Pricing analysis — revenue modeling from structured data
4. Updated gap assessment — what changed from the original gap analysis?

Usage:
    python scripts/tier3_synthesis.py
"""

import json
from pathlib import Path

import anthropic

MODEL = "claude-sonnet-4-20250514"
COMPANY_DIR = Path("companies/axpona")


def load_context() -> dict:
    """Load all structured data and reference model context."""
    context = {}

    # Enriched extraction
    with open(COMPANY_DIR / "enriched-extraction.json") as f:
        context["extraction"] = json.load(f)

    # Reference model (key sections only)
    ref_model = (COMPANY_DIR / "axpona-reference-model.md").read_text()
    context["reference_model"] = ref_model

    # Gap analysis
    gap = (COMPANY_DIR / "gap-analysis.md").read_text()
    context["gap_analysis"] = gap

    return context


SYNTHESIS_PROMPT = """You are analyzing structured extraction data for AXPONA, a hi-fi audio trade show, against its reference model and gap analysis.

## Structured Extraction Data (from regex + Ollama classification)

### Exhibitor Brands ({brand_count} total)
Category distribution:
{category_summary}

Top exhibitors by brand count:
{top_exhibitors}

### Sponsorship Inventory ({sponsor_count} items)
- Sold: {sponsor_sold}, Available: {sponsor_available}
- Min sold revenue: ${sponsor_revenue:,}
- Categories: {sponsor_categories}

### Ticket Types ({ticket_count})
{ticket_summary}

## Reference Model (predicted entities)

{reference_entities}

## Previous Gap Analysis (from #37)

Key gaps identified:
- 15/21 CORE entities confirmed, 3 not externally observable, 1 may not exist (MatchmakingAppointment), 2 partial
- ProductListing was "Partial" — "Exhibitors by Brand page exists"
- SponsorshipItem was confirmed but without detailed inventory
- Attendee entity confirmed but ticket structure not detailed

## Your Analysis

Produce a structured analysis covering:

### 1. Reference Model Validation Update
For each predicted CORE entity, assess whether the new structured data provides STRONGER evidence than before. Focus on entities where status changed (e.g., "Partial" → "Confirmed with detail").

### 2. Revenue Intelligence
Using the structured data:
- Estimate sponsorship revenue potential (sold items + pricing of available items)
- Analyze exhibitor space revenue from location distribution
- Map ticket revenue model (types × estimated volume)
- Compare to UFI 5S revenue model predictions from the reference model

### 3. Cross-Source Findings
What patterns emerge from combining exhibitor, sponsorship, and ticket data?
- Exhibitor concentration (how many exhibitors carry multiple brands?)
- Location premium patterns (premium rooms vs expo hall)
- Sponsorship sell-through rate by category

### 4. Updated Gap Assessment
What gaps from the original analysis are now closed? What new questions emerged?

Be specific and cite numbers from the data. Keep the analysis concise — this feeds into a consulting deliverable."""


def build_prompt(context: dict) -> str:
    """Build the synthesis prompt from context data."""
    extraction = context["extraction"]
    brands = extraction["exhibitor_brands"]
    sponsors = extraction["sponsorship_items"]
    tickets = extraction["ticket_types"]

    # Category summary
    cat_summary = "\n".join(
        f"- {cat}: {count}"
        for cat, count in brands.get("category_summary", {}).items()
    )

    # Top exhibitors (from Neo4j query results, hardcode from earlier)
    top_exhibitors = """- Music Direct: 70 brands
- Milwaukee Vintage: 36 brands
- Playback Distribution: 18 brands
- MoFi Distribution: 17 brands
- Quintessence Audio: 17 brands"""

    # Sponsor categories
    sponsor_cats = {}
    for item in sponsors.get("items", []):
        cat = item.get("category", "Unknown")
        sponsor_cats[cat] = sponsor_cats.get(cat, 0) + 1
    sponsor_categories = ", ".join(f"{k} ({v})" for k, v in sponsor_cats.items())

    # Ticket summary
    ticket_lines = []
    for t in tickets.get("types", []):
        inc = f" — {len(t.get('inclusions', []))} perks" if t.get("inclusions") else ""
        ticket_lines.append(
            f"- {t['ticket_name']}: Regular {t.get('regular_price', '?')}, "
            f"Onsite {t.get('onsite_price', 'N/A')}{inc}"
        )
    ticket_summary = "\n".join(ticket_lines)

    # Reference entities (just the CORE table)
    ref_lines = []
    ref_model = context["reference_model"]
    # Extract the CORE entities section
    core_start = ref_model.find("### CORE (21)")
    core_end = ref_model.find("### SUPPORTING")
    if core_start > 0 and core_end > 0:
        ref_lines.append(ref_model[core_start:core_end].strip())

    return SYNTHESIS_PROMPT.format(
        brand_count=brands.get("count", 0),
        category_summary=cat_summary,
        top_exhibitors=top_exhibitors,
        sponsor_count=sponsors.get("count", 0),
        sponsor_sold=sponsors.get("sold", 0),
        sponsor_available=sponsors.get("available", 0),
        sponsor_revenue=sponsors.get("min_sold_revenue", 0),
        sponsor_categories=sponsor_categories,
        ticket_count=tickets.get("count", 0),
        ticket_summary=ticket_summary,
        reference_entities="\n".join(ref_lines),
    )


def run_synthesis():
    """Run the Tier 3 Claude synthesis."""
    print("Loading context...")
    context = load_context()

    print("Building prompt...")
    prompt = build_prompt(context)
    print(f"Prompt: {len(prompt)} chars")

    print(f"Calling {MODEL}...")
    client = anthropic.Anthropic()
    response = client.messages.create(
        model=MODEL,
        max_tokens=4096,
        temperature=0.2,
        system="You are a business architecture consultant producing a data-driven analysis for a trade show due diligence engagement. Be precise, cite numbers, and structure findings clearly.",
        messages=[{"role": "user", "content": prompt}],
    )

    text = response.content[0].text
    usage = response.usage

    print(f"Tokens: {usage.input_tokens} in, {usage.output_tokens} out")
    cost = (usage.input_tokens / 1_000_000) * 3.0 + (usage.output_tokens / 1_000_000) * 15.0
    print(f"Cost: ${cost:.4f}")

    # Save
    output_path = COMPANY_DIR / "tier3-synthesis.md"
    with open(output_path, "w") as f:
        f.write(f"# AXPONA — Tier 3 Synthesis Report\n\n")
        f.write(f"> **Generated:** 2026-03-16\n")
        f.write(f"> **Model:** {MODEL}\n")
        f.write(f"> **Source:** Structured extraction (588 brands, 51 sponsorships, 6 ticket types)\n")
        f.write(f"> **Issue:** [research-pr#44](https://github.com/timjmitchell/research-pr/issues/44)\n\n")
        f.write(text)

    print(f"\nSaved to {output_path}")
    print(f"\n{'='*60}")
    print(text[:2000])
    if len(text) > 2000:
        print(f"\n... ({len(text)} chars total)")


if __name__ == "__main__":
    run_synthesis()
