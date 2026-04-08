# Issue #3: Scope: bring axpona-pr to ridgeline-demo feature parity via research-pr pipeline

> **Issue:** [axpona-pr#3](https://github.com/timjmitchell/axpona-pr/issues/3)
> **Status:** In Progress

## 2026-04-07
<!-- @appended by /issue on 2026-04-07T00:00:00Z -->

### Context

axpona-pr has rich hand-built domain artifacts (bronze data, schema, DDD model, business synthesis) but lacks the canonical pipeline-derived artifacts that ridgeline-demo has. This issue covers running the standardized research-pr pipeline commands to produce all missing artifacts across 4 phases: Pipeline Alignment, Architecture Derivation, Process & Scale, and Infrastructure & Presentation.

Key constraint: research-pr owns the pipeline commands — axpona-pr consumes them.

### Work Done

- Pre-pipeline snapshot: 96 hand-built artifacts (6.5MB) preserved in `pre-pipeline/`
- **Phase 1 complete:** `/classify` → `/predict` → `/reference-commit` → `/synthesize`
  - classification.yaml: events/trade_shows/audio, revenue corrected to <$5M from OM
  - reference-model.yaml: 57 entities, Work-dominant system mix
  - engagement.yaml: 3P/1P boundary declared
  - context.md: 1P intel brief with confirmed financials ($2.1M rev, $780K EBITDA, 3 staff)
  - business-model.yaml: investment thesis, 8 contexts, Sponsorship promoted to CORE
- **Phase 2 (partial):** `/derive` complete
  - STRATEGIC_DDD.md: 8 contexts, 15 commands, 12 domain events, 2 sagas
  - UBIQUITOUS_LANGUAGE.md: reconciled with hand-built UL
  - system-inventory.yaml, system-classification.yaml
  - value-stream-map.yaml: 3 value streams (plan-to-retain, prospect-to-rebook, sponsor-to-renew)
  - information-map.yaml: 8 primary + 5 secondary concepts, 12 value objects
  - capability-vs-crossmap.yaml: 3 cross-maps with saga derivations
- Key finding: OM confirms $2.1M revenue (not $5M-$20M), 3 direct staff, 36% EBITDA margin
- MatchmakingAppointment dropped (gap analysis: not observable)
- Reconcile-not-rederive strategy applied throughout — hand-built detail preserved

### Next Steps

- Phase 2 remaining: `/derive-schema`, `/derive-registry`, `/derive-analytics`, `/derive-manifests`
- Phase 3: `/process-analysis`, `/scale-project`
- Phase 4: `/derive-topology`, corpus infrastructure, Docker Compose
- Resolve Issue #1 relationship (close as superseded by #3)
