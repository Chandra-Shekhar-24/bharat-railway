/*
=============================================================================
SCHEMA: auth_schema
DATABASE: bharat_railway_core
MODULE: Phase 1 - Authentication, Session & Audit
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
=============================================================================
TABLE: auth_schema.user_sessions
Active session store. UUID v4 session_id from application layer.
last_activity_at for idle timeout. expires_at for absolute expiry.
CASCADE delete on user removal from identity_schema.users.
=============================================================================
*/

CREATE TABLE auth_schema.user_sessions (
    session_id           UUID                NOT NULL PRIMARY KEY,
    user_id              INTEGER             NOT NULL,
    ip_address           VARCHAR(45)         NOT NULL,
    user_agent           TEXT                NOT NULL,
    device_id            VARCHAR(255)        NULL,
    last_activity_at     TIMESTAMPTZ(3)      NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    login_time           TIMESTAMPTZ(3)      NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    expires_at           TIMESTAMPTZ(3)      NOT NULL,

    CONSTRAINT fk_user_sessions_user
        FOREIGN KEY (user_id) REFERENCES identity_schema.users(user_id)
        ON DELETE CASCADE
);

CREATE INDEX idx_user_sessions_lookup ON auth_schema.user_sessions (user_id, login_time DESC);
CREATE INDEX idx_user_sessions_ip ON auth_schema.user_sessions (ip_address);

COMMENT ON TABLE auth_schema.user_sessions IS 'Active passenger sessions';
COMMENT ON COLUMN auth_schema.user_sessions.session_id IS 'UUID v4 generated at application layer';
COMMENT ON COLUMN auth_schema.user_sessions.user_id IS 'FK to identity_schema.users';
COMMENT ON COLUMN auth_schema.user_sessions.ip_address IS 'Client IP for audit and hijacking detection';
COMMENT ON COLUMN auth_schema.user_sessions.user_agent IS 'Browser/client fingerprint';
COMMENT ON COLUMN auth_schema.user_sessions.device_id IS 'Mobile device fingerprint, NULL for web';
COMMENT ON COLUMN auth_schema.user_sessions.last_activity_at IS 'Updated per request, used for idle timeout';
COMMENT ON COLUMN auth_schema.user_sessions.login_time IS 'Initial session creation timestamp';
COMMENT ON COLUMN auth_schema.user_sessions.expires_at IS 'Absolute session expiry, forces re-auth';

/*
=============================================================================
TABLE: auth_schema.login_history
Immutable authentication audit log. BIGSERIAL for high-volume inserts.
Status: 0=failure, 1=success
failure_reason is NULL for successful logins.
=============================================================================
*/

CREATE TABLE auth_schema.login_history (
    log_id               BIGSERIAL           NOT NULL PRIMARY KEY,
    user_id              INTEGER             NOT NULL,
    ip_address           VARCHAR(45)         NOT NULL,
    user_agent           TEXT                NOT NULL,
    geo_location         VARCHAR(255)        NULL,
    login_method         VARCHAR(50)         NOT NULL,
    login_time           TIMESTAMPTZ(3)      NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    status               SMALLINT            NOT NULL CHECK (status IN (0, 1)),
    failure_reason       VARCHAR(100)        NULL,

    CONSTRAINT fk_login_history_user
        FOREIGN KEY (user_id) REFERENCES identity_schema.users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_login_history_method CHECK (
        login_method IN ('password','otp_sms','otp_email','social_google','social_facebook')
    )
);

CREATE INDEX idx_login_history_user ON auth_schema.login_history (user_id, login_time DESC);
CREATE INDEX idx_login_history_status ON auth_schema.login_history (status, login_time DESC);

COMMENT ON TABLE auth_schema.login_history IS 'Immutable authentication audit log';
COMMENT ON COLUMN auth_schema.login_history.log_id IS 'Auto-incrementing log entry ID';
COMMENT ON COLUMN auth_schema.login_history.user_id IS 'FK to identity_schema.users';
COMMENT ON COLUMN auth_schema.login_history.ip_address IS 'Client IP at login attempt';
COMMENT ON COLUMN auth_schema.login_history.user_agent IS 'Browser/client fingerprint';
COMMENT ON COLUMN auth_schema.login_history.geo_location IS 'GeoIP lookup result, NULL for internal network';
COMMENT ON COLUMN auth_schema.login_history.login_method IS 'password, otp_sms, otp_email, social_google, social_facebook';
COMMENT ON COLUMN auth_schema.login_history.login_time IS 'Login attempt timestamp';
COMMENT ON COLUMN auth_schema.login_history.status IS '0=failure, 1=success';
COMMENT ON COLUMN auth_schema.login_history.failure_reason IS 'Reason for failure, NULL if success';

/*
=============================================================================
TABLE: auth_schema.password_reset
Time-bound password reset tokens. Token stored as bcrypt hash.
is_used flag prevents token reuse after successful reset.
=============================================================================
*/

CREATE TABLE auth_schema.password_reset (
    reset_id             SERIAL              NOT NULL PRIMARY KEY,
    user_id              INTEGER             NOT NULL,
    token                VARCHAR(255)        NOT NULL,
    request_ip           VARCHAR(45)         NOT NULL,
    reset_channel        VARCHAR(50)         NOT NULL CHECK (reset_channel IN ('email','sms')),
    is_used              BOOLEAN             NOT NULL DEFAULT FALSE,
    created_at           TIMESTAMPTZ(3)      NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    expires_at           TIMESTAMPTZ(3)      NOT NULL,

    CONSTRAINT uq_password_reset_token UNIQUE (token),
    CONSTRAINT fk_password_reset_user
        FOREIGN KEY (user_id) REFERENCES identity_schema.users(user_id)
        ON DELETE CASCADE
);

CREATE INDEX idx_user_reset ON auth_schema.password_reset (user_id, expires_at);

COMMENT ON TABLE auth_schema.password_reset IS 'Time-bound password reset tokens';
COMMENT ON COLUMN auth_schema.password_reset.reset_id IS 'Auto-incrementing reset request ID';
COMMENT ON COLUMN auth_schema.password_reset.user_id IS 'FK to identity_schema.users';
COMMENT ON COLUMN auth_schema.password_reset.token IS 'Bcrypt hashed reset token';
COMMENT ON COLUMN auth_schema.password_reset.request_ip IS 'Source IP of reset request';
COMMENT ON COLUMN auth_schema.password_reset.reset_channel IS 'Delivery method: email or sms';
COMMENT ON COLUMN auth_schema.password_reset.is_used IS 'TRUE once token consumed, prevents reuse';
COMMENT ON COLUMN auth_schema.password_reset.created_at IS 'Token creation timestamp';
COMMENT ON COLUMN auth_schema.password_reset.expires_at IS 'Token expiry timestamp';

/*
=============================================================================
DUMMY / DEMO DATA
Sample login history for the demo passengers added in 01_identity.sql.
Purely additive - no schema/constraint changes.
=============================================================================
*/

INSERT INTO
    auth_schema.login_history (
        user_id, ip_address, user_agent, geo_location, login_method, status, failure_reason
    )
VALUES
    ((SELECT user_id FROM identity_schema.users WHERE username = 'sureshchatterjee03'), '103.67.30.202', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_sms', 0, 'OTP expired'),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'manojdesai19'), '103.19.38.13', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_sms', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'aaraviyer01'), '103.204.33.83', 'Mozilla/5.0 (Demo Client)', 'India', 'password', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'ananyapatel02'), '103.115.182.170', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_email', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'vihaangupta14'), '103.61.130.182', 'Mozilla/5.0 (Demo Client)', 'India', 'password', 0, 'Account locked'),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'karanchauhan13'), '103.70.183.163', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_email', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'neharao10'), '103.3.228.122', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_email', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'kabirmalhotra11'), '103.92.233.25', 'Mozilla/5.0 (Demo Client)', 'India', 'password', 0, 'OTP expired'),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'rohansharma20'), '103.86.39.225', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_sms', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'vivaanjoshi04'), '103.178.166.7', 'Mozilla/5.0 (Demo Client)', 'India', 'password', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'myrasingh09'), '103.199.29.15', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_email', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'snehabansal18'), '103.58.160.163', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_email', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'reyanshkapoor25'), '103.20.78.96', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_sms', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'poojanair08'), '103.191.36.26', 'Mozilla/5.0 (Demo Client)', 'India', 'password', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'arjunpatel22'), '103.192.140.243', 'Mozilla/5.0 (Demo Client)', 'India', 'password', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'aadhyaverma07'), '103.101.143.125', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_email', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'diyamehta12'), '103.7.65.144', 'Mozilla/5.0 (Demo Client)', 'India', 'password', 1, NULL),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'amitkumar16'), '103.166.13.101', 'Mozilla/5.0 (Demo Client)', 'India', 'otp_email', 1, NULL);

