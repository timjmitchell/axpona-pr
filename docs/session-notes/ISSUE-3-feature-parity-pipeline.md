# Issue #3: Scope: bring axpona-pr to ridgeline-demo feature parity via research-pr pipeline

> **Issue:** [axpona-pr#3](https://github.com/timjmitchell/axpona-pr/issues/3)
> **Status:** In Progress

## 2026-04-07
<!-- @appended by /issue on 2026-04-07T00:00:00Z -->

### Context

axpona-pr has rich hand-built domain artifacts (bronze data, schema, DDD model, business synthesis) but lacks the canonical pipeline-derived artifacts that ridgeline-demo has. This issue covers running the standardized research-pr pipeline commands to produce all missing artifacts across 4 phases: Pipeline Alignment, Architecture Derivation, Process & Scale, and Infrastructure & Presentation.

Key constraint: research-pr owns the pipeline commands — axpona-pr consumes them.

### Work Done

- Issue reviewed and session note created
- 

### Next Steps

- Decide on reconciliation strategy for hand-built artifacts (DDD, schema, business model) vs. re-derive
- Check if trade show / event marketplace archetype exists in research-pr catalogs
- Begin Phase 1: `/classify` → `/predict` → `/reference-commit` → `/synthesize`
- Resolve relationship with Issue #1 (subset — close as superseded or keep as child)
