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

/*
=============================================================================
DUMMY / DEMO DATA
Sample bookings (with real PNRs) and their passengers, built on top of the
demo users (01_identity.sql) and real/demo trains already in
train_master_schema.trains. Source/destination pairs used here are actual
stops on each train's route. booking_seats / exact seat allocation is left
to the application layer, so passengers are inserted without a pinned
seat_id (the column is nullable) - purely additive, no logic changes.
=============================================================================
*/

INSERT INTO
    booking_schema.bookings (
        pnr_number, user_id, train_number, source_station_code,
        destination_station_code, journey_date, total_fare,
        booking_status, payment_status
    )
VALUES
    ('PNR1000001', (SELECT user_id FROM identity_schema.users WHERE username = 'ananyapatel02'), '16001', 'NDLS', 'BCT', '2026-10-18', 2400.00, 'PENDING', 'PENDING'),
    ('PNR1000002', (SELECT user_id FROM identity_schema.users WHERE username = 'sureshchatterjee03'), '16002', 'NDLS', 'BCT', '2026-12-07', 850.00, 'CONFIRMED', 'PAID'),
    ('PNR1000003', (SELECT user_id FROM identity_schema.users WHERE username = 'vivaanjoshi04'), '16011', 'NDLS', 'HWH', '2026-11-14', 3200.00, 'PENDING', 'PENDING'),
    ('PNR1000004', (SELECT user_id FROM identity_schema.users WHERE username = 'rahulkapoor05'), '16012', 'NDLS', 'HWH', '2026-09-08', 1850.00, 'PENDING', 'PENDING'),
    ('PNR1000005', (SELECT user_id FROM identity_schema.users WHERE username = 'rameshpillai06'), '16021', 'NDLS', 'MAS', '2026-09-04', 1850.00, 'CONFIRMED', 'PAID'),
    ('PNR1000006', (SELECT user_id FROM identity_schema.users WHERE username = 'aadhyaverma07'), '16031', 'NDLS', 'SBC', '2026-10-20', 2400.00, 'PENDING', 'PENDING'),
    ('PNR1000007', (SELECT user_id FROM identity_schema.users WHERE username = 'poojanair08'), '12952', 'NDLS', 'BCT', '2026-12-01', 3200.00, 'CONFIRMED', 'PAID'),
    ('PNR1000008', (SELECT user_id FROM identity_schema.users WHERE username = 'myrasingh09'), '12839', 'HWH', 'MAS', '2026-10-23', 850.00, 'CONFIRMED', 'PAID'),
    ('PNR1000009', (SELECT user_id FROM identity_schema.users WHERE username = 'neharao10'), '12627', 'SBC', 'NDLS', '2026-10-02', 3200.00, 'CONFIRMED', 'PAID'),
    ('PNR1000010', (SELECT user_id FROM identity_schema.users WHERE username = 'kabirmalhotra11'), '12304', 'NDLS', 'HWH', '2026-09-11', 4500.00, 'CONFIRMED', 'PAID'),
    ('PNR1000011', (SELECT user_id FROM identity_schema.users WHERE username = 'diyamehta12'), '12002', 'BPL', 'NDLS', '2026-11-14', 1200.00, 'PENDING', 'PENDING'),
    ('PNR1000012', (SELECT user_id FROM identity_schema.users WHERE username = 'karanchauhan13'), '12298', 'NDLS', 'PUNE', '2026-10-02', 4500.00, 'CONFIRMED', 'PAID'),
    ('PNR1000013', (SELECT user_id FROM identity_schema.users WHERE username = 'vihaangupta14'), '12957', 'ADI', 'NDLS', '2026-12-04', 4500.00, 'CONFIRMED', 'PAID'),
    ('PNR1000014', (SELECT user_id FROM identity_schema.users WHERE username = 'priyareddy15'), '12009', 'ADI', 'BCT', '2026-12-12', 1200.00, 'PENDING', 'PENDING'),
    ('PNR1000015', (SELECT user_id FROM identity_schema.users WHERE username = 'amitkumar16'), '22435', 'SVDK', 'NDLS', '2026-11-17', 2400.00, 'CONFIRMED', 'PAID')
ON CONFLICT (pnr_number) DO NOTHING;

INSERT INTO
    booking_schema.booking_passengers (
        booking_id, full_name, age, gender, berth_preference, seat_id, booking_status
    )
VALUES
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000001'), 'Arjun Nair', 41, 'F', 'NO_PREF', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000001'), 'Anjali Iyer', 62, 'M', 'SIDE_LOWER', NULL, 'RAC'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000001'), 'Manoj Iyer', 28, 'M', 'UPPER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000002'), 'Priya Singh', 57, 'M', 'NO_PREF', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000003'), 'Reyansh Patel', 55, 'F', 'LOWER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000003'), 'Vihaan Malhotra', 17, 'M', 'NO_PREF', NULL, 'WAITLIST'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000004'), 'Arjun Chauhan', 50, 'M', 'MIDDLE', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000004'), 'Myra Desai', 20, 'F', 'MIDDLE', NULL, 'RAC'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000004'), 'Aditya Joshi', 27, 'F', 'UPPER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000005'), 'Deepak Patel', 60, 'M', 'UPPER', NULL, 'WAITLIST'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000005'), 'Rahul Rao', 17, 'M', 'MIDDLE', NULL, 'RAC'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000005'), 'Vihaan Joshi', 33, 'F', 'LOWER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000006'), 'Ramesh Nair', 63, 'F', 'LOWER', NULL, 'WAITLIST'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000007'), 'Sneha Bansal', 9, 'M', 'UPPER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000008'), 'Saanvi Nair', 5, 'M', 'LOWER', NULL, 'RAC'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000008'), 'Ishaan Pillai', 6, 'F', 'LOWER', NULL, 'WAITLIST'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000009'), 'Saanvi Singh', 38, 'M', 'LOWER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000010'), 'Sneha Sharma', 51, 'M', 'LOWER', NULL, 'WAITLIST'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000011'), 'Isha Rao', 58, 'M', 'MIDDLE', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000011'), 'Aarav Sharma', 63, 'M', 'LOWER', NULL, 'WAITLIST'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000012'), 'Neha Kumar', 12, 'M', 'MIDDLE', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000012'), 'Riya Kumar', 49, 'M', 'LOWER', NULL, 'RAC'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000012'), 'Vivaan Gupta', 55, 'M', 'MIDDLE', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000013'), 'Ishaan Chatterjee', 20, 'M', 'UPPER', NULL, 'WAITLIST'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000013'), 'Myra Reddy', 61, 'M', 'LOWER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000014'), 'Reyansh Reddy', 25, 'F', 'SIDE_LOWER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000014'), 'Priya Kapoor', 41, 'F', 'UPPER', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000014'), 'Rohan Sharma', 27, 'F', 'NO_PREF', NULL, 'CONFIRMED'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000015'), 'Reyansh Iyer', 30, 'F', 'UPPER', NULL, 'RAC'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000015'), 'Karan Mehta', 10, 'F', 'UPPER', NULL, 'CONFIRMED');

