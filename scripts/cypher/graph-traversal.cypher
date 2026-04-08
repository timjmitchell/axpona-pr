// ============================================================
// AXPONA — Graph Traversal Queries (graph.yaml edges)
// ============================================================
// These explore the cross-entity relationships from graph.yaml:
// context map, value stream flow, event→metric, prescription→capability,
// and corpus→context edges.

// -----------------------------------------------------------
// 1. VALUE STREAM: Annual edition cycle (Plan → Sell → Market → Execute → Retain)
// -----------------------------------------------------------
MATCH (a:Stage)-[r:FLOWS_TO]->(b:Stage)
RETURN a, r, b;

// -----------------------------------------------------------
// 2. DOMAIN EVENTS → METRICS: What events produce what measurements?
// -----------------------------------------------------------
MATCH (e:DomainEvent)-[r:PRODUCES]->(m:Metric)
RETURN e, r, m;

// -----------------------------------------------------------
// 3. AGENT PRESCRIPTIONS: What capabilities do they unlock?
// -----------------------------------------------------------
MATCH (rx:Prescription)-[r:UNLOCKS]->(cap:Capability)
RETURN rx, r, cap;

// -----------------------------------------------------------
// 4. CORPUS → CONTEXT: What knowledge feeds each bounded context?
// -----------------------------------------------------------
MATCH (src:CorpusSource)-[r:INFORMS]->(ctx:BoundedContext)
RETURN src, r, ctx;

// -----------------------------------------------------------
// 5. REBOOKING CHAIN: Trace from event conclusion through rebooking
// -----------------------------------------------------------
// The most important business flow: EventConcluded → rebooking metrics
MATCH (e:DomainEvent {id: 'EventConcluded'})-[r1]->(m:Metric)
RETURN e, r1, m
UNION
MATCH (rx:Prescription {id: 'rx-rebooking-advisor'})-[r2]->(cap:Capability)
RETURN rx, r2, cap;

// -----------------------------------------------------------
// 6. EXHIBITOR INTELLIGENCE: All signals feeding exhibitor context
// -----------------------------------------------------------
MATCH (src)-[r:INFORMS]->(ctx:BoundedContext {id: 'exhibitor'})
RETURN src, r, ctx
UNION
MATCH (ctx:BoundedContext {id: 'exhibitor'})<-[r]-(other:BoundedContext)
RETURN other, r, ctx;

// -----------------------------------------------------------
// 7. SPONSORSHIP YIELD CHAIN: Pattern → analytics → goal
// -----------------------------------------------------------
MATCH (g:Goal {id: 'maximize-sponsorship-yield'})-[r1:MEASURES]->(d:Pattern)
OPTIONAL MATCH (a:Pattern {type: 'analytics'})-[r2:MEASURES]->(d)
RETURN g, d, a, r1, r2;

// -----------------------------------------------------------
// 8. SCALE PROJECTION: Prescriptions → capabilities → patterns → contexts
// -----------------------------------------------------------
// Full chain from agent prescriptions back to business context
MATCH (rx:Prescription)-[:UNLOCKS]->(cap:Capability)<-[:DELIVERS]-(p:Pattern)<-[:IMPLEMENTS]-(bc:BoundedContext)
RETURN rx, cap, p, bc;

// -----------------------------------------------------------
// 9. KNOWLEDGE EXTRACTION MAP: What needs extracting for each prescription
// -----------------------------------------------------------
// Shows which corpus sources and contexts each prescription connects to
MATCH (rx:Prescription)-[r1:UNLOCKS]->(cap:Capability)
OPTIONAL MATCH (cap)<-[:DELIVERS]-(p:Pattern)<-[:IMPLEMENTS]-(bc:BoundedContext)
OPTIONAL MATCH (src:CorpusSource)-[:INFORMS]->(bc)
RETURN rx, cap, p, bc, src;

// -----------------------------------------------------------
// 10. REVENUE CHAIN: Space → exhibitor → finance
// -----------------------------------------------------------
// Follow the money: how space revenue flows through the domain model
MATCH (space:BoundedContext {id: 'exhibition-space'})-[r1]-(exhibitor:BoundedContext {id: 'exhibitor'})
OPTIONAL MATCH (exhibitor)-[r2]-(finance:BoundedContext {id: 'finance'})
OPTIONAL MATCH (e:DomainEvent)-[r3:PRODUCES]->(m:Metric)
WHERE e.id IN ['ExhibitorContracted', 'ExhibitorRebooked']
RETURN space, exhibitor, finance, e, m, r1, r2, r3;

// -----------------------------------------------------------
// 11. ALL GRAPH EDGES: Visual overview of domain relationships
// -----------------------------------------------------------
MATCH (a)-[r]->(b)
WHERE NOT a:Pattern AND NOT b:Capability
  AND NOT a:Capability AND NOT b:Pattern
RETURN a, r, b;
