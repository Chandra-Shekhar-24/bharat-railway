/*
=============================================================================
SCHEMA: fare_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Fare Configuration
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
Table: base_fare_matrix - Distance slab based fare per train type and class
*/
CREATE TABLE fare_schema.base_fare_matrix (
    fare_id                 SERIAL        PRIMARY KEY,
    train_type              VARCHAR(20)   NOT NULL,
    coach_class             VARCHAR(3)    NOT NULL REFERENCES train_master_schema.coach_types(coach_code),
    distance_from_km        INTEGER       NOT NULL CHECK (distance_from_km > 0),
    distance_to_km          INTEGER       NOT NULL CHECK (distance_to_km >= distance_from_km),
    base_fare               DECIMAL(8,2)  NOT NULL CHECK (base_fare >= 0),
    minimum_fare            DECIMAL(8,2)  NOT NULL DEFAULT 0,
    per_km_rate_beyond      DECIMAL(6,2)  NOT NULL DEFAULT 0,
    effective_from          DATE          NOT NULL DEFAULT CURRENT_DATE,
    effective_to            DATE,
    is_active               BOOLEAN       NOT NULL DEFAULT TRUE,
    UNIQUE (train_type, coach_class, distance_from_km, effective_from)
);

COMMENT ON TABLE fare_schema.base_fare_matrix IS 'Distance slab based fare config';

CREATE INDEX idx_fare_matrix_train_type ON fare_schema.base_fare_matrix(train_type);
CREATE INDEX idx_fare_matrix_class ON fare_schema.base_fare_matrix(coach_class);

/*
Table: cancellation_charges - Cancellation slab definitions
*/
CREATE TABLE fare_schema.cancellation_charges (
    charge_id               SERIAL        PRIMARY KEY,
    hours_before_departure_min INTEGER      NOT NULL DEFAULT 0,
    hours_before_departure_max INTEGER      NOT NULL DEFAULT 99999,
    cancellation_type       VARCHAR(20)   NOT NULL CHECK (cancellation_type IN ('CONFIRMED','RAC','WAITLIST')),
    coach_class             VARCHAR(3)    NOT NULL REFERENCES train_master_schema.coach_types(coach_code),
    charge_type             VARCHAR(20)   NOT NULL CHECK (charge_type IN ('PERCENTAGE','FLAT')),
    charge_value            DECIMAL(6,2)  NOT NULL,
    minimum_charge          DECIMAL(6,2)  NOT NULL DEFAULT 0,
    is_active               BOOLEAN       NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE fare_schema.cancellation_charges IS 'Cancellation slab charges';

/*
Table: convenience_fee_config - Platform fee per booking
*/
CREATE TABLE fare_schema.convenience_fee_config (
    config_id               SERIAL        PRIMARY KEY,
    booking_channel         VARCHAR(20)   NOT NULL DEFAULT 'ONLINE' CHECK (booking_channel IN ('ONLINE','COUNTER','AGENT')),
    coach_class             VARCHAR(3)    REFERENCES train_master_schema.coach_types(coach_code),
    fee_amount              DECIMAL(6,2)  NOT NULL DEFAULT 0,
    gst_on_fee              DECIMAL(5,2)  NOT NULL DEFAULT 18.00,
    is_active               BOOLEAN       NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE fare_schema.convenience_fee_config IS 'Platform convenience fee';