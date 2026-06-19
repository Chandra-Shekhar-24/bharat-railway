/*
=============================================================================
SCHEMA: identity_schema
DATABASE: bharat_railway_core
MODULE: Phase 1 - Passenger Identity
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
=============================================================================
TABLE: identity_schema.users
Core passenger identity store.
Status: 0=inactive, 1=active, 2=suspended
Gender: M=Male, F=Female, O=Other, N=Prefer not to say
=============================================================================
*/

-- Trigger function for updated_at
CREATE OR REPLACE FUNCTION identity_schema.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP(3);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE identity_schema.users (
    user_id               SERIAL PRIMARY KEY,
    full_name             VARCHAR(100)        NOT NULL,
    username              VARCHAR(50)         NOT NULL,
    email                 VARCHAR(255)        NOT NULL,
    mobile_number         VARCHAR(15)         NOT NULL,
    password_hash         VARCHAR(255)        NOT NULL,
    date_of_birth         DATE                NOT NULL,
    gender                CHAR(1)             NOT NULL CHECK (gender IN ('M','F','O','N')),
    status                SMALLINT            NOT NULL DEFAULT 1 CHECK (status IN (0, 1, 2)),
    failed_login_attempts SMALLINT            NOT NULL DEFAULT 0,
    account_locked_until  TIMESTAMPTZ(3)      NULL,
    is_email_verified     BOOLEAN             NOT NULL DEFAULT FALSE,
    is_mobile_verified    BOOLEAN             NOT NULL DEFAULT FALSE,
    created_at            TIMESTAMPTZ(3)      NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at            TIMESTAMPTZ(3)      NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

-- Unique Indexes
CREATE UNIQUE INDEX uq_users_username ON identity_schema.users (username);
CREATE UNIQUE INDEX uq_users_email ON identity_schema.users (email);
CREATE UNIQUE INDEX uq_users_mobile_number ON identity_schema.users (mobile_number);

-- Trigger for updated_at
CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON identity_schema.users
    FOR EACH ROW
    EXECUTE FUNCTION identity_schema.update_updated_at_column();

-- Column Comments
COMMENT ON TABLE identity_schema.users IS 'Core passenger identity for booking system';
COMMENT ON COLUMN identity_schema.users.user_id IS 'Auto-incrementing primary key';
COMMENT ON COLUMN identity_schema.users.full_name IS 'Passenger full name as per government ID';
COMMENT ON COLUMN identity_schema.users.username IS 'Unique login handle';
COMMENT ON COLUMN identity_schema.users.email IS 'Unique email for login and notifications';
COMMENT ON COLUMN identity_schema.users.mobile_number IS 'Unique mobile in E.164 format for SMS OTP';
COMMENT ON COLUMN identity_schema.users.password_hash IS 'Bcrypt/Argon2 hashed password';
COMMENT ON COLUMN identity_schema.users.date_of_birth IS 'Date of birth for age validation';
COMMENT ON COLUMN identity_schema.users.gender IS 'M=Male, F=Female, O=Other, N=Prefer not to say';
COMMENT ON COLUMN identity_schema.users.status IS '0=inactive, 1=active, 2=suspended';
COMMENT ON COLUMN identity_schema.users.failed_login_attempts IS 'Consecutive failed login count, reset on success';
COMMENT ON COLUMN identity_schema.users.account_locked_until IS 'NULL if not locked, else timestamp until lock expires';
COMMENT ON COLUMN identity_schema.users.is_email_verified IS 'TRUE if email ownership verified';
COMMENT ON COLUMN identity_schema.users.is_mobile_verified IS 'TRUE if mobile ownership verified via OTP';
COMMENT ON COLUMN identity_schema.users.created_at IS 'Account creation timestamp (UTC)';
COMMENT ON COLUMN identity_schema.users.updated_at IS 'Last update timestamp, auto-set by trigger';