/*
=============================================================================
SCHEMA: financial_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Financial Accounting
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
Table: transaction_ledger - Every financial transaction
*/
CREATE TABLE financial_schema.transaction_ledger (
    transaction_id          SERIAL         PRIMARY KEY,
    transaction_number      VARCHAR(30)    NOT NULL UNIQUE,
    pnr_number              VARCHAR(10),
    booking_id              INTEGER        REFERENCES booking_schema.bookings(booking_id),
    transaction_type        VARCHAR(30)    NOT NULL CHECK (transaction_type IN ('BOOKING','REFUND','CANCELLATION','MODIFICATION','AGENT_COMMISSION','GATEWAY_FEE','CONVENIENCE_FEE','CHARGEBACK','MANUAL_ADJUSTMENT')),
    transaction_date        DATE           NOT NULL DEFAULT CURRENT_DATE,
    transaction_timestamp   TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    financial_year          VARCHAR(7)     NOT NULL,
    accounting_period       VARCHAR(6)     NOT NULL,
    debit_account_code      VARCHAR(20)    NOT NULL,
    credit_account_code     VARCHAR(20)    NOT NULL,
    transaction_amount      DECIMAL(12,2)  NOT NULL CHECK (transaction_amount > 0),
    payment_method          VARCHAR(20)    NOT NULL CHECK (payment_method IN ('UPI','CREDIT_CARD','DEBIT_CARD','NET_BANKING','WALLET','CASH')),
    payment_status          VARCHAR(20)    NOT NULL DEFAULT 'SUCCESS' CHECK (payment_status IN ('PENDING','SUCCESS','FAILED','REFUNDED')),
    customer_id             INTEGER        REFERENCES identity_schema.users(user_id),
    narration               TEXT,
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE financial_schema.transaction_ledger IS 'General ledger for all financial transactions';

CREATE INDEX idx_ledger_date ON financial_schema.transaction_ledger(transaction_date);
CREATE INDEX idx_ledger_pnr ON financial_schema.transaction_ledger(pnr_number);
CREATE INDEX idx_ledger_booking ON financial_schema.transaction_ledger(booking_id);

/*
Table: refund_approval_rules - Financial controls for refunds
*/
CREATE TABLE financial_schema.refund_approval_rules (
    rule_id                 SERIAL         PRIMARY KEY,
    rule_name               VARCHAR(100)   NOT NULL,
    refund_scenario         VARCHAR(30)    NOT NULL CHECK (refund_scenario IN ('USER_CANCELLATION','TRAIN_CANCELLATION','DUPLICATE_BOOKING','MEDICAL_EMERGENCY','CHARGEBACK','SYSTEM_ERROR')),
    refund_amount_min       DECIMAL(10,2)  NOT NULL DEFAULT 0,
    refund_amount_max       DECIMAL(10,2)  NOT NULL,
    approval_level          SMALLINT       NOT NULL DEFAULT 1,
    auto_approve            BOOLEAN        NOT NULL DEFAULT FALSE,
    requires_documentation  BOOLEAN        NOT NULL DEFAULT FALSE,
    processing_time_hours   SMALLINT       NOT NULL DEFAULT 24,
    is_active               BOOLEAN        NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE financial_schema.refund_approval_rules IS 'Refund approval thresholds';

/*
Table: bank_reconciliation - Daily settlement matching
*/
CREATE TABLE financial_schema.bank_reconciliation (
    reconciliation_id       SERIAL         PRIMARY KEY,
    reconciliation_date     DATE           NOT NULL,
    bank_account_code       VARCHAR(20)    NOT NULL,
    opening_balance_book    DECIMAL(15,2)  NOT NULL DEFAULT 0,
    closing_balance_book    DECIMAL(15,2)  NOT NULL DEFAULT 0,
    opening_balance_bank    DECIMAL(15,2)  NOT NULL DEFAULT 0,
    closing_balance_bank    DECIMAL(15,2)  NOT NULL DEFAULT 0,
    unreconciled_amount     DECIMAL(15,2)  NOT NULL DEFAULT 0,
    reconciliation_status   VARCHAR(20)    NOT NULL DEFAULT 'PENDING' CHECK (reconciliation_status IN ('PENDING','MATCHED','DISCREPANCY','RESOLVED')),
    resolved_at             TIMESTAMPTZ(3),
    UNIQUE (reconciliation_date, bank_account_code)
);

COMMENT ON TABLE financial_schema.bank_reconciliation IS 'Daily bank settlement reconciliation';

CREATE INDEX idx_reconciliation_date ON financial_schema.bank_reconciliation(reconciliation_date);