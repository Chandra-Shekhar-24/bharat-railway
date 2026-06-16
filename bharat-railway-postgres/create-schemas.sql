/*
developer name: Chandra Shekhar Bansal
developer email: chandrashekharbansal.2006@gmail.com
assisted by: DeepSeek
current file version: 1.2.0
version 1.0.0: Initial schema creation for Bharat Railway Booking System.
version 1.1.0: Renamed schemas from *_db to *_schema for clarity. File renamed to create-schemas.sql.
version 1.2.0: Expanded to 7 schemas as per PM final roadmap.
*/

-- Creates application schemas for modular data isolation
-- This file only creates schemas. Table creation scripts live in schemas/ directory.

CREATE SCHEMA IF NOT EXISTS identity_schema;
CREATE SCHEMA IF NOT EXISTS auth_schema;
CREATE SCHEMA IF NOT EXISTS train_master_schema;
CREATE SCHEMA IF NOT EXISTS booking_schema;
CREATE SCHEMA IF NOT EXISTS payment_schema;
CREATE SCHEMA IF NOT EXISTS notification_schema;
CREATE SCHEMA IF NOT EXISTS employee_schema;