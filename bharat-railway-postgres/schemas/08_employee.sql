/*
=============================================================================
SCHEMA: employee_schema
DATABASE: bharat_railway_core
MODULE: Phase 2 - Employee Management (Basic)
AUTHOR: Chandra Shekhar Bansal (Network/DB Engineer)
APPROVED: Koushal Jha (PM)
VERSION: 1.0.0
ENGINE: PostgreSQL 15+
NOTE: Basic structure for future admin panel.
=============================================================================
*/

/*
Table: employees - Admin panel authorized employees
*/
CREATE TABLE employee_schema.employees (
    employee_id             SERIAL        PRIMARY KEY,
    employee_code           VARCHAR(20)   NOT NULL UNIQUE,
    first_name              VARCHAR(50)   NOT NULL,
    last_name               VARCHAR(50)   NOT NULL,
    email                   VARCHAR(100)  NOT NULL UNIQUE,
    mobile_number           VARCHAR(15)   NOT NULL UNIQUE,
    designation             VARCHAR(100)  NOT NULL,
    department              VARCHAR(30)   NOT NULL CHECK (department IN ('OPERATIONS','FINANCE','COMMERCIAL','IT','ADMINISTRATION','AUDIT')),
    zone                    VARCHAR(50)   NOT NULL,
    division                VARCHAR(50)   NOT NULL,
    reporting_manager_id    INTEGER       REFERENCES employee_schema.employees(employee_id),
    joining_date            DATE          NOT NULL DEFAULT CURRENT_DATE,
    employment_status       VARCHAR(20)   NOT NULL DEFAULT 'ACTIVE' CHECK (employment_status IN ('ACTIVE','SUSPENDED','RESIGNED','TERMINATED')),
    admin_access_status     VARCHAR(20)   NOT NULL DEFAULT 'ACTIVE' CHECK (admin_access_status IN ('ACTIVE','REVOKED','TEMP_LOCKED')),
    max_fare_change_percent DECIMAL(5,2)  NOT NULL DEFAULT 10.00,
    max_refund_approval     DECIMAL(10,2) NOT NULL DEFAULT 10000.00,
    last_login_at           TIMESTAMPTZ(3),
    last_login_ip           VARCHAR(45),
    login_attempts_failed   SMALLINT      NOT NULL DEFAULT 0,
    is_mfa_enabled          BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE employee_schema.employees IS 'Admin authorized employees';

CREATE INDEX idx_employees_department ON employee_schema.employees(department);
CREATE INDEX idx_employees_status ON employee_schema.employees(employment_status);

/*
Table: employee_roles - Role definitions
*/
CREATE TABLE employee_schema.employee_roles (
    role_id                 SERIAL        PRIMARY KEY,
    role_name               VARCHAR(50)   NOT NULL UNIQUE,
    role_code               VARCHAR(20)   NOT NULL UNIQUE,
    role_description        TEXT,
    role_level              SMALLINT      NOT NULL DEFAULT 5 CHECK (role_level > 0),
    department              VARCHAR(30)   NOT NULL,
    is_system_role          BOOLEAN       NOT NULL DEFAULT FALSE,
    is_station_scoped       BOOLEAN       NOT NULL DEFAULT FALSE,
    is_active               BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

COMMENT ON TABLE employee_schema.employee_roles IS 'Role definitions for RBAC';

/*
Table: employee_station_assignments - Station scope for employees
*/
CREATE TABLE employee_schema.employee_station_assignments (
    assignment_id           SERIAL        PRIMARY KEY,
    employee_id             INTEGER       NOT NULL REFERENCES employee_schema.employees(employee_id) ON DELETE CASCADE,
    station_code            VARCHAR(5)    NOT NULL REFERENCES train_master_schema.stations(station_code),
    is_primary_station      BOOLEAN       NOT NULL DEFAULT FALSE,
    assigned_at             TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    is_active               BOOLEAN       NOT NULL DEFAULT TRUE,
    UNIQUE (employee_id, station_code)
);

COMMENT ON TABLE employee_schema.employee_station_assignments IS 'Station assignments for station-scoped roles';

CREATE INDEX idx_assignments_employee ON employee_schema.employee_station_assignments(employee_id);
CREATE INDEX idx_assignments_station ON employee_schema.employee_station_assignments(station_code);