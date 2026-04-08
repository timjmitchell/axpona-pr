# Projection — AXPONA

K8s scale projection manifests and analysis for the agentic explicit-enterprise stack.

## Architecture

```
API (registration, portals, dashboards)
    ↓
Agent Runtime (38 capabilities, human-in-the-loop for reasoning)
    ↓
PostgreSQL (domain model, 26 tables) + Qdrant (corpus, institutional knowledge)
    ↓
Pipeline Jobs (bronze → silver → gold, weekly + post-show)
```

## Manifests

| File | Resources | Purpose |
|------|-----------|---------|
| [namespace.yaml](namespace.yaml) | 2 Namespaces | Isolation + PII separation |
| [postgres.yaml](postgres.yaml) | StatefulSet + Service | Domain model (all 8 contexts) |
| [corpus.yaml](corpus.yaml) | StatefulSet + Service | Qdrant vector DB (institutional knowledge) |
| [agent-runtime.yaml](agent-runtime.yaml) | Deployment + HPA + Service | Agent execution (38 capabilities) |
| [pipeline-jobs.yaml](pipeline-jobs.yaml) | 3 CronJobs + 1 Job | Data pipeline (bronze/silver/gold) |
| [api.yaml](api.yaml) | Deployment + HPA + Service | Public-facing APIs and portals |

## Analysis History

| Date | Method | Verdict | Analysis |
|------|--------|---------|----------|
| 2026-04-07 | K8s agentic projection | Concerning (25 Clean, 7 Concerning, 0 Blocking) | [analysis/2026-04-07-agentic-projection.md](analysis/2026-04-07-agentic-projection.md) |
