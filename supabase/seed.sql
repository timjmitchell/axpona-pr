-- =============================================================================
-- AXPONA Seed Data — Demo Dataset
-- =============================================================================
-- Realistic data for AXPONA editions 2022-2025 (editions 13-16).
-- Designed to demonstrate all 16 gold metrics and 7 analytical views.
-- =============================================================================

-- ── Editions ────────────────────────────────────────────────────────────

INSERT INTO dim_edition (edition_id, edition_year, edition_number, venue_name, venue_city, venue_state, start_date, end_date, days, status) VALUES
    ('axpona-2022', 2022, 13, 'Renaissance Schaumburg', 'Schaumburg', 'IL', '2022-04-08', '2022-04-10', 3, 'completed'),
    ('axpona-2023', 2023, 14, 'Renaissance Schaumburg', 'Schaumburg', 'IL', '2023-04-14', '2023-04-16', 3, 'completed'),
    ('axpona-2024', 2024, 15, 'Renaissance Schaumburg', 'Schaumburg', 'IL', '2024-04-12', '2024-04-14', 3, 'completed'),
    ('axpona-2025', 2025, 16, 'Renaissance Schaumburg', 'Schaumburg', 'IL', '2025-04-11', '2025-04-13', 3, 'completed');

-- ── Exhibitors ──────────────────────────────────────────────────────────

INSERT INTO dim_exhibitor (exhibitor_id, company_name, category, exhibitor_type, first_edition, editions_attended, current_tier) VALUES
    ('ex-001', 'Wilson Audio', 'speakers', 'manufacturer', 'axpona-2022', 4, 'founding'),
    ('ex-002', 'McIntosh Laboratory', 'amplifiers', 'manufacturer', 'axpona-2022', 4, 'premium'),
    ('ex-003', 'VPI Industries', 'turntables', 'manufacturer', 'axpona-2022', 4, 'premium'),
    ('ex-004', 'PS Audio', 'digital', 'manufacturer', 'axpona-2022', 4, 'preferred'),
    ('ex-005', 'Focal', 'speakers', 'manufacturer', 'axpona-2022', 4, 'premium'),
    ('ex-006', 'AudioQuest', 'cables', 'manufacturer', 'axpona-2022', 3, 'preferred'),
    ('ex-007', 'Schiit Audio', 'headphones', 'manufacturer', 'axpona-2023', 3, 'preferred'),
    ('ex-008', 'Acoustic Sounds', 'vinyl', 'dealer', 'axpona-2022', 4, 'preferred'),
    ('ex-009', 'Revel', 'speakers', 'manufacturer', 'axpona-2023', 3, 'standard'),
    ('ex-010', 'Cambridge Audio', 'streaming', 'manufacturer', 'axpona-2023', 3, 'standard'),
    ('ex-011', 'Sonus Faber', 'speakers', 'manufacturer', 'axpona-2024', 2, 'standard'),
    ('ex-012', 'Chord Electronics', 'amplifiers', 'manufacturer', 'axpona-2024', 2, 'standard'),
    ('ex-013', 'Ortofon', 'accessories', 'manufacturer', 'axpona-2022', 2, 'standard'),
    ('ex-014', 'Bowers & Wilkins', 'speakers', 'manufacturer', 'axpona-2025', 1, 'standard'),
    ('ex-015', 'Pro-Ject Audio', 'turntables', 'manufacturer', 'axpona-2025', 1, 'standard');

-- ── Exhibitor × Edition (fact table) ────────────────────────────────────

INSERT INTO fct_exhibitor_edition (exhibitor_id, edition_id, space_type, space_sqft, contract_value, services_revenue, total_revenue, is_returning, priority_points, rebooked_within_30d, lifecycle_state) VALUES
    -- 2022
    ('ex-001', 'axpona-2022', 'listening_room', 600, 8500, 1200, 9700, false, 0, true, 'attended'),
    ('ex-002', 'axpona-2022', 'listening_room', 500, 7500, 800, 8300, false, 0, true, 'attended'),
    ('ex-003', 'axpona-2022', 'listening_room', 400, 6000, 600, 6600, false, 0, true, 'attended'),
    ('ex-004', 'axpona-2022', 'listening_room', 350, 5500, 500, 6000, false, 0, true, 'attended'),
    ('ex-005', 'axpona-2022', 'listening_room', 500, 7200, 900, 8100, false, 0, true, 'attended'),
    ('ex-006', 'axpona-2022', 'expo', 200, 3200, 400, 3600, false, 0, true, 'attended'),
    ('ex-008', 'axpona-2022', 'expo', 300, 4500, 200, 4700, false, 0, true, 'attended'),
    ('ex-013', 'axpona-2022', 'ear_gear', 100, 1800, 0, 1800, false, 0, false, 'attended'),
    -- 2023
    ('ex-001', 'axpona-2023', 'listening_room', 650, 9200, 1400, 10600, true, 10, true, 'attended'),
    ('ex-002', 'axpona-2023', 'listening_room', 500, 7800, 900, 8700, true, 8, true, 'attended'),
    ('ex-003', 'axpona-2023', 'listening_room', 400, 6200, 700, 6900, true, 6, true, 'attended'),
    ('ex-004', 'axpona-2023', 'listening_room', 350, 5800, 600, 6400, true, 5, true, 'attended'),
    ('ex-005', 'axpona-2023', 'listening_room', 550, 7800, 1000, 8800, true, 8, true, 'attended'),
    ('ex-006', 'axpona-2023', 'expo', 200, 3400, 400, 3800, true, 4, true, 'attended'),
    ('ex-007', 'axpona-2023', 'ear_gear', 150, 2800, 200, 3000, false, 0, true, 'attended'),
    ('ex-008', 'axpona-2023', 'expo', 300, 4800, 300, 5100, true, 5, true, 'attended'),
    ('ex-009', 'axpona-2023', 'listening_room', 300, 4500, 400, 4900, false, 0, true, 'attended'),
    ('ex-010', 'axpona-2023', 'expo', 150, 2500, 200, 2700, false, 0, true, 'attended'),
    -- 2024
    ('ex-001', 'axpona-2024', 'listening_room', 700, 9800, 1600, 11400, true, 20, true, 'attended'),
    ('ex-002', 'axpona-2024', 'listening_room', 550, 8200, 1000, 9200, true, 16, true, 'attended'),
    ('ex-003', 'axpona-2024', 'listening_room', 450, 6800, 800, 7600, true, 12, true, 'attended'),
    ('ex-004', 'axpona-2024', 'listening_room', 400, 6200, 700, 6900, true, 10, true, 'attended'),
    ('ex-005', 'axpona-2024', 'listening_room', 550, 8200, 1100, 9300, true, 16, true, 'attended'),
    ('ex-006', 'axpona-2024', 'expo', 250, 3800, 500, 4300, true, 8, false, 'attended'),
    ('ex-007', 'axpona-2024', 'ear_gear', 200, 3200, 300, 3500, true, 4, true, 'attended'),
    ('ex-008', 'axpona-2024', 'expo', 350, 5200, 400, 5600, true, 10, true, 'attended'),
    ('ex-009', 'axpona-2024', 'listening_room', 350, 5000, 500, 5500, true, 4, true, 'attended'),
    ('ex-010', 'axpona-2024', 'expo', 200, 2800, 300, 3100, true, 4, true, 'attended'),
    ('ex-011', 'axpona-2024', 'listening_room', 400, 6000, 600, 6600, false, 0, true, 'attended'),
    ('ex-012', 'axpona-2024', 'listening_room', 300, 4800, 400, 5200, false, 0, true, 'attended'),
    -- 2025
    ('ex-001', 'axpona-2025', 'listening_room', 700, 10500, 1800, 12300, true, 30, false, 'rebooking'),
    ('ex-002', 'axpona-2025', 'listening_room', 600, 8800, 1200, 10000, true, 24, true, 'attended'),
    ('ex-003', 'axpona-2025', 'listening_room', 450, 7200, 900, 8100, true, 18, true, 'attended'),
    ('ex-004', 'axpona-2025', 'listening_room', 400, 6500, 800, 7300, true, 15, true, 'attended'),
    ('ex-005', 'axpona-2025', 'listening_room', 600, 8800, 1200, 10000, true, 24, true, 'attended'),
    ('ex-007', 'axpona-2025', 'ear_gear', 250, 3800, 400, 4200, true, 8, true, 'attended'),
    ('ex-008', 'axpona-2025', 'expo', 400, 5600, 500, 6100, true, 15, true, 'attended'),
    ('ex-009', 'axpona-2025', 'listening_room', 400, 5500, 600, 6100, true, 8, true, 'attended'),
    ('ex-010', 'axpona-2025', 'expo', 200, 3000, 300, 3300, true, 8, true, 'attended'),
    ('ex-011', 'axpona-2025', 'listening_room', 450, 6500, 700, 7200, true, 4, true, 'attended'),
    ('ex-012', 'axpona-2025', 'listening_room', 350, 5200, 500, 5700, true, 4, true, 'attended'),
    ('ex-014', 'axpona-2025', 'listening_room', 500, 7000, 800, 7800, false, 0, false, 'attended'),
    ('ex-015', 'axpona-2025', 'expo', 150, 2200, 200, 2400, false, 0, false, 'attended');

-- ── Spaces ──────────────────────────────────────────────────────────────

INSERT INTO dim_space (space_id, space_type, floor_location, width_ft, depth_ft, sqft, corner_flag, electrical_access) VALUES
    ('lr-101', 'listening_room', 'Tower/1/North', 25, 24, 600, false, true),
    ('lr-102', 'listening_room', 'Tower/1/North', 20, 25, 500, false, true),
    ('lr-103', 'listening_room', 'Tower/1/South', 20, 20, 400, false, true),
    ('lr-104', 'listening_room', 'Tower/2/North', 18, 20, 360, false, true),
    ('lr-105', 'listening_room', 'Tower/2/South', 22, 25, 550, true, true),
    ('lr-106', 'listening_room', 'Tower/2/South', 20, 22, 440, false, true),
    ('lr-107', 'listening_room', 'Tower/3/North', 15, 20, 300, false, true),
    ('lr-108', 'listening_room', 'Tower/3/South', 17, 20, 340, false, true),
    ('lr-109', 'listening_room', 'Tower/3/South', 20, 25, 500, true, true),
    ('lr-110', 'listening_room', 'Tower/4/North', 20, 22, 440, false, true),
    ('expo-01', 'expo', 'Ballroom/A', 20, 15, 300, true, true),
    ('expo-02', 'expo', 'Ballroom/A', 15, 13, 200, false, true),
    ('expo-03', 'expo', 'Ballroom/B', 20, 18, 350, false, true),
    ('expo-04', 'expo', 'Ballroom/B', 10, 15, 150, false, true),
    ('expo-05', 'expo', 'Ballroom/C', 15, 17, 250, true, true),
    ('eg-01', 'ear_gear', 'Mezzanine/1', 10, 10, 100, false, true),
    ('eg-02', 'ear_gear', 'Mezzanine/1', 10, 15, 150, false, true),
    ('eg-03', 'ear_gear', 'Mezzanine/2', 10, 20, 200, false, true),
    ('eg-04', 'ear_gear', 'Mezzanine/2', 10, 25, 250, true, true);

-- ── Space Assignments (2025 edition) ────────────────────────────────────

INSERT INTO fct_space_assignment (space_id, edition_id, exhibitor_id, assignment_status, assignment_date, revenue_per_sqft, list_price, actual_price) VALUES
    ('lr-101', 'axpona-2025', 'ex-001', 'occupied', '2024-05-10', 17.50, 10500, 10500),
    ('lr-102', 'axpona-2025', 'ex-002', 'occupied', '2024-05-12', 17.60, 8800, 8800),
    ('lr-103', 'axpona-2025', 'ex-003', 'occupied', '2024-05-15', 16.00, 7200, 7200),
    ('lr-104', 'axpona-2025', 'ex-004', 'occupied', '2024-05-20', 18.06, 6500, 6500),
    ('lr-105', 'axpona-2025', 'ex-005', 'occupied', '2024-05-11', 16.00, 8800, 8800),
    ('lr-106', 'axpona-2025', 'ex-011', 'occupied', '2024-09-15', 14.77, 6500, 6500),
    ('lr-107', 'axpona-2025', 'ex-009', 'occupied', '2024-06-01', 18.33, 5500, 5500),
    ('lr-108', 'axpona-2025', 'ex-012', 'occupied', '2024-09-20', 15.29, 5200, 5200),
    ('lr-109', 'axpona-2025', 'ex-014', 'occupied', '2024-11-01', 14.00, 7000, 7000),
    ('lr-110', 'axpona-2025', null, 'available', null, null, 7500, null),
    ('expo-01', 'axpona-2025', 'ex-008', 'occupied', '2024-05-14', 18.67, 5600, 5600),
    ('expo-02', 'axpona-2025', 'ex-010', 'occupied', '2024-06-05', 15.00, 3000, 3000),
    ('expo-03', 'axpona-2025', null, 'available', null, null, 5500, null),
    ('expo-04', 'axpona-2025', 'ex-015', 'occupied', '2024-12-01', 14.67, 2200, 2200),
    ('expo-05', 'axpona-2025', null, 'available', null, null, 4000, null),
    ('eg-01', 'axpona-2025', null, 'available', null, null, 1800, null),
    ('eg-02', 'axpona-2025', null, 'available', null, null, 2500, null),
    ('eg-03', 'axpona-2025', 'ex-007', 'occupied', '2024-06-10', 15.20, 3800, 3800),
    ('eg-04', 'axpona-2025', null, 'available', null, null, 3500, null);

-- ── Sponsors ────────────────────────────────────────────────────────────

INSERT INTO dim_sponsor (sponsor_id, company_name, sponsor_type, first_edition, editions_sponsored) VALUES
    ('sp-001', 'Wilson Audio', 'exhibitor_sponsor', 'axpona-2022', 4),
    ('sp-002', 'Stereophile', 'media_partner', 'axpona-2022', 4),
    ('sp-003', 'The Absolute Sound', 'media_partner', 'axpona-2023', 3),
    ('sp-004', 'McIntosh Laboratory', 'brand_sponsor', 'axpona-2024', 2),
    ('sp-005', 'Qobuz', 'industry_partner', 'axpona-2024', 2);

-- ── Sponsorship Packages ────────────────────────────────────────────────

INSERT INTO sponsorship_package (package_id, name, tier, price, category, edition_id, availability_status) VALUES
    ('pkg-001', 'Title Sponsor', 'title', 25000, 'branding', 'axpona-2025', 'sold'),
    ('pkg-002', 'Platinum Media', 'platinum', 15000, 'digital', 'axpona-2025', 'sold'),
    ('pkg-003', 'Gold Print', 'gold', 8000, 'print', 'axpona-2025', 'sold'),
    ('pkg-004', 'Gold Digital', 'gold', 8000, 'digital', 'axpona-2025', 'sold'),
    ('pkg-005', 'Silver Branding', 'silver', 5000, 'branding', 'axpona-2025', 'sold'),
    ('pkg-006', 'Silver Experiential', 'silver', 5000, 'experiential', 'axpona-2025', 'available'),
    ('pkg-007', 'Bronze Hospitality', 'bronze', 3000, 'hospitality', 'axpona-2025', 'sold'),
    ('pkg-008', 'Bronze Print', 'bronze', 2500, 'print', 'axpona-2025', 'available'),
    ('pkg-009', 'WiFi Sponsor', 'custom', 12000, 'experiential', 'axpona-2025', 'sold'),
    ('pkg-010', 'Charging Station', 'individual', 4000, 'experiential', 'axpona-2025', 'sold'),
    -- 2024 packages
    ('pkg-011', 'Title Sponsor', 'title', 22000, 'branding', 'axpona-2024', 'sold'),
    ('pkg-012', 'Platinum Media', 'platinum', 14000, 'digital', 'axpona-2024', 'sold'),
    ('pkg-013', 'Gold Print', 'gold', 7500, 'print', 'axpona-2024', 'sold'),
    ('pkg-014', 'Silver Branding', 'silver', 4500, 'branding', 'axpona-2024', 'sold'),
    ('pkg-015', 'Bronze Hospitality', 'bronze', 2500, 'hospitality', 'axpona-2024', 'available');

-- ── Sponsorship Deliveries ──────────────────────────────────────────────

INSERT INTO fct_sponsorship_delivery (sponsorship_id, sponsor_id, edition_id, package_tier, deliverable_type, deliverable_value, estimated_impressions, delivery_status, is_renewal) VALUES
    ('s-2025-001', 'sp-001', 'axpona-2025', 'title', 'signage', 10000, 50000, 'delivered', true),
    ('s-2025-001', 'sp-001', 'axpona-2025', 'title', 'digital_ad', 8000, 200000, 'delivered', true),
    ('s-2025-001', 'sp-001', 'axpona-2025', 'title', 'branded_experience', 7000, 30000, 'delivered', true),
    ('s-2025-002', 'sp-002', 'axpona-2025', 'platinum', 'print', 8000, 100000, 'delivered', true),
    ('s-2025-002', 'sp-002', 'axpona-2025', 'platinum', 'digital_ad', 7000, 150000, 'delivered', true),
    ('s-2025-003', 'sp-003', 'axpona-2025', 'gold', 'print', 4000, 80000, 'delivered', true),
    ('s-2025-003', 'sp-003', 'axpona-2025', 'gold', 'digital_ad', 4000, 120000, 'delivered', true),
    ('s-2025-004', 'sp-004', 'axpona-2025', 'silver', 'signage', 3000, 25000, 'delivered', true),
    ('s-2025-004', 'sp-004', 'axpona-2025', 'silver', 'branded_experience', 2000, 15000, 'delivered', true),
    ('s-2025-005', 'sp-005', 'axpona-2025', 'custom', 'wifi', 12000, 40000, 'delivered', false),
    -- 2024
    ('s-2024-001', 'sp-001', 'axpona-2024', 'title', 'signage', 9000, 45000, 'delivered', true),
    ('s-2024-001', 'sp-001', 'axpona-2024', 'title', 'digital_ad', 7000, 180000, 'delivered', true),
    ('s-2024-002', 'sp-002', 'axpona-2024', 'platinum', 'print', 7500, 90000, 'delivered', true),
    ('s-2024-003', 'sp-003', 'axpona-2024', 'gold', 'print', 3500, 75000, 'delivered', false);

-- ── Edition P&L ─────────────────────────────────────────────────────────

INSERT INTO fct_edition_pnl (edition_id, venue_cost, marketing_spend, operations_cost, exhibitor_revenue, sponsorship_revenue, ticket_revenue, services_revenue, total_revenue, total_cost, margin, attendee_count, exhibitor_count, sponsor_count) VALUES
    ('axpona-2022', 180000, 85000, 120000, 48800, 45000, 280000, 4600, 378400, 385000, -0.017, 7200, 8, 3),
    ('axpona-2023', 195000, 95000, 135000, 60400, 58000, 320000, 5500, 443900, 425000, 0.044, 8100, 10, 4),
    ('axpona-2024', 210000, 110000, 150000, 72300, 72000, 365000, 7900, 517200, 470000, 0.091, 9200, 12, 5),
    ('axpona-2025', 220000, 120000, 160000, 90400, 87500, 410000, 9600, 597500, 500000, 0.163, 10500, 13, 5);

-- ── Attendees ───────────────────────────────────────────────────────────

INSERT INTO dim_attendee (attendee_id, first_name, last_name, attendee_type, first_edition, editions_attended) VALUES
    ('att-001', 'Demo', 'Consumer1', 'consumer', 'axpona-2022', 4),
    ('att-002', 'Demo', 'Consumer2', 'consumer', 'axpona-2023', 3),
    ('att-003', 'Demo', 'Trade1', 'trade', 'axpona-2022', 4),
    ('att-004', 'Demo', 'VIP1', 'vip', 'axpona-2024', 2),
    ('att-005', 'Demo', 'Press1', 'press', 'axpona-2022', 4);

-- ── Registrations ───────────────────────────────────────────────────────

INSERT INTO fct_registration (attendee_id, edition_id, ticket_type, ticket_price, acquisition_source, checked_in, days_attended, is_returning) VALUES
    ('att-001', 'axpona-2022', 'general_admission', 40, 'organic', true, 3, false),
    ('att-001', 'axpona-2023', 'general_admission', 45, 'email', true, 3, true),
    ('att-001', 'axpona-2024', 'general_admission', 50, 'email', true, 2, true),
    ('att-001', 'axpona-2025', 'vip', 125, 'email', true, 3, true),
    ('att-002', 'axpona-2023', 'friday_pass', 25, 'social', true, 1, false),
    ('att-002', 'axpona-2024', 'general_admission', 50, 'organic', true, 2, true),
    ('att-002', 'axpona-2025', 'general_admission', 55, 'referral', true, 3, true),
    ('att-003', 'axpona-2022', 'trade_pass', 0, 'partner', true, 3, false),
    ('att-003', 'axpona-2023', 'trade_pass', 0, 'partner', true, 3, true),
    ('att-003', 'axpona-2024', 'trade_pass', 0, 'partner', true, 3, true),
    ('att-003', 'axpona-2025', 'trade_pass', 0, 'partner', true, 3, true),
    ('att-004', 'axpona-2024', 'vip', 100, 'organic', true, 3, false),
    ('att-004', 'axpona-2025', 'vip', 125, 'email', true, 3, true),
    ('att-005', 'axpona-2022', 'trade_pass', 0, 'press', true, 3, false),
    ('att-005', 'axpona-2023', 'trade_pass', 0, 'press', true, 2, true),
    ('att-005', 'axpona-2024', 'trade_pass', 0, 'press', true, 3, true),
    ('att-005', 'axpona-2025', 'trade_pass', 0, 'press', true, 3, true);

-- ── Lead Captures ───────────────────────────────────────────────────────

INSERT INTO dim_interaction (interaction_id, interaction_type) VALUES
    ('int-001', 'badge_scan'),
    ('int-002', 'badge_scan'),
    ('int-003', 'demo_request'),
    ('int-004', 'badge_scan'),
    ('int-005', 'booth_visit');

INSERT INTO fct_lead_capture (interaction_id, exhibitor_id, attendee_id, edition_id, scan_timestamp, interaction_type, lead_status, space_id) VALUES
    ('int-001', 'ex-001', 'att-001', 'axpona-2025', '2025-04-11 10:30:00', 'badge_scan', 'qualified', 'lr-101'),
    ('int-002', 'ex-002', 'att-001', 'axpona-2025', '2025-04-11 14:15:00', 'badge_scan', 'captured', 'lr-102'),
    ('int-003', 'ex-001', 'att-002', 'axpona-2025', '2025-04-12 11:00:00', 'demo_request', 'converted', 'lr-101'),
    ('int-004', 'ex-005', 'att-004', 'axpona-2025', '2025-04-12 15:30:00', 'badge_scan', 'qualified', 'lr-105'),
    ('int-005', 'ex-008', 'att-003', 'axpona-2025', '2025-04-13 09:45:00', 'booth_visit', 'followed_up', 'expo-01');

-- ── Financial Accounts ──────────────────────────────────────────────────

INSERT INTO dim_account (account_id, account_name, account_type, account_category, status) VALUES
    ('acct-001', 'Exhibitor Space Revenue', 'revenue', 'exhibitor_revenue', 'open'),
    ('acct-002', 'Sponsorship Revenue', 'revenue', 'sponsorship_revenue', 'open'),
    ('acct-003', 'Ticket Revenue', 'revenue', 'ticket_revenue', 'open'),
    ('acct-004', 'Services Revenue', 'revenue', 'services_revenue', 'open'),
    ('acct-005', 'Venue Expense', 'expense', 'venue_expense', 'open'),
    ('acct-006', 'Marketing Expense', 'expense', 'marketing_expense', 'open');

-- ── Transactions (2025 sample) ──────────────────────────────────────────

INSERT INTO fct_transaction (transaction_id, account_id, edition_id, party_type, party_id, transaction_type, amount, status, transaction_date) VALUES
    ('txn-001', 'acct-001', 'axpona-2025', 'exhibitor', 'ex-001', 'invoice', 10500, 'executed', '2024-05-15'),
    ('txn-002', 'acct-001', 'axpona-2025', 'exhibitor', 'ex-002', 'invoice', 8800, 'executed', '2024-05-20'),
    ('txn-003', 'acct-002', 'axpona-2025', 'sponsor', 'sp-001', 'invoice', 25000, 'executed', '2024-06-01'),
    ('txn-004', 'acct-003', 'axpona-2025', 'attendee', null, 'payment', 410000, 'executed', '2025-04-11'),
    ('txn-005', 'acct-004', 'axpona-2025', 'exhibitor', 'ex-001', 'invoice', 1800, 'executed', '2025-03-15'),
    ('txn-006', 'acct-005', 'axpona-2025', 'venue', null, 'invoice', 220000, 'executed', '2024-12-01'),
    ('txn-007', 'acct-006', 'axpona-2025', 'vendor', null, 'invoice', 120000, 'executed', '2025-01-15'),
    ('txn-008', 'acct-001', 'axpona-2025', 'exhibitor', 'ex-001', 'payment', 10500, 'executed', '2024-06-15'),
    ('txn-009', 'acct-002', 'axpona-2025', 'sponsor', 'sp-001', 'payment', 25000, 'executed', '2024-07-01');
