/*
=============================================================================
SCHEMA: audit_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Audit & Tracking
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
=============================================================================
*/

/*
Table: config_change_log - All configuration changes
*/
CREATE TABLE audit_schema.config_change_log (
    log_id                  SERIAL         PRIMARY KEY,
    employee_id             INTEGER        REFERENCES employee_schema.employees(employee_id),
    action_type             VARCHAR(20)    NOT NULL CHECK (action_type IN ('CREATE','UPDATE','DELETE','APPROVE','REJECT','REVERT','EXPORT','IMPORT')),
    schema_name             VARCHAR(50)    NOT NULL,
    table_name              VARCHAR(50)    NOT NULL,
    record_id               VARCHAR(100)   NOT NULL,
    field_name              VARCHAR(50),
    old_value               TEXT,
    new_value               TEXT,
    change_summary          TEXT,
    change_reason           TEXT           NOT NULL,
    ip_address              VARCHAR(45),
    change_impact           VARCHAR(20)    NOT NULL DEFAULT 'LOW' CHECK (change_impact IN ('LOW','MEDIUM','HIGH','CRITICAL')),
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE audit_schema.config_change_log IS 'Immutable configuration change log';

CREATE INDEX idx_config_log_schema_table ON audit_schema.config_change_log(schema_name, table_name);
CREATE INDEX idx_config_log_employee ON audit_schema.config_change_log(employee_id);
CREATE INDEX idx_config_log_timestamp ON audit_schema.config_change_log(created_at);

/*
Table: employee_action_log - Employee login and activity
*/
CREATE TABLE audit_schema.employee_action_log (
    action_id               SERIAL         PRIMARY KEY,
    employee_id             INTEGER        REFERENCES employee_schema.employees(employee_id),
    action_type             VARCHAR(30)    NOT NULL CHECK (action_type IN ('LOGIN','LOGOUT','FAILED_LOGIN','SESSION_TIMEOUT','PASSWORD_CHANGE','PERMISSION_DENIED','EXPORT_DATA','CONFIG_CHANGE')),
    action_timestamp        TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    session_id              VARCHAR(100),
    ip_address              VARCHAR(45),
    action_status           VARCHAR(20)    NOT NULL DEFAULT 'SUCCESS' CHECK (action_status IN ('SUCCESS','FAILURE','TERMINATED')),
    failure_reason          VARCHAR(200),
    is_suspicious           BOOLEAN         NOT NULL DEFAULT FALSE
);

COMMENT ON TABLE audit_schema.employee_action_log IS 'Employee security and activity log';

CREATE INDEX idx_action_log_employee ON audit_schema.employee_action_log(employee_id);
CREATE INDEX idx_action_log_timestamp ON audit_schema.employee_action_log(action_timestamp);
CREATE INDEX idx_action_log_suspicious ON audit_schema.employee_action_log(is_suspicious);

/*
Table: fare_change_approvals - Approval workflow for fare changes
*/
CREATE TABLE audit_schema.fare_change_approvals (
    approval_id             SERIAL         PRIMARY KEY,
    config_log_id           INTEGER        NOT NULL REFERENCES audit_schema.config_change_log(log_id),
    proposed_by             INTEGER        NOT NULL REFERENCES employee_schema.employees(employee_id),
    old_fare                DECIMAL(10,2)  NOT NULL,
    new_fare                DECIMAL(10,2)  NOT NULL,
    change_percentage       DECIMAL(5,2)   NOT NULL,
    approval_status         VARCHAR(20)    NOT NULL DEFAULT 'PENDING' CHECK (approval_status IN ('PENDING','APPROVED','REJECTED','ESCALATED')),
    proposed_at             TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    final_approved_by       INTEGER        REFERENCES employee_schema.employees(employee_id),
    final_approved_at       TIMESTAMPTZ(3),
    rejection_reason        TEXT
);

COMMENT ON TABLE audit_schema.fare_change_approvals IS 'Fare change approval workflow';

CREATE INDEX idx_fare_approvals_status ON audit_schema.fare_change_approvals(approval_status);