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

/*
=============================================================================
DUMMY / DEMO DATA
Added to give the app some sample passengers to browse and book with.
No schema, constraint, or business-logic changes - purely additive rows.
=============================================================================
*/

INSERT INTO
    identity_schema.users (
        full_name, username, email, mobile_number, password_hash,
        date_of_birth, gender, status, is_email_verified, is_mobile_verified
    )
VALUES
    ('Aarav Iyer', 'aaraviyer01', 'aaraviyer01@example.com', '9708720353', '$2b$12$PftcIAw5fGmCdi7SUB5lFkgkQz6NiMxiz38NBHZh6DdTSWj6hhs9z', '1986-02-23', 'O', 1, TRUE, TRUE),
    ('Ananya Patel', 'ananyapatel02', 'ananyapatel02@example.com', '9322886595', '$2b$12$X0hYlerKcnyYyzxf25SyBtOOt2SnYPpsUeB7pF42WH5p2zOLrQL9P', '2000-06-25', 'F', 1, TRUE, TRUE),
    ('Suresh Chatterjee', 'sureshchatterjee03', 'sureshchatterjee03@example.com', '9572503860', '$2b$12$vPR7lPkNOU1o1vygGatPUkWBmUTDGMNVVmbgtJ7zwI6KsU9XykChi', '1977-07-11', 'M', 1, TRUE, TRUE),
    ('Vivaan Joshi', 'vivaanjoshi04', 'vivaanjoshi04@example.com', '9579477785', '$2b$12$lpqJ3xZ6D33DkeoCauEuTJHNKzkKccvoUjBRzXhkrwImIROYfQSZj', '1989-07-18', 'O', 1, TRUE, TRUE),
    ('Rahul Kapoor', 'rahulkapoor05', 'rahulkapoor05@example.com', '9192887818', '$2b$12$k1SMVLvdvMllgE7TaxQgXoBX2eY2ZVxtcysj62YshAevLtuuZcYLH', '1967-09-21', 'F', 1, TRUE, TRUE),
    ('Ramesh Pillai', 'rameshpillai06', 'rameshpillai06@example.com', '9844781015', '$2b$12$zSWkzdoq0fa6Zi7Nd2lVj5cy9BkoADLwjTESgL4kD3kQkFX40eooR', '1966-05-24', 'F', 1, TRUE, TRUE),
    ('Aadhya Verma', 'aadhyaverma07', 'aadhyaverma07@example.com', '9524589972', '$2b$12$pVulXbcdldsq5pJsShvisqC6boLZxwtxHWbknMVeahBQ8wA2V4qSY', '1998-09-03', 'M', 1, TRUE, TRUE),
    ('Pooja Nair', 'poojanair08', 'poojanair08@example.com', '9393422594', '$2b$12$nug2MpBBbUexTrV3RA5t9LH2grWe5CE9fbIN1l2OJbXnP9aA6rZYQ', '1998-04-03', 'M', 1, TRUE, TRUE),
    ('Myra Singh', 'myrasingh09', 'myrasingh09@example.com', '9290307378', '$2b$12$UxfqGp9jqhUZpy3Ln9VtBFNCjuhFMLeIWJuWyXafCfm5WshTRkINf', '1991-02-10', 'M', 1, TRUE, TRUE),
    ('Neha Rao', 'neharao10', 'neharao10@example.com', '9219786082', '$2b$12$sucOpHvvcu4640YMLS7LIT0HbLvhcH7IZku7QTsPvmjkfy1HxN5q4', '1985-01-27', 'M', 1, TRUE, TRUE),
    ('Kabir Malhotra', 'kabirmalhotra11', 'kabirmalhotra11@example.com', '9935710677', '$2b$12$Q4wtohPr5zhP8i8PV6HHizIqAxZv3oOEsW9hYew775wT8eZS5BNVE', '1987-03-03', 'F', 1, TRUE, TRUE),
    ('Diya Mehta', 'diyamehta12', 'diyamehta12@example.com', '9871197329', '$2b$12$LjNlh1YCZbZYsMQJ06EiJRj5WJx0P7qFDeRSqLDIVbpkP70j1stwk', '1965-04-24', 'M', 1, TRUE, TRUE),
    ('Karan Chauhan', 'karanchauhan13', 'karanchauhan13@example.com', '9384691043', '$2b$12$HCTDtNuiMFIKXCFXyuAt8Rf8VXx8S7ofddNxTqvalINKNtTk5Dx07', '1988-03-01', 'M', 1, TRUE, TRUE),
    ('Vihaan Gupta', 'vihaangupta14', 'vihaangupta14@example.com', '9576726420', '$2b$12$GLsBCgc5PlvaB6ZThW5H659ahUinVbRdcml69nUlqvw4usOgKc22X', '1994-03-15', 'O', 1, TRUE, TRUE),
    ('Priya Reddy', 'priyareddy15', 'priyareddy15@example.com', '9529426592', '$2b$12$RDOWDEDpLu8bA5x4RkwKP7435qkZPZ7ePefmv181dipIkO1txEXkS', '1983-06-11', 'M', 1, TRUE, TRUE),
    ('Amit Kumar', 'amitkumar16', 'amitkumar16@example.com', '9941919051', '$2b$12$c9DdrvqtopAhLYkNQtxiM8WnAFr72BoUGS28WmISk9q0afafeeS5X', '1966-11-02', 'M', 1, TRUE, TRUE),
    ('Kavya Menon', 'kavyamenon17', 'kavyamenon17@example.com', '9978628149', '$2b$12$xclmC5vQOtcnmFtOLg1zncDhUmkAe41epZVHPBLMU8GiV8H5UUXLg', '1988-06-06', 'F', 1, TRUE, TRUE),
    ('Sneha Bansal', 'snehabansal18', 'snehabansal18@example.com', '9245118175', '$2b$12$L2GGzOXrlw4dLUUw6NDJCkxpPrLKTDJDOC1k5sbCbwVxhHIiV0LHm', '1969-11-03', 'M', 1, TRUE, TRUE),
    ('Manoj Desai', 'manojdesai19', 'manojdesai19@example.com', '9988660087', '$2b$12$g2sF4W2T9LC1KpuQb7WUR3moDcnYCp0dmfxHQjJ3YfeuEoFeyFD1X', '1966-09-04', 'F', 1, TRUE, TRUE),
    ('Rohan Sharma', 'rohansharma20', 'rohansharma20@example.com', '9454579427', '$2b$12$ukiozD2RvMcEQbQAdnfKMDleHyinx0UwdVNbmI42i3HmwpswW5Pj9', '2002-07-19', 'O', 1, TRUE, TRUE),
    ('Aditya Iyer', 'adityaiyer21', 'adityaiyer21@example.com', '9179201492', '$2b$12$4UFrcYcl15xcPJJKym1EjkWuDg9LTMjUjoo3SNbrDmB1tG35YPoYt', '2002-09-02', 'O', 1, TRUE, TRUE),
    ('Arjun Patel', 'arjunpatel22', 'arjunpatel22@example.com', '9100037675', '$2b$12$vA0WS01VeJk3VYHyu63jeOrGMBgF4Cji7QuF2AnZKElNHq9ENLkc2', '1973-07-17', 'M', 1, TRUE, TRUE),
    ('Anjali Chatterjee', 'anjalichatterjee23', 'anjalichatterjee23@example.com', '9469774449', '$2b$12$3NZRkEuYBh6cy2sS3KeXJJmoAkccXu7BSlnAUJ3oZudTeQc0ynJfK', '1997-08-17', 'M', 1, TRUE, TRUE),
    ('Ishaan Joshi', 'ishaanjoshi24', 'ishaanjoshi24@example.com', '9368237813', '$2b$12$hyBxVqE6LGTRIxJ5zPqGssmkfd7PmB0hkfCCdIKQLcdEotQRuZhhk', '1987-08-19', 'F', 1, TRUE, TRUE),
    ('Reyansh Kapoor', 'reyanshkapoor25', 'reyanshkapoor25@example.com', '9318942209', '$2b$12$aI1FSvsZVbvhmws43Mux2fzfMEIgvl6CelDtL5BKq1K9E4k3HhKta', '2000-04-22', 'O', 1, TRUE, TRUE)
ON CONFLICT (username) DO NOTHING;

