# Issue #3: Scope: bring axpona-pr to ridgeline-demo feature parity via research-pr pipeline

> **Issue:** [axpona-pr#3](https://github.com/timjmitchell/axpona-pr/issues/3)
> **Status:** In Progress

## 2026-04-07
<!-- @appended by /issue on 2026-04-07T00:00:00Z -->

### Context

axpona-pr has rich hand-built domain artifacts (bronze data, schema, DDD model, business synthesis) but lacks the canonical pipeline-derived artifacts that ridgeline-demo has. This issue covers running the standardized research-pr pipeline commands to produce all missing artifacts across 4 phases: Pipeline Alignment, Architecture Derivation, Process & Scale, and Infrastructure & Presentation.

Key constraint: research-pr owns the pipeline commands — axpona-pr consumes them.

### Work Done

**Pre-pipeline:** 96 hand-built artifacts (6.5MB) preserved in `pre-pipeline/`

**Phase 1 — Pipeline Alignment:**
- `/classify` → classification.yaml (events/trade_shows/audio, <$5M from OM)
- `/predict` → reference-model.yaml (57 entities, Work-dominant system mix)
- `/reference-commit` → engagement.yaml (3P/1P boundary) + context.md (confirmed financials)
- `/synthesize` → business-model.yaml (investment thesis, Sponsorship promoted to CORE)

**Phase 2 — Architecture Derivation:**
- `/derive` → STRATEGIC_DDD.md (8 contexts, 15 commands, 12 events, 2 sagas), UBIQUITOUS_LANGUAGE.md, system-inventory.yaml, system-classification.yaml, value-stream-map.yaml (3 streams), information-map.yaml, capability-vs-crossmap.yaml
- `/derive-schema` → Existing 707-line schema preserved (symlinked to pipeline path)
- `/derive-registry` → registry.yaml (17 patterns, 72 capabilities, 0 gaps)
- `/derive-analytics` → 7 analytics patterns (4 CORE + 2 SUPPORTING + 1 GENERIC)
- `/derive-manifests` → bronze (9 extractions), silver (7 transforms), gold (6 fact tables, 16 metrics), governance (8 DQ rules)
- Catalog enrichment from research-pr: salesforce-crm.yaml (CRM primitives), netsuite-erp.yaml (AR primitives), event-management.yaml (trade pass growth, lead-to-conversion)
- 7 domain pattern files + 7 analytics pattern files created in mirror/domain/patterns/

**Phase 3 — Process & Scale:**
- `/process-analysis` → 19 processes, 38 capabilities across 6 process catalogs
- `/scale-project` → Reframed from SaaS-per-context to **agentic explicit-enterprise**. 6 K8s manifests. 25 Clean, 7 Concerning (knowledge extraction), 0 Blocking.

**Phase 4 — Infrastructure & Presentation:**
- `/derive-topology` → 2 repos (axpona-domain + axpona-data), 6 vendor lifecycle entries
- Docker Compose generated (postgres, qdrant, agent-runtime, api, pipeline)
- `/coherence-analysis` → ACTIVE-INCOMPLETE (3 structural gaps, 2 semantic drifts, 0 blocking)

**Key findings:**
- Revenue is $2.1M (not $5M-$20M), 3 direct staff, 36% EBITDA margin, $715K revenue/employee
- MatchmakingAppointment dropped (not observable)
- Reconcile-not-rederive strategy preserved hand-built detail throughout
- Agentic reframe: all 38 capabilities are agent-expressible (25 on day one, 7 need knowledge extraction)
- The 5 reasoning-level capabilities (rebooking, floor plan, space assignment, edition planning, on-site ops) are the highest-value knowledge extraction targets

### Next Steps

- Resolve Issue #1 (close as superseded by #3)
- Address 3 coherence gaps: add missing gold metrics, FloorPlan table (when needed), ExhibitorProfile table (when needed)
- Begin knowledge extraction for 7 Concerning capabilities (rebooking first — highest revenue impact)
- Build agent runtime prototype against PostgreSQL schema + Qdrant corpus
- Load pre-pipeline bronze data into PostgreSQL and corpus
