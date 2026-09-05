/*
=============================================================================
SCHEMA: train_master_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Train Master Data
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
Table: stations - Railway station master data
*/
CREATE TABLE train_master_schema.stations (
    station_code        VARCHAR(5)   PRIMARY KEY,
    station_name        VARCHAR(100) NOT NULL,
    city                VARCHAR(50)  NOT NULL,
    state               VARCHAR(30)  NOT NULL,
    zone                VARCHAR(50)  NOT NULL,
    division            VARCHAR(30)  NOT NULL,
    station_category    VARCHAR(5)   NOT NULL CHECK (station_category IN ('A1','A','B','C','D','E','F')),
    station_type        VARCHAR(20)  NOT NULL CHECK (station_type IN ('Terminal','Junction','Central','Halt')),
    number_of_platforms SMALLINT     NOT NULL DEFAULT 1,
    pincode             VARCHAR(6),
    station_status      VARCHAR(20)  NOT NULL DEFAULT 'Active' CHECK (station_status IN ('Active','Inactive','Under Renovation')),
    is_hill_station     BOOLEAN      NOT NULL DEFAULT FALSE,
    is_international    BOOLEAN      NOT NULL DEFAULT FALSE,
    opening_year        SMALLINT,
    created_at          TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at          TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE train_master_schema.stations IS 'Railway station master data';
COMMENT ON COLUMN train_master_schema.stations.station_code IS 'Unique 5-char station code (NDLS, BCT)';
COMMENT ON COLUMN train_master_schema.stations.station_category IS 'A1,A,B,C,D,E,F based on revenue';
COMMENT ON COLUMN train_master_schema.stations.station_type IS 'Terminal, Junction, Central, Halt';
COMMENT ON COLUMN train_master_schema.stations.station_status IS 'Active, Inactive, Under Renovation';

CREATE INDEX idx_stations_city ON train_master_schema.stations(city);
CREATE INDEX idx_stations_state ON train_master_schema.stations(state);
CREATE INDEX idx_stations_zone ON train_master_schema.stations(zone);
CREATE INDEX idx_stations_status ON train_master_schema.stations(station_status);

/*
Table: trains - Train master data
*/
CREATE TABLE train_master_schema.trains (
    train_number            VARCHAR(5)    PRIMARY KEY,
    train_name              VARCHAR(100)  NOT NULL,
    train_type              VARCHAR(30)   NOT NULL CHECK (train_type IN ('Rajdhani','Shatabdi','Duronto','Garib Rath','Sampark Kranti','Express','Mail','Passenger','Superfast','MEMU','DEMU','Vande Bharat','Tejas','Humsafar')),
    category                VARCHAR(20)   NOT NULL CHECK (category IN ('Superfast','Express','Mail','Passenger')),
    origin_station_code     VARCHAR(5)    NOT NULL REFERENCES train_master_schema.stations(station_code),
    destination_station_code VARCHAR(5)   NOT NULL REFERENCES train_master_schema.stations(station_code),
    total_distance          DECIMAL(7,2)  NOT NULL CHECK (total_distance > 0),
    average_speed           DECIMAL(5,2),
    maximum_speed           DECIMAL(5,2),
    total_coaches           SMALLINT      NOT NULL DEFAULT 0,
    pantry_car              BOOLEAN       NOT NULL DEFAULT FALSE,
    wifi_available          BOOLEAN       NOT NULL DEFAULT FALSE,
    train_status            VARCHAR(20)   NOT NULL DEFAULT 'Active' CHECK (train_status IN ('Active','Suspended','Cancelled')),
    introduction_date       DATE,
    is_special_train        BOOLEAN       NOT NULL DEFAULT FALSE,
    fare_multiplier         DECIMAL(4,2)  NOT NULL DEFAULT 1.0 CHECK (fare_multiplier > 0),
    tatkal_available        BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    CONSTRAINT chk_train_origin_dest CHECK (origin_station_code <> destination_station_code)
);

COMMENT ON TABLE train_master_schema.trains IS 'Train master data';
COMMENT ON COLUMN train_master_schema.trains.train_number IS 'Unique 5-digit train number';
COMMENT ON COLUMN train_master_schema.trains.fare_multiplier IS 'Premium factor (1.0 normal, 1.2 premium)';

CREATE INDEX idx_trains_origin ON train_master_schema.trains(origin_station_code);
CREATE INDEX idx_trains_destination ON train_master_schema.trains(destination_station_code);
CREATE INDEX idx_trains_status ON train_master_schema.trains(train_status);
CREATE INDEX idx_trains_type ON train_master_schema.trains(train_type);

/*
Table: routes - Train route with station sequence and timing
*/
CREATE TABLE train_master_schema.routes (
    route_id                SERIAL        PRIMARY KEY,
    train_number            VARCHAR(5)    NOT NULL REFERENCES train_master_schema.trains(train_number) ON DELETE CASCADE,
    station_code            VARCHAR(5)    NOT NULL REFERENCES train_master_schema.stations(station_code),
    sequence_number         INTEGER       NOT NULL CHECK (sequence_number > 0),
    arrival_time            TIME,
    departure_time          TIME,
    halt_duration           SMALLINT      NOT NULL DEFAULT 0,
    distance_from_origin    DECIMAL(7,2)  NOT NULL DEFAULT 0 CHECK (distance_from_origin >= 0),
    day_number              SMALLINT      NOT NULL DEFAULT 1 CHECK (day_number > 0),
    platform_number         VARCHAR(10),
    is_commercial_stop      BOOLEAN       NOT NULL DEFAULT TRUE,
    is_technical_halt       BOOLEAN       NOT NULL DEFAULT FALSE,
    is_originating_station  BOOLEAN       NOT NULL DEFAULT FALSE,
    is_terminating_station  BOOLEAN       NOT NULL DEFAULT FALSE,
    is_major_junction       BOOLEAN       NOT NULL DEFAULT FALSE,
    booking_quota           INTEGER       NOT NULL DEFAULT 0,
    waiting_list_quota      INTEGER       NOT NULL DEFAULT 0,
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    UNIQUE (train_number, sequence_number),
    UNIQUE (train_number, station_code)
);

COMMENT ON TABLE train_master_schema.routes IS 'Train route station sequence with timings';
COMMENT ON COLUMN train_master_schema.routes.sequence_number IS 'Stop order from origin (1-based)';
COMMENT ON COLUMN train_master_schema.routes.day_number IS '1=same day, 2=next day';
COMMENT ON COLUMN train_master_schema.routes.is_commercial_stop IS 'Passengers can board/deboard';

CREATE INDEX idx_routes_train ON train_master_schema.routes(train_number);
CREATE INDEX idx_routes_station ON train_master_schema.routes(station_code);
CREATE INDEX idx_routes_train_seq ON train_master_schema.routes(train_number, sequence_number);

/*
Table: coach_types - Travel class definitions
*/
CREATE TABLE train_master_schema.coach_types (
    coach_code              VARCHAR(3)    PRIMARY KEY,
    coach_name              VARCHAR(50)   NOT NULL,
    comfort_level           VARCHAR(20)   NOT NULL CHECK (comfort_level IN ('Luxury','Premium','Comfort','Standard','Basic')),
    has_ac                  BOOLEAN       NOT NULL DEFAULT FALSE,
    berth_type              VARCHAR(20)   NOT NULL CHECK (berth_type IN ('Berth','Chair Car','Bench')),
    seats_per_coach         SMALLINT      NOT NULL DEFAULT 0 CHECK (seats_per_coach > 0),
    has_side_berths         BOOLEAN       NOT NULL DEFAULT FALSE,
    bedding_provided        BOOLEAN       NOT NULL DEFAULT FALSE,
    food_included           BOOLEAN       NOT NULL DEFAULT FALSE,
    base_fare_multiplier    DECIMAL(4,2)  NOT NULL DEFAULT 1.0 CHECK (base_fare_multiplier > 0),
    rac_allowed             BOOLEAN       NOT NULL DEFAULT TRUE,
    tatkal_allowed          BOOLEAN       NOT NULL DEFAULT TRUE,
    max_passengers_per_pnr  SMALLINT      NOT NULL DEFAULT 6,
    is_unreserved           BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE train_master_schema.coach_types IS 'Travel class definitions';
COMMENT ON COLUMN train_master_schema.coach_types.base_fare_multiplier IS 'Price factor relative to SL class';

/*
Seed data for coach types - Indian Railways standard classes
*/
INSERT INTO train_master_schema.coach_types (coach_code, coach_name, comfort_level, has_ac, berth_type, seats_per_coach, has_side_berths, bedding_provided, food_included, base_fare_multiplier, rac_allowed, is_unreserved) VALUES
('1A', 'First AC',              'Luxury',   TRUE,  'Berth',     24, FALSE, TRUE,  TRUE,  5.0, FALSE, FALSE),
('2A', 'Second AC',             'Premium',  TRUE,  'Berth',     54, TRUE,  TRUE,  FALSE, 3.5, TRUE,  FALSE),
('3A', 'Third AC',              'Comfort',  TRUE,  'Berth',     72, TRUE,  TRUE,  FALSE, 2.5, TRUE,  FALSE),
('CC', 'AC Chair Car',          'Comfort',  TRUE,  'Chair Car', 78, FALSE, FALSE, TRUE,  2.0, FALSE, FALSE),
('EC', 'Executive Chair Car',   'Premium',  TRUE,  'Chair Car', 56, FALSE, FALSE, TRUE,  4.0, FALSE, FALSE),
('SL', 'Sleeper',               'Standard', FALSE, 'Berth',     72, TRUE,  FALSE, FALSE, 1.0, TRUE,  FALSE),
('2S', 'Second Sitting',        'Basic',    FALSE, 'Bench',     108, FALSE, FALSE, FALSE, 0.6, FALSE, FALSE),
('GN', 'General',               'Basic',    FALSE, 'Bench',     100, FALSE, FALSE, FALSE, 0.4, FALSE, TRUE)
ON CONFLICT (coach_code) DO NOTHING;

/*
Table: train_coach_composition - Coach layout per train
*/
CREATE TABLE train_master_schema.train_coach_composition (
    composition_id          SERIAL        PRIMARY KEY,
    train_number            VARCHAR(5)    NOT NULL REFERENCES train_master_schema.trains(train_number) ON DELETE CASCADE,
    coach_class             VARCHAR(3)    NOT NULL REFERENCES train_master_schema.coach_types(coach_code),
    number_of_coaches       SMALLINT      NOT NULL DEFAULT 1 CHECK (number_of_coaches > 0),
    coach_numbers           JSONB,
    coach_position_from_engine SMALLINT   NOT NULL DEFAULT 1,
    has_disabled_access     BOOLEAN       NOT NULL DEFAULT FALSE,
    effective_from          DATE          NOT NULL DEFAULT CURRENT_DATE,
    effective_to            DATE,
    UNIQUE (train_number, coach_class, effective_from)
);

COMMENT ON TABLE train_master_schema.train_coach_composition IS 'Physical coach layout per train';
COMMENT ON COLUMN train_master_schema.train_coach_composition.coach_numbers IS 'Array of coach IDs like ["B1","B2"]';

CREATE INDEX idx_composition_train ON train_master_schema.train_coach_composition(train_number);
CREATE INDEX idx_composition_class ON train_master_schema.train_coach_composition(coach_class);

/*
Table: seats - Individual seat per coach
*/
CREATE TABLE train_master_schema.seats (
    seat_id                 SERIAL        PRIMARY KEY,
    train_number            VARCHAR(5)    NOT NULL REFERENCES train_master_schema.trains(train_number) ON DELETE CASCADE,
    coach_class             VARCHAR(3)    NOT NULL REFERENCES train_master_schema.coach_types(coach_code),
    seat_number             VARCHAR(10)   NOT NULL,
    berth_type              VARCHAR(20)   CHECK (berth_type IN ('LOWER','MIDDLE','UPPER','SIDE_LOWER','SIDE_UPPER','WINDOW','AISLE')),
    is_active               BOOLEAN       NOT NULL DEFAULT TRUE,
    UNIQUE (train_number, coach_class, seat_number)
);

COMMENT ON TABLE train_master_schema.seats IS 'Individual seats per train per class';
COMMENT ON COLUMN train_master_schema.seats.seat_number IS 'Seat number like A1, B2, S5';
COMMENT ON COLUMN train_master_schema.seats.berth_type IS 'LOWER, MIDDLE, UPPER, SIDE_LOWER, SIDE_UPPER';

CREATE INDEX idx_seats_train ON train_master_schema.seats(train_number);
CREATE INDEX idx_seats_coach_class ON train_master_schema.seats(train_number, coach_class);