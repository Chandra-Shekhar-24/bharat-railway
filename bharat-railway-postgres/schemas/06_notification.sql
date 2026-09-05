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

/*
=============================================================================
DUMMY / DEMO DATA
Sample notification templates and a few delivered notification logs tied
to the demo bookings, so the notification module isn't empty either.
=============================================================================
*/

INSERT INTO
    notification_schema.notification_templates (
        template_code, template_name, channel, subject, body, is_active
    )
VALUES
    ('BOOKING_CONFIRMED_EMAIL','Booking Confirmation Email','EMAIL','Your PNR {pnr} is confirmed','Dear {name}, your booking with PNR {pnr} on train {train} is confirmed. Have a safe journey!',TRUE),
    ('BOOKING_CONFIRMED_SMS','Booking Confirmation SMS','SMS',NULL,'IRCTC: PNR {pnr} CONFIRMED on {train}. Safe travels!',TRUE),
    ('PAYMENT_SUCCESS_EMAIL','Payment Success Email','EMAIL','Payment received for PNR {pnr}','Dear {name}, we have received your payment of Rs.{amount} for PNR {pnr}.',TRUE),
    ('OTP_LOGIN_SMS','Login OTP SMS','SMS',NULL,'Your OTP for login is {otp}. Valid for 10 minutes. Do not share this OTP.',TRUE),
    ('CANCELLATION_EMAIL','Cancellation Confirmation Email','EMAIL','Your PNR {pnr} has been cancelled','Dear {name}, your booking PNR {pnr} has been cancelled. Refund of Rs.{amount} will be processed within 5-7 days.',TRUE),
    ('WAITLIST_UPDATE_PUSH','Waitlist Status Update','PUSH',NULL,'Your waitlisted ticket for PNR {pnr} has moved to position {position}.',TRUE)
ON CONFLICT (template_code) DO NOTHING;

INSERT INTO
    notification_schema.notification_logs (
        user_id, template_id, channel, recipient, subject, body, status, booking_id
    )
VALUES
    ((SELECT user_id FROM identity_schema.users WHERE username = 'ananyapatel02'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'BOOKING_CONFIRMED_SMS'), 'SMS', '9933457495', NULL, 'Notification for PNR PNR1000001 on train 16001', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000001')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'sureshchatterjee03'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'PAYMENT_SUCCESS_EMAIL'), 'EMAIL', 'sureshchatterjee03@example.com', NULL, 'Notification for PNR PNR1000002 on train 16002', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000002')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'vivaanjoshi04'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'BOOKING_CONFIRMED_EMAIL'), 'EMAIL', 'vivaanjoshi04@example.com', NULL, 'Notification for PNR PNR1000003 on train 16011', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000003')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'rahulkapoor05'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'BOOKING_CONFIRMED_SMS'), 'SMS', '9657632238', NULL, 'Notification for PNR PNR1000004 on train 16012', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000004')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'rameshpillai06'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'PAYMENT_SUCCESS_EMAIL'), 'EMAIL', 'rameshpillai06@example.com', NULL, 'Notification for PNR PNR1000005 on train 16021', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000005')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'aadhyaverma07'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'BOOKING_CONFIRMED_EMAIL'), 'EMAIL', 'aadhyaverma07@example.com', NULL, 'Notification for PNR PNR1000006 on train 16031', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000006')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'poojanair08'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'BOOKING_CONFIRMED_SMS'), 'SMS', '9791944808', NULL, 'Notification for PNR PNR1000007 on train 12952', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000007')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'myrasingh09'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'PAYMENT_SUCCESS_EMAIL'), 'EMAIL', 'myrasingh09@example.com', NULL, 'Notification for PNR PNR1000008 on train 12839', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000008')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'neharao10'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'BOOKING_CONFIRMED_EMAIL'), 'EMAIL', 'neharao10@example.com', NULL, 'Notification for PNR PNR1000009 on train 12627', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000009')),
    ((SELECT user_id FROM identity_schema.users WHERE username = 'kabirmalhotra11'), (SELECT template_id FROM notification_schema.notification_templates WHERE template_code = 'BOOKING_CONFIRMED_SMS'), 'SMS', '9580954022', NULL, 'Notification for PNR PNR1000010 on train 12304', 'DELIVERED', (SELECT booking_id FROM booking_schema.bookings WHERE pnr_number = 'PNR1000010'));

