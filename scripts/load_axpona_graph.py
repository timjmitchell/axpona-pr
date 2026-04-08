#!/usr/bin/env python3
"""
Load AXPONA domain model into Neo4j.

Reads YAML data sources from the mirror layer and creates a graph of:
  - BoundedContext nodes (8) with weight and ddd_type
  - Pattern nodes (17) with type and status
  - Capability nodes (72) with cognitive_load
  - System nodes (7) with confidence and system_type
  - Entity nodes (8) from business model with weight
  - Goal nodes (3) with scope and target_metrics
  - Hierarchy edges: Context→Pattern→Capability, System→Context
  - Graph edges from graph.yaml (typed domain relationships)

Prereqs: Neo4j running on localhost:7476 (no auth).
Deps: Python 3.10+ stdlib + PyYAML only.

Usage:
    python scripts/load_axpona_graph.py           # Load (additive)
    python scripts/load_axpona_graph.py --clear    # Clear AXPONA nodes first
    python scripts/load_axpona_graph.py --dry-run  # Print stats, don't write
"""

from __future__ import annotations

import argparse
import json
import sys
import urllib.request
import urllib.error
from pathlib import Path
from typing import Any

import yaml

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

NEO4J_TX_URL = "http://localhost:7476/db/neo4j/tx/commit"
MIRROR = Path(__file__).resolve().parent.parent / "mirror"

DATA_SOURCES = {
    "business_model": MIRROR / "domain" / "outside-in" / "business-model.yaml",
    "registry": MIRROR / "domain" / "patterns" / "registry.yaml",
    "systems": MIRROR / "domain" / "outside-in" / "system-inventory.yaml",
    "graph": MIRROR / "infrastructure" / "corpus" / "graph.yaml",
}

ENGAGEMENT = "axpona-pr"

# Entity name → context ID mapping
ENTITY_TO_CONTEXT = {
    "Exhibitor": "exhibitor",
    "Sponsorship": "sponsorship",
    "ExhibitionSpace": "exhibition-space",
    "Event": "event",
    "Attendee": "attendee",
    "Interaction": "interaction",
    "Agreement": "agreement",
    "Finance": "finance",
}


# ---------------------------------------------------------------------------
# Neo4j HTTP helpers (stdlib only — no driver dependency)
# ---------------------------------------------------------------------------

def run_cypher(statements: list[dict[str, Any]], dry_run: bool = False) -> dict:
    """Execute Cypher statements via the Neo4j HTTP transactional API."""
    if dry_run:
        return {"results": [], "errors": []}

    payload = json.dumps({"statements": statements}).encode()
    req = urllib.request.Request(
        NEO4J_TX_URL,
        data=payload,
        headers={"Content-Type": "application/json", "Accept": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read())
    except urllib.error.URLError as e:
        print(f"ERROR: Cannot reach Neo4j at {NEO4J_TX_URL}: {e}", file=sys.stderr)
        sys.exit(1)

    if result.get("errors"):
        for err in result["errors"]:
            print(f"  Neo4j error: {err['message']}", file=sys.stderr)
    return result


def cypher(statement: str, parameters: dict | None = None) -> dict[str, Any]:
    """Build a single Cypher statement dict."""
    s: dict[str, Any] = {"statement": statement}
    if parameters:
        s["parameters"] = parameters
    return s


def load_yaml(path: Path) -> dict:
    with open(path) as f:
        return yaml.safe_load(f)


def capability_name(cap: str | dict) -> str:
    if isinstance(cap, str):
        return cap
    return cap["name"]


def capability_props(cap: str | dict) -> dict[str, Any]:
    if isinstance(cap, str):
        return {"capability_type": "simple"}
    props: dict[str, Any] = {"capability_type": "process"}
    for field in ("coordination_type", "cognitive_load", "trigger", "outcome", "apqc_reference"):
        if field in cap:
            props[field] = cap[field]
    if "compensation" in cap:
        props["compensation"] = ", ".join(cap["compensation"])
    return props


# ---------------------------------------------------------------------------
# Graph construction
# ---------------------------------------------------------------------------

def build_statements(dry_run: bool = False) -> tuple[list[dict], dict[str, int]]:
    stmts: list[dict] = []
    stats: dict[str, int] = {
        "contexts": 0, "patterns": 0, "capabilities": 0,
        "systems": 0, "entities": 0, "goals": 0,
        "edges_hierarchy": 0, "edges_graph": 0,
    }

    bm = load_yaml(DATA_SOURCES["business_model"])
    reg = load_yaml(DATA_SOURCES["registry"])
    sys_inv = load_yaml(DATA_SOURCES["systems"])
    graph = load_yaml(DATA_SOURCES["graph"])

    # --- 1. Bounded Contexts (from business model entities) ---
    for entity in bm["business_model"]["entities"]:
        ctx_id = ENTITY_TO_CONTEXT.get(entity["name"])
        if not ctx_id:
            continue
        weight = entity.get("weight", 0.5)
        stmts.append(cypher(
            "MERGE (n:BoundedContext {id: $id}) SET n += $props",
            {"id": ctx_id, "props": {
                "weight": weight,
                "ddd_type": entity.get("ddd_type", ""),
                "signal_source": entity.get("signal_source", ""),
                "description": entity.get("description", ""),
                "engagement": ENGAGEMENT,
                "display_name": entity["name"],
                "size": int(weight * 100),
            }},
        ))
        stats["contexts"] += 1

    # --- 2. Patterns + Capabilities + hierarchy edges ---
    all_patterns = reg.get("patterns", [])

    for pat in all_patterns:
        pat_id = pat["id"]
        pat_type = pat.get("type", "domain")
        pat_props = {
            "type": pat_type,
            "status": pat.get("status", "planned"),
            "engagement": ENGAGEMENT,
            "display_name": pat_id,
        }
        if "ddd_type" in pat:
            pat_props["ddd_type"] = pat["ddd_type"]

        if pat_type == "goal":
            stmts.append(cypher(
                "MERGE (n:Goal {id: $id}) SET n += $props",
                {"id": pat_id, "props": pat_props},
            ))
            stats["goals"] += 1

            # Goal MEASURES domain patterns
            for measured in pat.get("measures", []):
                stmts.append(cypher(
                    "MATCH (g:Goal {id: $gid}), (p:Pattern {id: $pid}) "
                    "MERGE (g)-[:MEASURES]->(p)",
                    {"gid": pat_id, "pid": measured},
                ))
                stats["edges_hierarchy"] += 1

            # Goal → contexts
            for ctx_id in pat.get("contexts", []):
                stmts.append(cypher(
                    "MATCH (g:Goal {id: $gid}), (c:BoundedContext {id: $cid}) "
                    "MERGE (g)-[:TARGETS]->(c)",
                    {"gid": pat_id, "cid": ctx_id},
                ))
                stats["edges_hierarchy"] += 1

        else:
            stmts.append(cypher(
                "MERGE (n:Pattern {id: $id}) SET n += $props",
                {"id": pat_id, "props": pat_props},
            ))
            stats["patterns"] += 1

            # Pattern → Context edges
            for ctx_id in pat.get("contexts", []):
                stmts.append(cypher(
                    "MATCH (p:Pattern {id: $pid}), (c:BoundedContext {id: $cid}) "
                    "MERGE (c)-[:IMPLEMENTS]->(p)",
                    {"pid": pat_id, "cid": ctx_id},
                ))
                stats["edges_hierarchy"] += 1

            # Analytics MEASURES domain patterns
            if pat_type == "analytics":
                for measured in pat.get("measures", []):
                    stmts.append(cypher(
                        "MATCH (a:Pattern {id: $aid}), (d:Pattern {id: $did}) "
                        "MERGE (a)-[:MEASURES]->(d)",
                        {"aid": pat_id, "did": measured},
                    ))
                    stats["edges_hierarchy"] += 1

            # Capabilities
            for cap in pat.get("capabilities", []):
                cap_id = capability_name(cap)
                cap_p = capability_props(cap)
                cap_p["engagement"] = ENGAGEMENT
                cap_p["display_name"] = cap_id

                stmts.append(cypher(
                    "MERGE (n:Capability {id: $id}) SET n += $props",
                    {"id": cap_id, "props": cap_p},
                ))
                stats["capabilities"] += 1

                stmts.append(cypher(
                    "MATCH (p:Pattern {id: $pid}), (c:Capability {id: $cid}) "
                    "MERGE (p)-[:DELIVERS]->(c)",
                    {"pid": pat_id, "cid": cap_id},
                ))
                stats["edges_hierarchy"] += 1

    # --- 3. Systems ---
    for system in sys_inv.get("systems", []):
        sys_id = system["id"]
        stmts.append(cypher(
            "MERGE (n:System {id: $id}) SET n += $props",
            {"id": sys_id, "props": {
                "name": system.get("name", sys_id),
                "vendor": system.get("vendor", ""),
                "system_type": system.get("system_type", ""),
                "confidence": system.get("confidence", ""),
                "engagement": ENGAGEMENT,
                "display_name": system.get("name", sys_id),
            }},
        ))
        stats["systems"] += 1

        for bc_ref in system.get("bounded_contexts", []):
            # Parse "Exhibitor (primary)" → "exhibitor"
            ctx_name = bc_ref.split("(")[0].strip().lower().replace(" ", "-")
            stmts.append(cypher(
                "MATCH (s:System {id: $sid}), (c:BoundedContext {id: $cid}) "
                "MERGE (s)-[:SERVES]->(c)",
                {"sid": sys_id, "cid": ctx_name},
            ))
            stats["edges_hierarchy"] += 1

    # --- 4. Graph edges (domain-specific relationships) ---
    for edge in graph.get("edges", []):
        src = edge["source"]
        tgt = edge["target"]
        pred = edge["predicate"]
        strength = edge.get("strength", 1.0)
        note = edge.get("note", "")

        # Parse "context:exhibitor" → label=BoundedContext, id=exhibitor
        def parse_ref(ref: str) -> tuple[str, str]:
            if ":" in ref:
                label, eid = ref.split(":", 1)
                label_map = {
                    "context": "BoundedContext", "stage": "Stage",
                    "event": "DomainEvent", "metric": "Metric",
                    "prescription": "Prescription", "capability": "Capability",
                    "corpus": "CorpusSource",
                }
                return label_map.get(label, label.title()), eid
            return "Node", ref

        src_label, src_id = parse_ref(src)
        tgt_label, tgt_id = parse_ref(tgt)

        # Ensure nodes exist (MERGE with label)
        for label, nid in [(src_label, src_id), (tgt_label, tgt_id)]:
            stmts.append(cypher(
                f"MERGE (n:{label} {{id: $id}}) "
                f"ON CREATE SET n.engagement = $eng, n.display_name = $id",
                {"id": nid, "eng": ENGAGEMENT},
            ))

        # Create edge
        safe_pred = pred.upper().replace(" ", "_")
        stmts.append(cypher(
            f"MATCH (a:{src_label} {{id: $sid}}), (b:{tgt_label} {{id: $tid}}) "
            f"MERGE (a)-[r:{safe_pred}]->(b) "
            f"SET r.strength = $str, r.note = $note",
            {"sid": src_id, "tid": tgt_id, "str": strength, "note": note},
        ))
        stats["edges_graph"] += 1

    return stmts, stats


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="Load AXPONA domain model into Neo4j")
    parser.add_argument("--clear", action="store_true", help="Clear AXPONA nodes first")
    parser.add_argument("--dry-run", action="store_true", help="Print stats, don't write")
    args = parser.parse_args()

    # Verify data sources exist
    for name, path in DATA_SOURCES.items():
        if not path.exists():
            print(f"ERROR: Missing {name}: {path}", file=sys.stderr)
            sys.exit(1)

    # Clear if requested
    if args.clear and not args.dry_run:
        print(f"Clearing all {ENGAGEMENT} nodes...")
        run_cypher([cypher(
            "MATCH (n {engagement: $eng}) DETACH DELETE n",
            {"eng": ENGAGEMENT},
        )])

    # Build and execute
    stmts, stats = build_statements(dry_run=args.dry_run)

    print(f"\n{'[DRY RUN] ' if args.dry_run else ''}AXPONA graph summary:")
    print(f"  Contexts:     {stats['contexts']}")
    print(f"  Patterns:     {stats['patterns']}")
    print(f"  Capabilities: {stats['capabilities']}")
    print(f"  Systems:      {stats['systems']}")
    print(f"  Goals:        {stats['goals']}")
    print(f"  Hierarchy edges: {stats['edges_hierarchy']}")
    print(f"  Graph edges:     {stats['edges_graph']}")
    print(f"  Total statements: {len(stmts)}")

    if not args.dry_run:
        # Batch into chunks of 100 statements
        batch_size = 100
        for i in range(0, len(stmts), batch_size):
            batch = stmts[i:i + batch_size]
            result = run_cypher(batch)
            if result.get("errors"):
                print(f"  Batch {i // batch_size + 1}: {len(result['errors'])} errors")
            else:
                print(f"  Batch {i // batch_size + 1}: OK ({len(batch)} statements)")

        print(f"\nLoaded into Neo4j at {NEO4J_TX_URL}")
        print(f"Open http://localhost:7476 to browse the AXPONA domain model")


if __name__ == "__main__":
    main()
