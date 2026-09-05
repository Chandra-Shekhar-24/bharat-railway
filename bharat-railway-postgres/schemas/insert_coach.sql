/*
=============================================================================
SCHEMA: train_master_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Train Coach Composition
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
REQUESTED BY: Hitanshu Dhakrey (Backend Developer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

INSERT INTO train_master_schema.train_coach_composition 
(train_number, coach_class, number_of_coaches, coach_numbers, coach_position_from_engine, has_disabled_access, effective_from)
VALUES 
('12951', '1A', 2, '["H1","H2"]', 1, true, '2026-01-01'),
('12951', '2A', 4, '["A1","A2","A3","A4"]', 3, true, '2026-01-01'),
('12951', '3A', 8, '["B1","B2","B3","B4","B5","B6","B7","B8"]', 7, true, '2026-01-01'),
('12951', 'SL', 10, '["S1","S2","S3","S4","S5","S6","S7","S8","S9","S10"]', 11, false, '2026-01-01');