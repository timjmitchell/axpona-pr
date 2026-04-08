# Issue #2: Create research agent for trade show strategy analysis

> **Issue:** [axpona-pr#2](https://github.com/timjmitchell/axpona-pr/issues/2)
> **Status:** In Progress

## 2026-04-08
<!-- @appended by /issue on 2026-04-08T00:00:00Z -->

### Context

Build an agent prescription in `mirror/application/agents/` that produces structured strategic research deliverables like the show-timing-location-research document. The agent uses a three-layer analysis framework (cross-vertical, subject matter, client-specific) and synthesizes web research, forum sentiment, client data, and cross-vertical pattern recognition.

Key references:
- Gold-standard output: `mirror/presentation/show-timing-location-research.md`
- Existing prescriptions: `mirror/application/agents/prescriptions.yaml` (operational agents from /scale-project)
- Ridgeline format reference: `ridgeline-demo/mirror/application/agents/prescriptions.yaml`
- Bronze layer data: `mirror/infrastructure/data/bronze/`

### Work Done

- Scoped the agent through iterative design discussion — started as standalone three-layer framework, refined to pipeline-based approach using `/classify` → `/predict` → `/recon`
- Core insight: the agent's primary capability is **peer discovery from baseline attributes**, not standalone analysis. Given the AXPONA baseline, it discovers structurally similar companies across verticals, validates them via lightweight `/classify`, and produces comparable baselines.
- Added `rx-peer-discovery` prescription to `mirror/application/agents/prescriptions.yaml` under new `PHASE S: STRATEGIC RESEARCH` section
- Four processing phases: A-extract (search criteria from baseline), B-discover (web search across verticals), C-validate (lightweight /classify for structural fit), D-baseline (full baseline for validated peers)
- Wired in agent-training learning loop — search strategy and validation criteria improve over iterations
- Updated summary block (8 prescriptions, 14 capabilities unlocked)

### Next Steps

- Run `/classify` against additional peers to test blind discovery (Phase B) — both candidates in iteration #1 were already known
- Test whether the 5 boutique-craftsman-community attributes find NEW peers the agent didn't already know
- Catalog gap: create `media-event-hybrid.yaml` business model catalog (identified from Fretboard Summit)
- Consider adding `exhibitor_model: open | curated` to classification.yaml schema
- Future issue: cross-baseline comparative analysis queries once more peer baselines exist
