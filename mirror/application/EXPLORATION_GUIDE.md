# AXPONA — Data Exploration Guide

> Two tools for exploring the AXPONA domain model and trade show analytics.
> No SQL or programming knowledge required.

## Evidence Dashboards — Trade Show Metrics

**URL:** `http://localhost:3000`

Evidence renders 16 gold-layer metrics as interactive dashboards. Charts update when the underlying data changes — no manual refresh needed.

### Dashboard Index

| Dashboard | What It Answers | Key Metric |
| --------- | --------------- | ---------- |
| [Home](http://localhost:3000/) | How is the show performing overall? | Revenue, margin, exhibitor count |
| [Exhibitor Retention](http://localhost:3000/exhibitor-retention) | Are exhibitors coming back? | **Rebooking rate (30-day)** — THE leading indicator |
| [Sponsorship Yield](http://localhost:3000/sponsorship-yield) | Are we maximizing sponsor value? | Fill rate by category, CPM, renewal rate |
| [Space Utilization](http://localhost:3000/space-utilization) | Are we pricing space correctly? | Revenue per sqft, listening room premium |
| [Edition Performance](http://localhost:3000/edition-performance) | Is the show growing profitably? | EBITDA margin, revenue growth YoY |
| [Attendee Demand](http://localhost:3000/attendee-demand) | Is the audience growing? | Attendee count, ticket ARPU, returning % |
| [Lead Effectiveness](http://localhost:3000/lead-effectiveness) | Are exhibitors getting value? | Leads per exhibitor, conversion funnel |
| [Financial Health](http://localhost:3000/financial-health) | Where does the money flow? | Revenue by category, transaction status |

### Reading the Dashboards

- **BigValue cards** at the top of each page show the headline number for the most recent edition
- **Line charts** show edition-over-edition trends — the x-axis is always edition year
- **Bar charts** break down a metric by category (space type, ticket type, sponsor tier, etc.)
- **Data tables** at the bottom of some pages show the raw numbers behind the charts

### What to Look For

**Exhibitor Retention** — Start here. The rebooking rate drives everything downstream.

- Rebooking rate above 75% = healthy. Below 70% = investigate why exhibitors aren't returning.
- The "Exhibitor Mix" stacked bar shows new vs. returning — a healthy show has 70-80% returning base with steady new growth.
- Services attach rate shows whether exhibitors are buying add-ons (lead retrieval, AV, drayage). Rising attach rate = exhibitors see enough value to invest beyond the booth.

**Space Utilization** — The venue has 213 listening rooms at capacity ceiling.

- Fill rate above 90% = sold out. Growth comes from pricing, not adding rooms.
- Listening room premium shows how much more listening rooms earn per sqft vs. expo space. A premium above 1.5x is expected for AXPONA.
- Revenue per sqft trending up = healthy pricing power.

**Edition Performance** — The P&L view.

- Revenue breakdown shows which sources are growing (exhibitor, sponsorship, ticket, services).
- Margin trending up = the show scales better than its costs.
- If sponsorship revenue is flat while exhibitor revenue grows, there's an untapped monetization opportunity.

**Sponsorship Yield** — Sell-through and renewal.

- 100% sell-through in a category means you can raise prices or add inventory.
- Renewal rate above 80% = sponsors see ROI. Below 60% = the deliverables need work.
- CPM equivalent lets you benchmark against digital advertising rates.

---

## Neo4j Browser — Domain Model Graph

**URL:** `http://localhost:7476`

Neo4j visualizes the AXPONA domain model as an interactive graph. No authentication required — open the URL and start querying.

### What's in the Graph

| Node Type | Count | What It Represents |
| --------- | ----- | ------------------ |
| BoundedContext | 8 | Business areas (Exhibitor, Sponsorship, Exhibition Space, Event, Attendee, Interaction, Agreement, Finance) |
| Pattern | 17 | Domain + analytics patterns (exhibitor-lifecycle, sponsorship-yield, etc.) |
| Capability | 72 | What the business can do (track rebooking, calculate margin, score vendors) |
| System | 7 | Software systems serving each context (CRM, ticketing, floor plan tool) |
| Goal | 3 | Business goals with target metrics |
| Stage | 5 | Value stream stages (Plan → Sell → Market → Execute → Retain) |
| DomainEvent | 6 | Key business events (ExhibitorApplied, EventConcluded, etc.) |
| Metric | 6 | Gold-layer metrics produced by events |
| Prescription | 7 | Agent recommendations from gap analysis |
| CorpusSource | 5 | Knowledge sources (forums, show guides, exhibitor lists) |

### Getting Started

Paste any of these into the query bar at the top of Neo4j Browser.

**See the whole model at a glance:**

```cypher
MATCH (n) RETURN n LIMIT 200
```

**The architecture — how business areas relate:**

```cypher
MATCH (a:BoundedContext)-[r]->(b:BoundedContext) RETURN a, r, b
```

**What matters most — CORE contexts with their patterns and systems:**

```cypher
MATCH (c:BoundedContext {ddd_type: 'CORE'})-[:IMPLEMENTS]->(p:Pattern)-[:DELIVERS]->(cap:Capability)
RETURN c, p, cap
```

**The annual cycle — how work flows through the year:**

```cypher
MATCH (a:Stage)-[:FLOWS_TO]->(b:Stage) RETURN a, b
```

**The rebooking story — the most important business flow:**

```cypher
MATCH (e:DomainEvent {id: 'EventConcluded'})-[r1]->(m:Metric)
RETURN e, r1, m
UNION
MATCH (rx:Prescription {id: 'rx-rebooking-advisor'})-[r2]->(cap:Capability)
RETURN rx, r2, cap
```

### Exploring a Specific Business Area

Replace `'exhibitor'` with any context ID to explore that area:

```cypher
MATCH (bc:BoundedContext {id: 'exhibitor'})-[r]-(n)
RETURN bc, r, n
```

Context IDs: `exhibitor`, `sponsorship`, `exhibition-space`, `event`, `attendee`, `interaction`, `agreement`, `finance`

### Graph Navigation Tips

- **Click a node** to see its properties (name, weight, domain typing, etc.)
- **Double-click a node** to expand its relationships
- **Drag nodes** to rearrange the layout
- **Scroll** to zoom in/out
- **Pin nodes** (click the lock icon) to anchor them while rearranging others
- Use the **Table** view (tab at bottom) to see query results as rows instead of a graph

### Key Relationships to Trace

| Relationship | What It Shows |
| ------------ | ------------- |
| `IMPLEMENTS` | Context → Pattern (what business patterns each area implements) |
| `DELIVERS` | Pattern → Capability (what each pattern enables) |
| `SERVES` | System → Context (which software serves which business area) |
| `FLOWS_TO` | Stage → Stage (annual value stream cycle) |
| `PRODUCES` | DomainEvent → Metric (which events generate which metrics) |
| `UNLOCKS` | Prescription → Capability (what agent recommendations would enable) |
| `INFORMS` | CorpusSource → Context (what knowledge feeds each area) |
| `MEASURES` | Goal → Pattern (what patterns each goal tracks) |

### Pre-Built Query Files

For deeper exploration, two query files with 22 pre-built queries are available:

- **`scripts/cypher/explore-axpona.cypher`** — Domain model exploration (11 queries)
- **`scripts/cypher/graph-traversal.cypher`** — Relationship traversal (11 queries)

Open these files, copy any query block, and paste into Neo4j Browser.

---

## How the Two Tools Connect

Evidence dashboards and Neo4j graph show the same domain from different angles:

| Question | Use |
| -------- | --- |
| "What's the rebooking rate trend?" | Evidence → Exhibitor Retention dashboard |
| "Why does rebooking matter to the business model?" | Neo4j → Trace from exhibitor context through patterns to goals |
| "How much revenue per sqft?" | Evidence → Space Utilization dashboard |
| "Which systems manage space allocation?" | Neo4j → `MATCH (s:System)-[:SERVES]->(c:BoundedContext {id: 'exhibition-space'}) RETURN s, c` |
| "What are the sponsorship fill rates?" | Evidence → Sponsorship Yield dashboard |
| "What agent could improve sponsorship yield?" | Neo4j → `MATCH (rx:Prescription)-[:UNLOCKS]->(cap:Capability)<-[:DELIVERS]-(p:Pattern {id: 'sponsorship-yield'}) RETURN rx, cap, p` |

Evidence answers **"what are the numbers?"** — Neo4j answers **"why does this matter and what connects to what?"**
