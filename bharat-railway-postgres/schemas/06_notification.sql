/*
=============================================================================
SCHEMA: notification_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Notification Management
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
Table: notification_templates - Reusable message templates
*/
CREATE TABLE notification_schema.notification_templates (
    template_id             SERIAL        PRIMARY KEY,
    template_code           VARCHAR(50)   NOT NULL UNIQUE,
    template_name           VARCHAR(100)  NOT NULL,
    channel                 VARCHAR(10)   NOT NULL CHECK (channel IN ('EMAIL','SMS','PUSH')),
    subject                 VARCHAR(200),
    body                    TEXT          NOT NULL,
    is_active               BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE notification_schema.notification_templates IS 'Message templates';

CREATE INDEX idx_notification_templates_channel ON notification_schema.notification_templates(channel);

/*
Table: notification_logs - Audit log of sent notifications
*/
CREATE TABLE notification_schema.notification_logs (
    log_id                  SERIAL        PRIMARY KEY,
    user_id                 INTEGER       NOT NULL REFERENCES identity_schema.users(user_id),
    template_id             INTEGER       REFERENCES notification_schema.notification_templates(template_id),
    channel                 VARCHAR(10)   NOT NULL CHECK (channel IN ('EMAIL','SMS','PUSH')),
    recipient               VARCHAR(255)  NOT NULL,
    subject                 VARCHAR(200),
    body                    TEXT          NOT NULL,
    status                  VARCHAR(20)   NOT NULL DEFAULT 'SENT' CHECK (status IN ('SENT','DELIVERED','FAILED','READ')),
    booking_id              INTEGER       REFERENCES booking_schema.bookings(booking_id),
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE notification_schema.notification_logs IS 'Audit log of notifications';

CREATE INDEX idx_notification_logs_user ON notification_schema.notification_logs(user_id);
CREATE INDEX idx_notification_logs_status ON notification_schema.notification_logs(status);
CREATE INDEX idx_notification_logs_booking ON notification_schema.notification_logs(booking_id);