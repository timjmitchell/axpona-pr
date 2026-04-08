// ============================================================
// AXPONA Domain Model — Neo4j Exploration Queries
// ============================================================
// Open http://localhost:7476/browser/ and paste into the query bar.
// All queries filter on engagement='axpona-pr'.
//
// IMPORTANT: Return nodes (not properties) for graph visualization.
// Returning `bc.id AS context` gives a table; returning `bc` gives a graph.

// -----------------------------------------------------------
// 1. OVERVIEW: All bounded contexts
// -----------------------------------------------------------
MATCH (bc:BoundedContext {engagement: 'axpona-pr'})
RETURN bc;

// -----------------------------------------------------------
// 2. CONTEXT MAP: How bounded contexts interact
// -----------------------------------------------------------
// Customer-Supplier, Shared Kernel, ACL, Published Language, Conformist
MATCH (a:BoundedContext {engagement: 'axpona-pr'})-[r]->(b:BoundedContext)
RETURN a, r, b;

// -----------------------------------------------------------
// 3. DRILL DOWN: Context → Patterns → Capabilities
// -----------------------------------------------------------
// Change 'exhibitor' to any context id
MATCH (bc:BoundedContext {id: 'exhibitor', engagement: 'axpona-pr'})<-[:IMPLEMENTS]-(p:Pattern)-[:DELIVERS]->(c:Capability)
RETURN bc, p, c;

// -----------------------------------------------------------
// 4. CORE CONTEXTS: Full hierarchy for competitive advantage areas
// -----------------------------------------------------------
MATCH (bc:BoundedContext {engagement: 'axpona-pr', ddd_type: 'CORE'})
OPTIONAL MATCH (bc)<-[:IMPLEMENTS]-(p:Pattern)
OPTIONAL MATCH (bc)<-[:SERVES]-(s:System)
RETURN bc, p, s;

// -----------------------------------------------------------
// 5. SYSTEMS: What systems serve each context?
// -----------------------------------------------------------
MATCH (s:System {engagement: 'axpona-pr'})-[r:SERVES]->(bc:BoundedContext)
RETURN s, r, bc;

// -----------------------------------------------------------
// 6. ANALYTICS → DOMAIN: Measurement dependency chain
// -----------------------------------------------------------
// Which analytics patterns measure which domain patterns?
MATCH (a:Pattern {type: 'analytics', engagement: 'axpona-pr'})-[r:MEASURES]->(d:Pattern {type: 'domain'})
RETURN a, r, d;

// -----------------------------------------------------------
// 7. GOALS: What does each goal target and measure?
// -----------------------------------------------------------
MATCH (g:Goal {engagement: 'axpona-pr'})-[r]->(target)
RETURN g, r, target;

// -----------------------------------------------------------
// 8. PROCESS CAPABILITIES: Complex coordination points
// -----------------------------------------------------------
// Process capabilities have coordination metadata (saga, service, choreography)
MATCH (p:Pattern {engagement: 'axpona-pr'})-[:DELIVERS]->(c:Capability {capability_type: 'process'})
RETURN p, c;

// -----------------------------------------------------------
// 9. WEIGHT-RANKED CONTEXTS: Importance-weighted overview
// -----------------------------------------------------------
// Use with Neo4j Bloom rule-based styling: set node size = n.size
MATCH (bc:BoundedContext {engagement: 'axpona-pr'})
RETURN bc.display_name AS context, bc.ddd_type AS type,
       bc.weight AS weight, bc.size AS size
ORDER BY bc.weight DESC;

// -----------------------------------------------------------
// 10. SINGLE CONTEXT DEEP DIVE: Everything connected to one context
// -----------------------------------------------------------
// Change 'exhibitor' to any context id
MATCH (bc:BoundedContext {id: 'exhibitor', engagement: 'axpona-pr'})
OPTIONAL MATCH (bc)<-[r1:IMPLEMENTS]-(p:Pattern)
OPTIONAL MATCH (p)-[r2:DELIVERS]->(c:Capability)
OPTIONAL MATCH (bc)<-[r3:SERVES]-(s:System)
RETURN bc, p, c, s, r1, r2, r3;

// -----------------------------------------------------------
// 11. FULL GRAPH (limit for readability)
// -----------------------------------------------------------
MATCH (n {engagement: 'axpona-pr'})-[r]->(m)
RETURN n, r, m LIMIT 100;
