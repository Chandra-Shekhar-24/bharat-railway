/*
=============================================================================
SCHEMA: payment_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Payment Management
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
Table: payment_transactions - One record per payment attempt
*/
CREATE TABLE payment_schema.payment_transactions (
    transaction_id          SERIAL        PRIMARY KEY,
    booking_id              INTEGER       NOT NULL REFERENCES booking_schema.bookings(booking_id) ON DELETE CASCADE,
    user_id                 INTEGER       NOT NULL REFERENCES identity_schema.users(user_id),
    amount                  DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_method          VARCHAR(20)   NOT NULL CHECK (payment_method IN ('UPI','CREDIT_CARD','DEBIT_CARD','NET_BANKING','WALLET')),
    transaction_status      VARCHAR(20)   NOT NULL DEFAULT 'PENDING' CHECK (transaction_status IN ('PENDING','SUCCESS','FAILED','REFUNDED')),
    gateway_reference       VARCHAR(100),
    payment_gateway         VARCHAR(50),
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE payment_schema.payment_transactions IS 'Payment transaction records';

CREATE INDEX idx_payments_booking ON payment_schema.payment_transactions(booking_id);
CREATE INDEX idx_payments_user ON payment_schema.payment_transactions(user_id);
CREATE INDEX idx_payments_status ON payment_schema.payment_transactions(transaction_status);

/*
Table: refunds - Refund requests
*/
CREATE TABLE payment_schema.refunds (
    refund_id               SERIAL        PRIMARY KEY,
    transaction_id          INTEGER       NOT NULL REFERENCES payment_schema.payment_transactions(transaction_id) ON DELETE CASCADE,
    refund_amount           DECIMAL(10,2) NOT NULL CHECK (refund_amount > 0),
    refund_reason           VARCHAR(200),
    refund_status           VARCHAR(20)   NOT NULL DEFAULT 'PENDING' CHECK (refund_status IN ('PENDING','PROCESSED','FAILED')),
    requested_by            INTEGER       NOT NULL REFERENCES identity_schema.users(user_id),
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    processed_at            TIMESTAMPTZ(3)
);

COMMENT ON TABLE payment_schema.refunds IS 'Refund requests';

CREATE INDEX idx_refunds_transaction ON payment_schema.refunds(transaction_id);
CREATE INDEX idx_refunds_status ON payment_schema.refunds(refund_status);

/*
=============================================================================
DUMMY / DEMO DATA
Payment transactions for the sample bookings added in 04_booking.sql,
looked up by pnr_number so no hard-coded/guessed IDs are used.
=============================================================================
*/

INSERT INTO
    payment_schema.payment_transactions (
        booking_id, user_id, amount, payment_method, transaction_status,
        gateway_reference, payment_gateway
    )
VALUES
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000001'), (SELECT user_id FROM identity_schema.users WHERE username = 'ananyapatel02'), 1850.00, 'NET_BANKING', 'SUCCESS', 'GW821227', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000002'), (SELECT user_id FROM identity_schema.users WHERE username = 'sureshchatterjee03'), 1200.00, 'NET_BANKING', 'SUCCESS', 'GW573566', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000003'), (SELECT user_id FROM identity_schema.users WHERE username = 'vivaanjoshi04'), 1200.00, 'NET_BANKING', 'SUCCESS', 'GW188136', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000004'), (SELECT user_id FROM identity_schema.users WHERE username = 'rahulkapoor05'), 1850.00, 'NET_BANKING', 'PENDING', 'GW597497', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000005'), (SELECT user_id FROM identity_schema.users WHERE username = 'rameshpillai06'), 1200.00, 'UPI', 'PENDING', 'GW895499', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000006'), (SELECT user_id FROM identity_schema.users WHERE username = 'aadhyaverma07'), 1200.00, 'CREDIT_CARD', 'SUCCESS', 'GW763129', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000007'), (SELECT user_id FROM identity_schema.users WHERE username = 'poojanair08'), 1850.00, 'CREDIT_CARD', 'SUCCESS', 'GW557756', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000008'), (SELECT user_id FROM identity_schema.users WHERE username = 'myrasingh09'), 2400.00, 'CREDIT_CARD', 'SUCCESS', 'GW160244', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000009'), (SELECT user_id FROM identity_schema.users WHERE username = 'neharao10'), 3200.00, 'CREDIT_CARD', 'SUCCESS', 'GW922444', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000010'), (SELECT user_id FROM identity_schema.users WHERE username = 'kabirmalhotra11'), 3200.00, 'UPI', 'SUCCESS', 'GW280059', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000011'), (SELECT user_id FROM identity_schema.users WHERE username = 'diyamehta12'), 4500.00, 'NET_BANKING', 'PENDING', 'GW114472', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000012'), (SELECT user_id FROM identity_schema.users WHERE username = 'karanchauhan13'), 4500.00, 'UPI', 'SUCCESS', 'GW204686', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000013'), (SELECT user_id FROM identity_schema.users WHERE username = 'vihaangupta14'), 3200.00, 'UPI', 'SUCCESS', 'GW981236', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000014'), (SELECT user_id FROM identity_schema.users WHERE username = 'priyareddy15'), 2400.00, 'UPI', 'SUCCESS', 'GW627169', 'Razorpay'),
    ((SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000015'), (SELECT user_id FROM identity_schema.users WHERE username = 'amitkumar16'), 4500.00, 'UPI', 'SUCCESS', 'GW764520', 'Razorpay');

