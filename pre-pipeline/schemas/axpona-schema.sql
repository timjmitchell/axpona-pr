-- =============================================================================
-- AXPONA Domain Model — SQL Schema
-- =============================================================================
--
-- Authoritative DDL for all 8 bounded contexts defined in STRATEGIC_DDD.md.
-- Aligned to UBIQUITOUS_LANGUAGE.md domain terminology.
-- Dimensional models derived from data-architecture-spec.md Section 2.
--
-- Target: SQLite (demo) with PostgreSQL upgrade path documented.
-- Reference: schemas/SCHEMA_REFERENCE.md
--
-- Version: 1.0.0
-- Created: 2026-03-16
-- Issue: research-pr#37
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Schema Version
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS schema_version (
    version     TEXT PRIMARY KEY,
    applied_at  TEXT NOT NULL DEFAULT (datetime('now')),
    description TEXT
);

INSERT OR IGNORE INTO schema_version (version, description) VALUES
    ('1.0.0', 'Initial AXPONA domain model: 8 bounded contexts, dimensions + facts + entities');


-- =============================================================================
-- SHARED DIMENSION: dim_edition
-- =============================================================================
-- The conformed dimension. Join key across all contexts.
-- Trade show equivalent of a SaaS monthly cohort.
-- =============================================================================

CREATE TABLE IF NOT EXISTS dim_edition (
    edition_id      TEXT PRIMARY KEY,
    edition_year    INTEGER NOT NULL,
    edition_number  INTEGER NOT NULL,         -- 17th edition = 2026
    venue_name      TEXT,
    venue_city      TEXT DEFAULT 'Chicago',
    venue_state     TEXT DEFAULT 'IL',
    start_date      TEXT,                     -- ISO 8601
    end_date        TEXT,
    days            INTEGER,
    status          TEXT CHECK (status IN ('planned', 'announced', 'scheduled', 'completed', 'cancelled')),
    metadata        JSON NOT NULL DEFAULT '{}',
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);


-- =============================================================================
-- EXHIBITOR CONTEXT (CORE) — Marketplace Supply Side
-- =============================================================================
-- Aggregate root: Exhibitor
-- Owns: lifecycle, profile, rebooking, priority points, service orders
-- Source: Exhibitor CRM, sales team
-- Four Data System Type: Work
-- =============================================================================

CREATE TABLE IF NOT EXISTS dim_exhibitor (
    exhibitor_id        TEXT PRIMARY KEY,
    company_name        TEXT NOT NULL,
    category            TEXT CHECK (category IN (
        'audio', 'accessories', 'media', 'cables', 'furniture',
        'vinyl', 'headphones', 'digital', 'analog', 'speakers',
        'amplifiers', 'turntables', 'streaming', 'other'
    )),
    exhibitor_type      TEXT CHECK (exhibitor_type IN (
        'brand', 'dealer', 'distributor', 'manufacturer', 'publisher', 'other'
    )),
    first_edition       TEXT REFERENCES dim_edition(edition_id),
    editions_attended   INTEGER DEFAULT 0,
    current_tier        TEXT CHECK (current_tier IN ('standard', 'preferred', 'premium', 'founding')),
    website             TEXT,
    contact_name        TEXT,
    contact_email       TEXT,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS fct_exhibitor_edition (
    exhibitor_id            TEXT NOT NULL REFERENCES dim_exhibitor(exhibitor_id),
    edition_id              TEXT NOT NULL REFERENCES dim_edition(edition_id),
    space_type              TEXT CHECK (space_type IN (
        'listening_room', 'expo', 'ear_gear', 'car_audio', 'alti'
    )),
    space_sqft              REAL,
    contract_value          REAL,
    services_revenue        REAL,
    total_revenue           REAL,               -- computed: contract_value + services_revenue
    is_returning            INTEGER DEFAULT 0,  -- boolean
    priority_points         INTEGER DEFAULT 0,
    days_to_close           INTEGER,            -- prospect → signed
    rebooked_within_30d     INTEGER DEFAULT 0,  -- boolean
    contract_signed_date    TEXT,
    lifecycle_state         TEXT CHECK (lifecycle_state IN (
        'prospected', 'applied', 'contracted', 'confirmed', 'attended', 'rebooking'
    )),
    metadata                JSON NOT NULL DEFAULT '{}',
    created_at              TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at              TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (exhibitor_id, edition_id)
);

CREATE TABLE IF NOT EXISTS exhibitor_service_order (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    exhibitor_id        TEXT NOT NULL REFERENCES dim_exhibitor(exhibitor_id),
    edition_id          TEXT NOT NULL REFERENCES dim_edition(edition_id),
    service_type        TEXT NOT NULL CHECK (service_type IN (
        'lead_retrieval', 'drayage', 'electrical', 'av', 'furniture',
        'booth_construction', 'wifi', 'cleaning', 'other'
    )),
    quantity            INTEGER DEFAULT 1,
    unit_price          REAL,
    total_price         REAL,
    status              TEXT CHECK (status IN ('requested', 'confirmed', 'fulfilled', 'invoiced')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS exhibitor_rebooking (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    exhibitor_id        TEXT NOT NULL REFERENCES dim_exhibitor(exhibitor_id),
    from_edition_id     TEXT NOT NULL REFERENCES dim_edition(edition_id),
    to_edition_id       TEXT NOT NULL REFERENCES dim_edition(edition_id),
    status              TEXT CHECK (status IN ('eligible', 'offered', 'accepted', 'declined', 'lapsed')),
    offered_date        TEXT,
    response_date       TEXT,
    days_to_respond     INTEGER,
    priority_points     INTEGER DEFAULT 0,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);


-- =============================================================================
-- SPONSORSHIP CONTEXT (CORE) — Advertising/Media Lens
-- =============================================================================
-- Aggregate root: Sponsorship
-- Owns: lifecycle, deliverables, packages
-- Source: Sponsorship tracking
-- Four Data System Type: Work
-- =============================================================================

CREATE TABLE IF NOT EXISTS dim_sponsor (
    sponsor_id          TEXT PRIMARY KEY,
    company_name        TEXT NOT NULL,
    sponsor_type        TEXT CHECK (sponsor_type IN (
        'exhibitor_sponsor', 'media_partner', 'industry_partner', 'brand_sponsor', 'other'
    )),
    first_edition       TEXT REFERENCES dim_edition(edition_id),
    editions_sponsored  INTEGER DEFAULT 0,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS fct_sponsorship_delivery (
    sponsorship_id          TEXT NOT NULL,
    sponsor_id              TEXT NOT NULL REFERENCES dim_sponsor(sponsor_id),
    edition_id              TEXT NOT NULL REFERENCES dim_edition(edition_id),
    package_tier            TEXT CHECK (package_tier IN (
        'title', 'platinum', 'gold', 'silver', 'bronze', 'custom', 'individual'
    )),
    deliverable_type        TEXT NOT NULL CHECK (deliverable_type IN (
        'signage', 'digital_ad', 'branded_experience', 'print', 'email',
        'social_media', 'website_placement', 'badge_insert', 'bag_insert',
        'lanyard', 'charging_station', 'wifi', 'other'
    )),
    deliverable_value       REAL,
    estimated_impressions   INTEGER,
    exclusivity_flag        INTEGER DEFAULT 0,  -- boolean
    delivery_status         TEXT CHECK (delivery_status IN (
        'contracted', 'in_production', 'delivered', 'verified'
    )),
    is_renewal              INTEGER DEFAULT 0,  -- boolean
    previous_tier           TEXT,                -- for upgrade tracking
    metadata                JSON NOT NULL DEFAULT '{}',
    created_at              TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at              TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (sponsorship_id, deliverable_type)
);

CREATE TABLE IF NOT EXISTS sponsorship_package (
    package_id          TEXT PRIMARY KEY,
    name                TEXT NOT NULL,
    tier                TEXT CHECK (tier IN (
        'title', 'platinum', 'gold', 'silver', 'bronze', 'custom', 'individual'
    )),
    price               REAL,
    category            TEXT CHECK (category IN (
        'branding', 'digital', 'experiential', 'print', 'hospitality', 'other'
    )),
    deliverables        JSON NOT NULL DEFAULT '[]',  -- array of deliverable types
    exclusivity_flag    INTEGER DEFAULT 0,
    edition_id          TEXT REFERENCES dim_edition(edition_id),
    availability_status TEXT CHECK (availability_status IN ('available', 'sold', 'reserved', 'expired')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);


-- =============================================================================
-- EXHIBITION SPACE CONTEXT (CORE)
-- =============================================================================
-- Aggregate root: ExhibitionSpace
-- Owns: space inventory, assignments, dimensions
-- Source: Floor plan system
-- Four Data System Type: Work
-- =============================================================================

CREATE TABLE IF NOT EXISTS dim_space (
    space_id            TEXT PRIMARY KEY,
    space_type          TEXT NOT NULL CHECK (space_type IN (
        'listening_room', 'expo', 'ear_gear', 'car_audio', 'alti'
    )),
    floor_location      TEXT,               -- building/floor/zone
    width_ft            REAL,
    depth_ft            REAL,
    sqft                REAL,
    corner_flag         INTEGER DEFAULT 0,  -- boolean
    electrical_access   INTEGER DEFAULT 1,  -- boolean
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS fct_space_assignment (
    space_id            TEXT NOT NULL REFERENCES dim_space(space_id),
    edition_id          TEXT NOT NULL REFERENCES dim_edition(edition_id),
    exhibitor_id        TEXT REFERENCES dim_exhibitor(exhibitor_id),
    assignment_status   TEXT CHECK (assignment_status IN (
        'planned', 'available', 'reserved', 'assigned', 'occupied', 'vacated'
    )),
    assignment_date     TEXT,
    revenue_per_sqft    REAL,               -- computed
    list_price          REAL,
    actual_price        REAL,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at          TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (space_id, edition_id)
);


-- =============================================================================
-- EVENT CONTEXT (CORE)
-- =============================================================================
-- Aggregate root: Event
-- Owns: edition lifecycle, sessions, speakers, floor plan versions
-- Source: Event management (internal)
-- Four Data System Type: Work
-- =============================================================================

CREATE TABLE IF NOT EXISTS event (
    event_id            TEXT PRIMARY KEY,
    name                TEXT NOT NULL DEFAULT 'AXPONA',
    description         TEXT,
    website             TEXT,
    status              TEXT CHECK (status IN ('planning', 'open', 'live', 'post_show', 'archived')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS event_session (
    session_id          TEXT PRIMARY KEY,
    edition_id          TEXT NOT NULL REFERENCES dim_edition(edition_id),
    title               TEXT NOT NULL,
    description         TEXT,
    session_type        TEXT CHECK (session_type IN (
        'seminar', 'demo', 'panel', 'workshop', 'keynote', 'meetup', 'other'
    )),
    room                TEXT,
    start_time          TEXT,
    end_time            TEXT,
    status              TEXT CHECK (status IN ('proposed', 'confirmed', 'scheduled', 'live', 'completed')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS event_speaker (
    speaker_id          TEXT PRIMARY KEY,
    name                TEXT NOT NULL,
    company             TEXT,
    title               TEXT,               -- job title
    bio                 TEXT,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS session_speaker (
    session_id          TEXT NOT NULL REFERENCES event_session(session_id),
    speaker_id          TEXT NOT NULL REFERENCES event_speaker(speaker_id),
    role                TEXT CHECK (role IN ('presenter', 'panelist', 'moderator', 'host')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (session_id, speaker_id)
);

CREATE TABLE IF NOT EXISTS fct_edition_pnl (
    edition_id              TEXT PRIMARY KEY REFERENCES dim_edition(edition_id),
    venue_cost              REAL,
    marketing_spend         REAL,
    operations_cost         REAL,
    exhibitor_revenue       REAL,       -- aggregate from fct_exhibitor_edition
    sponsorship_revenue     REAL,       -- aggregate from fct_sponsorship_delivery
    ticket_revenue          REAL,       -- aggregate from fct_registration
    services_revenue        REAL,       -- aggregate from exhibitor_service_order
    total_revenue           REAL,       -- computed
    total_cost              REAL,       -- computed
    margin                  REAL,       -- computed: (revenue - cost) / revenue
    attendee_count          INTEGER,
    exhibitor_count         INTEGER,
    sponsor_count           INTEGER,
    metadata                JSON NOT NULL DEFAULT '{}',
    created_at              TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at              TEXT NOT NULL DEFAULT (datetime('now'))
);


-- =============================================================================
-- ATTENDEE CONTEXT (SUPPORTING) — Marketplace Demand Side
-- =============================================================================
-- Aggregate root: Attendee
-- Owns: registration, badge, ticket
-- Source: Unity Event Solutions (external vendor)
-- Four Data System Type: Application
-- =============================================================================

CREATE TABLE IF NOT EXISTS dim_attendee (
    attendee_id         TEXT PRIMARY KEY,
    first_name          TEXT,
    last_name           TEXT,
    email               TEXT,
    zip_code            TEXT,
    first_edition       TEXT REFERENCES dim_edition(edition_id),
    editions_attended   INTEGER DEFAULT 0,
    attendee_type       TEXT CHECK (attendee_type IN ('consumer', 'trade', 'press', 'vip', 'exhibitor', 'other')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS fct_registration (
    attendee_id         TEXT NOT NULL REFERENCES dim_attendee(attendee_id),
    edition_id          TEXT NOT NULL REFERENCES dim_edition(edition_id),
    registration_date   TEXT,
    ticket_type         TEXT CHECK (ticket_type IN (
        'general_admission', 'friday_pass', 'saturday_pass', 'sunday_pass', 'vip', 'trade_pass'
    )),
    ticket_price        REAL,
    acquisition_source  TEXT CHECK (acquisition_source IN (
        'organic', 'email', 'social', 'referral', 'partner', 'press', 'other'
    )),
    checked_in          INTEGER DEFAULT 0,  -- boolean
    days_attended       INTEGER,
    is_returning        INTEGER DEFAULT 0,  -- boolean
    editions_attended_total INTEGER DEFAULT 1,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (attendee_id, edition_id)
);


-- =============================================================================
-- INTERACTION CONTEXT (SUPPORTING) — Lead Capture & Matchmaking
-- =============================================================================
-- Aggregate root: Interaction
-- Owns: lead records, matchmaking appointments, badge scan data
-- Source: Badge scanning vendor, lead retrieval system
-- Four Data System Type: Application
-- =============================================================================

CREATE TABLE IF NOT EXISTS dim_interaction (
    interaction_id      TEXT PRIMARY KEY,
    interaction_type    TEXT CHECK (interaction_type IN (
        'badge_scan', 'matchmaking', 'demo_request', 'booth_visit', 'session_attendance', 'other'
    )),
    description         TEXT,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS fct_lead_capture (
    interaction_id      TEXT NOT NULL,
    exhibitor_id        TEXT NOT NULL REFERENCES dim_exhibitor(exhibitor_id),
    attendee_id         TEXT NOT NULL REFERENCES dim_attendee(attendee_id),
    edition_id          TEXT NOT NULL REFERENCES dim_edition(edition_id),
    scan_timestamp      TEXT,
    interaction_type    TEXT CHECK (interaction_type IN (
        'badge_scan', 'matchmaking', 'demo_request', 'booth_visit', 'other'
    )),
    lead_status         TEXT CHECK (lead_status IN (
        'captured', 'qualified', 'followed_up', 'converted', 'dead'
    )),
    space_id            TEXT REFERENCES dim_space(space_id),
    notes               TEXT,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (interaction_id, exhibitor_id, attendee_id)
);

CREATE TABLE IF NOT EXISTS matchmaking_appointment (
    appointment_id      TEXT PRIMARY KEY,
    exhibitor_id        TEXT NOT NULL REFERENCES dim_exhibitor(exhibitor_id),
    attendee_id         TEXT NOT NULL REFERENCES dim_attendee(attendee_id),
    edition_id          TEXT NOT NULL REFERENCES dim_edition(edition_id),
    scheduled_time      TEXT,
    status              TEXT CHECK (status IN ('requested', 'confirmed', 'completed', 'no_show')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);


-- =============================================================================
-- AGREEMENT CONTEXT (GENERIC)
-- =============================================================================
-- Aggregate root: Agreement
-- Owns: contract terms, lifecycle
-- Source: DocuSign/PandaDoc
-- Four Data System Type: Record
-- =============================================================================

CREATE TABLE IF NOT EXISTS agreement (
    agreement_id        TEXT PRIMARY KEY,
    agreement_type      TEXT CHECK (agreement_type IN (
        'exhibitor_contract', 'sponsorship_contract', 'venue_contract',
        'vendor_contract', 'media_partnership', 'other'
    )),
    party_type          TEXT CHECK (party_type IN ('exhibitor', 'sponsor', 'vendor', 'venue', 'other')),
    party_id            TEXT,               -- FK to dim_exhibitor, dim_sponsor, etc. by party_type
    edition_id          TEXT REFERENCES dim_edition(edition_id),
    status              TEXT CHECK (status IN ('pending', 'in_force', 'terminated', 'abandoned')),
    effective_date      TEXT,
    expiration_date     TEXT,
    total_value         REAL,
    payment_terms       TEXT,               -- e.g., 'net_30', '50_50', 'upfront'
    document_url        TEXT,
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS agreement_term (
    term_id             INTEGER PRIMARY KEY AUTOINCREMENT,
    agreement_id        TEXT NOT NULL REFERENCES agreement(agreement_id),
    term_type           TEXT NOT NULL,      -- e.g., 'space_allocation', 'payment_schedule', 'cancellation'
    description         TEXT,
    status              TEXT CHECK (status IN ('pending', 'in_force', 'terminated')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);


-- =============================================================================
-- FINANCE CONTEXT (GENERIC)
-- =============================================================================
-- Aggregate root: FinancialAccount
-- Owns: transactions, payments, revenue allocation
-- Source: QuickBooks/equivalent
-- Four Data System Type: Record
-- =============================================================================

CREATE TABLE IF NOT EXISTS dim_account (
    account_id          TEXT PRIMARY KEY,
    account_name        TEXT NOT NULL,
    account_type        TEXT CHECK (account_type IN (
        'revenue', 'expense', 'asset', 'liability', 'equity'
    )),
    account_category    TEXT CHECK (account_category IN (
        'exhibitor_revenue', 'sponsorship_revenue', 'ticket_revenue',
        'services_revenue', 'venue_expense', 'marketing_expense',
        'operations_expense', 'payroll', 'other'
    )),
    status              TEXT CHECK (status IN ('pending', 'open', 'closed', 'suspended')),
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS fct_transaction (
    transaction_id      TEXT PRIMARY KEY,
    account_id          TEXT NOT NULL REFERENCES dim_account(account_id),
    edition_id          TEXT REFERENCES dim_edition(edition_id),
    party_type          TEXT CHECK (party_type IN ('exhibitor', 'sponsor', 'attendee', 'vendor', 'venue', 'other')),
    party_id            TEXT,
    transaction_type    TEXT CHECK (transaction_type IN ('invoice', 'payment', 'refund', 'adjustment')),
    amount              REAL NOT NULL,
    currency            TEXT DEFAULT 'USD',
    status              TEXT CHECK (status IN ('pending', 'executed', 'rejected', 'cancelled', 'reversed')),
    transaction_date    TEXT,
    reference           TEXT,               -- invoice number, payment ID, etc.
    metadata            JSON NOT NULL DEFAULT '{}',
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);


-- =============================================================================
-- CROSS-CONTEXT RELATIONSHIPS
-- =============================================================================
-- Simplified edge table for explicit cross-context relationships.
-- Follows the semops-hub-pr/rockbot-pr edge pattern with AXPONA-specific predicates.
-- =============================================================================

CREATE TABLE IF NOT EXISTS context_edge (
    src_table       TEXT NOT NULL,
    src_id          TEXT NOT NULL,
    dst_table       TEXT NOT NULL,
    dst_id          TEXT NOT NULL,
    predicate       TEXT NOT NULL CHECK (predicate IN (
        'exhibits_at',          -- exhibitor → edition
        'sponsors',             -- sponsor → edition
        'assigned_to',          -- space → exhibitor
        'registered_for',       -- attendee → edition
        'scanned_at',           -- lead → space
        'contracted_under',     -- exhibitor/sponsor → agreement
        'invoiced_to',          -- transaction → party
        'presented_at',         -- speaker → session
        'related_to'            -- generic
    )),
    edition_id      TEXT REFERENCES dim_edition(edition_id),
    strength        REAL DEFAULT 1.0
        CHECK (strength >= 0.0 AND strength <= 1.0),
    metadata        JSON NOT NULL DEFAULT '{}',
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (src_table, src_id, dst_table, dst_id, predicate)
);


-- =============================================================================
-- INDEXES
-- =============================================================================

-- Edition
CREATE INDEX IF NOT EXISTS idx_edition_year ON dim_edition(edition_year);
CREATE INDEX IF NOT EXISTS idx_edition_status ON dim_edition(status);

-- Exhibitor
CREATE INDEX IF NOT EXISTS idx_exhibitor_category ON dim_exhibitor(category);
CREATE INDEX IF NOT EXISTS idx_exhibitor_type ON dim_exhibitor(exhibitor_type);
CREATE INDEX IF NOT EXISTS idx_exhibitor_tier ON dim_exhibitor(current_tier);
CREATE INDEX IF NOT EXISTS idx_fct_exhibitor_edition_edition ON fct_exhibitor_edition(edition_id);
CREATE INDEX IF NOT EXISTS idx_fct_exhibitor_edition_returning ON fct_exhibitor_edition(is_returning);
CREATE INDEX IF NOT EXISTS idx_fct_exhibitor_edition_rebooked ON fct_exhibitor_edition(rebooked_within_30d);
CREATE INDEX IF NOT EXISTS idx_service_order_exhibitor ON exhibitor_service_order(exhibitor_id, edition_id);
CREATE INDEX IF NOT EXISTS idx_rebooking_exhibitor ON exhibitor_rebooking(exhibitor_id);

-- Sponsorship
CREATE INDEX IF NOT EXISTS idx_sponsor_type ON dim_sponsor(sponsor_type);
CREATE INDEX IF NOT EXISTS idx_fct_sponsorship_sponsor ON fct_sponsorship_delivery(sponsor_id);
CREATE INDEX IF NOT EXISTS idx_fct_sponsorship_edition ON fct_sponsorship_delivery(edition_id);
CREATE INDEX IF NOT EXISTS idx_fct_sponsorship_status ON fct_sponsorship_delivery(delivery_status);
CREATE INDEX IF NOT EXISTS idx_package_tier ON sponsorship_package(tier);
CREATE INDEX IF NOT EXISTS idx_package_edition ON sponsorship_package(edition_id);

-- Exhibition Space
CREATE INDEX IF NOT EXISTS idx_space_type ON dim_space(space_type);
CREATE INDEX IF NOT EXISTS idx_fct_space_edition ON fct_space_assignment(edition_id);
CREATE INDEX IF NOT EXISTS idx_fct_space_exhibitor ON fct_space_assignment(exhibitor_id);
CREATE INDEX IF NOT EXISTS idx_fct_space_status ON fct_space_assignment(assignment_status);

-- Event
CREATE INDEX IF NOT EXISTS idx_session_edition ON event_session(edition_id);
CREATE INDEX IF NOT EXISTS idx_session_type ON event_session(session_type);

-- Attendee
CREATE INDEX IF NOT EXISTS idx_attendee_type ON dim_attendee(attendee_type);
CREATE INDEX IF NOT EXISTS idx_fct_registration_edition ON fct_registration(edition_id);
CREATE INDEX IF NOT EXISTS idx_fct_registration_ticket ON fct_registration(ticket_type);
CREATE INDEX IF NOT EXISTS idx_fct_registration_returning ON fct_registration(is_returning);

-- Interaction
CREATE INDEX IF NOT EXISTS idx_fct_lead_exhibitor ON fct_lead_capture(exhibitor_id);
CREATE INDEX IF NOT EXISTS idx_fct_lead_attendee ON fct_lead_capture(attendee_id);
CREATE INDEX IF NOT EXISTS idx_fct_lead_edition ON fct_lead_capture(edition_id);
CREATE INDEX IF NOT EXISTS idx_fct_lead_status ON fct_lead_capture(lead_status);
CREATE INDEX IF NOT EXISTS idx_matchmaking_edition ON matchmaking_appointment(edition_id);

-- Agreement
CREATE INDEX IF NOT EXISTS idx_agreement_type ON agreement(agreement_type);
CREATE INDEX IF NOT EXISTS idx_agreement_party ON agreement(party_type, party_id);
CREATE INDEX IF NOT EXISTS idx_agreement_edition ON agreement(edition_id);
CREATE INDEX IF NOT EXISTS idx_agreement_status ON agreement(status);

-- Finance
CREATE INDEX IF NOT EXISTS idx_account_type ON dim_account(account_type);
CREATE INDEX IF NOT EXISTS idx_account_category ON dim_account(account_category);
CREATE INDEX IF NOT EXISTS idx_transaction_account ON fct_transaction(account_id);
CREATE INDEX IF NOT EXISTS idx_transaction_edition ON fct_transaction(edition_id);
CREATE INDEX IF NOT EXISTS idx_transaction_party ON fct_transaction(party_type, party_id);
CREATE INDEX IF NOT EXISTS idx_transaction_status ON fct_transaction(status);

-- Cross-context
CREATE INDEX IF NOT EXISTS idx_edge_src ON context_edge(src_table, src_id);
CREATE INDEX IF NOT EXISTS idx_edge_dst ON context_edge(dst_table, dst_id);
CREATE INDEX IF NOT EXISTS idx_edge_edition ON context_edge(edition_id);


-- =============================================================================
-- VIEWS — Semantic Layer Metrics
-- =============================================================================

-- Rebooking rate by edition
CREATE VIEW IF NOT EXISTS v_rebooking_rate AS
SELECT
    edition_id,
    COUNT(*) AS total_exhibitors,
    SUM(rebooked_within_30d) AS rebooked,
    ROUND(CAST(SUM(rebooked_within_30d) AS REAL) / COUNT(*), 3) AS rebooking_rate
FROM fct_exhibitor_edition
GROUP BY edition_id;

-- Floor plan fill % by edition
CREATE VIEW IF NOT EXISTS v_floor_plan_fill AS
SELECT
    sa.edition_id,
    COUNT(*) AS total_spaces,
    SUM(CASE WHEN sa.assignment_status IN ('assigned', 'occupied') THEN 1 ELSE 0 END) AS filled_spaces,
    ROUND(
        CAST(SUM(CASE WHEN sa.assignment_status IN ('assigned', 'occupied') THEN 1 ELSE 0 END) AS REAL) / COUNT(*),
        3
    ) AS fill_pct
FROM fct_space_assignment sa
GROUP BY sa.edition_id;

-- Sponsorship sell-through by edition and category
CREATE VIEW IF NOT EXISTS v_sponsorship_sell_through AS
SELECT
    sp.edition_id,
    sp.category,
    COUNT(*) AS total_items,
    SUM(CASE WHEN sp.availability_status = 'sold' THEN 1 ELSE 0 END) AS sold_items,
    ROUND(
        CAST(SUM(CASE WHEN sp.availability_status = 'sold' THEN 1 ELSE 0 END) AS REAL) / COUNT(*),
        3
    ) AS sell_through_pct
FROM sponsorship_package sp
GROUP BY sp.edition_id, sp.category;

-- Attendee growth YoY
CREATE VIEW IF NOT EXISTS v_attendee_growth AS
SELECT
    e.edition_id,
    e.edition_year,
    COUNT(r.attendee_id) AS attendee_count,
    LAG(COUNT(r.attendee_id)) OVER (ORDER BY e.edition_year) AS prev_year_count,
    ROUND(
        (CAST(COUNT(r.attendee_id) AS REAL) -
         LAG(COUNT(r.attendee_id)) OVER (ORDER BY e.edition_year)) /
        NULLIF(LAG(COUNT(r.attendee_id)) OVER (ORDER BY e.edition_year), 0),
        3
    ) AS yoy_growth
FROM dim_edition e
LEFT JOIN fct_registration r ON e.edition_id = r.edition_id
GROUP BY e.edition_id, e.edition_year;

-- Services attach rate by exhibitor per edition
CREATE VIEW IF NOT EXISTS v_services_attach_rate AS
SELECT
    fe.edition_id,
    fe.exhibitor_id,
    fe.contract_value AS space_revenue,
    fe.services_revenue,
    CASE WHEN fe.contract_value > 0
        THEN ROUND(fe.services_revenue / fe.contract_value, 3)
        ELSE 0
    END AS attach_rate
FROM fct_exhibitor_edition fe
WHERE fe.contract_value > 0;

-- Edition P&L summary
CREATE VIEW IF NOT EXISTS v_edition_summary AS
SELECT
    e.edition_id,
    e.edition_year,
    e.edition_number,
    p.total_revenue,
    p.total_cost,
    p.margin,
    p.attendee_count,
    p.exhibitor_count,
    p.sponsor_count
FROM dim_edition e
LEFT JOIN fct_edition_pnl p ON e.edition_id = p.edition_id;

-- Exhibitor retention cohort
CREATE VIEW IF NOT EXISTS v_exhibitor_retention AS
SELECT
    fe1.edition_id AS from_edition,
    fe2.edition_id AS to_edition,
    COUNT(DISTINCT fe1.exhibitor_id) AS exhibitors_from,
    COUNT(DISTINCT fe2.exhibitor_id) AS retained,
    ROUND(
        CAST(COUNT(DISTINCT fe2.exhibitor_id) AS REAL) / NULLIF(COUNT(DISTINCT fe1.exhibitor_id), 0),
        3
    ) AS retention_rate
FROM fct_exhibitor_edition fe1
LEFT JOIN fct_exhibitor_edition fe2
    ON fe1.exhibitor_id = fe2.exhibitor_id
    AND fe2.edition_id > fe1.edition_id
GROUP BY fe1.edition_id, fe2.edition_id;
