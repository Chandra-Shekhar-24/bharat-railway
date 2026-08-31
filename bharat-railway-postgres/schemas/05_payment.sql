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