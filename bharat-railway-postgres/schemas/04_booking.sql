/*
=============================================================================
SCHEMA: booking_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Booking Management
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
Table: bookings - Main reservation record
*/
CREATE TABLE booking_schema.bookings (
    booking_id              SERIAL        PRIMARY KEY,
    pnr_number              VARCHAR(10)   NOT NULL UNIQUE,
    user_id                 INTEGER       NOT NULL REFERENCES identity_schema.users(user_id),
    train_number            VARCHAR(5)    NOT NULL REFERENCES train_master_schema.trains(train_number),
    source_station_code     VARCHAR(5)    NOT NULL REFERENCES train_master_schema.stations(station_code),
    destination_station_code VARCHAR(5)   NOT NULL REFERENCES train_master_schema.stations(station_code),
    journey_date            DATE          NOT NULL,
    booking_date            TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    total_fare              DECIMAL(10,2) NOT NULL DEFAULT 0,
    booking_status          VARCHAR(20)   NOT NULL DEFAULT 'PENDING' CHECK (booking_status IN ('PENDING','CONFIRMED','CANCELLED','FAILED')),
    payment_status          VARCHAR(20)   NOT NULL DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING','PAID','REFUNDED','FAILED')),
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    CONSTRAINT chk_booking_stations CHECK (source_station_code <> destination_station_code)
);

COMMENT ON TABLE booking_schema.bookings IS 'Main booking/reservation record';
COMMENT ON COLUMN booking_schema.bookings.pnr_number IS 'Unique 10-character PNR';

CREATE INDEX idx_bookings_user ON booking_schema.bookings(user_id);
CREATE INDEX idx_bookings_train ON booking_schema.bookings(train_number);
CREATE INDEX idx_bookings_journey_date ON booking_schema.bookings(journey_date);
CREATE INDEX idx_bookings_status ON booking_schema.bookings(booking_status);
CREATE INDEX idx_bookings_pnr ON booking_schema.bookings(pnr_number);

/*
Table: booking_passengers - Passenger details under booking
*/
CREATE TABLE booking_schema.booking_passengers (
    passenger_id            SERIAL        PRIMARY KEY,
    booking_id              INTEGER       NOT NULL REFERENCES booking_schema.bookings(booking_id) ON DELETE CASCADE,
    full_name               VARCHAR(100)  NOT NULL,
    age                     SMALLINT      NOT NULL CHECK (age > 0 AND age < 120),
    gender                  CHAR(1)       NOT NULL CHECK (gender IN ('M','F','O','N')),
    berth_preference        VARCHAR(20)   CHECK (berth_preference IN ('LOWER','MIDDLE','UPPER','SIDE_LOWER','SIDE_UPPER','NO_PREF')),
    seat_id                 INTEGER       REFERENCES train_master_schema.seats(seat_id),
    booking_status          VARCHAR(20)   NOT NULL DEFAULT 'CONFIRMED' CHECK (booking_status IN ('CONFIRMED','RAC','WAITLIST','CANCELLED')),
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE booking_schema.booking_passengers IS 'Passenger details per booking';
COMMENT ON COLUMN booking_schema.booking_passengers.seat_id IS 'Allocated seat if confirmed';

CREATE INDEX idx_booking_passengers_booking ON booking_schema.booking_passengers(booking_id);
CREATE INDEX idx_booking_passengers_seat ON booking_schema.booking_passengers(seat_id);

/*
Table: booking_seats - Mapping booking to allocated seats
*/
CREATE TABLE booking_schema.booking_seats (
    booking_id              INTEGER       NOT NULL REFERENCES booking_schema.bookings(booking_id) ON DELETE CASCADE,
    seat_id                 INTEGER       NOT NULL REFERENCES train_master_schema.seats(seat_id),
    passenger_id            INTEGER       REFERENCES booking_schema.booking_passengers(passenger_id),
    booked_price            DECIMAL(10,2) NOT NULL DEFAULT 0,
    seat_status             VARCHAR(20)   NOT NULL DEFAULT 'BOOKED' CHECK (seat_status IN ('BOOKED','AVAILABLE','BLOCKED','RAC')),
    PRIMARY KEY (booking_id, seat_id)
);

COMMENT ON TABLE booking_schema.booking_seats IS 'Seat allocation mapping';
COMMENT ON COLUMN booking_schema.booking_seats.seat_status IS 'BOOKED, AVAILABLE, BLOCKED, RAC';

CREATE INDEX idx_booking_seats_seat ON booking_schema.booking_seats(seat_id);