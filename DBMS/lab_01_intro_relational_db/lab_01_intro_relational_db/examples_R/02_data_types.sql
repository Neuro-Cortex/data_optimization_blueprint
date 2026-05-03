-- ============================================================
-- Lab 01 | Example 02: MySQL Data Types Reference
-- ============================================================
-- This file demonstrates the most commonly used MySQL data
-- types with practical examples.
-- ============================================================

USE shop_db;

-- ─────────────────────────────────────────────
-- 1. NUMERIC TYPES
-- ─────────────────────────────────────────────

CREATE TABLE numeric_examples (
    -- Integer types
    tiny_val      TINYINT,             -- -128 to 127 (1 byte)
    tiny_unsigned TINYINT UNSIGNED,    -- 0 to 255
    small_val     SMALLINT,            -- -32,768 to 32,767 (2 bytes)
    medium_val    MEDIUMINT,           -- ~-8M to ~8M (3 bytes)
    int_val       INT,                 -- ~-2.1B to ~2.1B (4 bytes)
    big_val       BIGINT,              -- Very large (8 bytes)
    
    -- Decimal types
    price         DECIMAL(10,2),       -- Exact: 12345678.99 (USE FOR MONEY!)
    gpa           DECIMAL(3,2),        -- Exact: 4.00
    
    -- Floating point (approximate — NOT for money!)
    temperature   FLOAT,               -- ~7 decimal digits precision
    measurement   DOUBLE,              -- ~15 decimal digits precision
    
    -- Boolean (actually TINYINT(1) in MySQL)
    is_active     BOOLEAN              -- TRUE (1) or FALSE (0)
);

-- ⚠️ Why DECIMAL for money?
-- FLOAT:   SELECT 0.1 + 0.2;  → 0.30000000000000004 (WRONG!)
-- DECIMAL: Exact arithmetic    → 0.30 (CORRECT!)

INSERT INTO numeric_examples (tiny_val, price, gpa, is_active)
VALUES (25, 1299.99, 3.75, TRUE);

SELECT * FROM numeric_examples;

DROP TABLE numeric_examples;

-- ─────────────────────────────────────────────
-- 2. STRING TYPES
-- ─────────────────────────────────────────────

CREATE TABLE string_examples (
    -- Fixed-length (always uses n bytes, padded with spaces)
    country_code  CHAR(2),             -- 'BD', 'US', 'UK'
    gender        CHAR(1),             -- 'M', 'F', 'O'
    
    -- Variable-length (uses only what's needed + 1-2 bytes)
    first_name    VARCHAR(50),         -- Up to 50 characters
    email         VARCHAR(150),        -- Up to 150 characters
    
    -- Text types (for long content)
    short_bio     TEXT,                -- Up to 65,535 characters
    article       MEDIUMTEXT,          -- Up to 16 MB
    
    -- Enum (predefined choices — stored as integers internally)
    status        ENUM('active', 'inactive', 'suspended'),
    
    -- Set (multiple choices allowed)
    interests     SET('sports', 'music', 'tech', 'art')
);

INSERT INTO string_examples (country_code, first_name, email, status, interests)
VALUES ('BD', 'Rafiq', 'rafiq@uiu.ac.bd', 'active', 'sports,tech');

SELECT * FROM string_examples;

DROP TABLE string_examples;

-- ─────────────────────────────────────────────
-- 3. DATE AND TIME TYPES
-- ─────────────────────────────────────────────

CREATE TABLE datetime_examples (
    -- Date only
    birth_date      DATE,              -- '2000-05-15'
    
    -- Time only
    class_time      TIME,              -- '14:30:00'
    
    -- Date + Time
    appointment     DATETIME,          -- '2025-03-03 14:30:00'
    
    -- Timestamp (auto-updates, timezone aware)
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
                    ON UPDATE CURRENT_TIMESTAMP,
    
    -- Year only
    graduation_year YEAR               -- 2025
);

INSERT INTO datetime_examples (birth_date, class_time, appointment, graduation_year)
VALUES ('2002-08-20', '10:00:00', '2025-03-03 14:30:00', 2025);

-- See how created_at was auto-filled:
SELECT * FROM datetime_examples;

-- Update a row — watch updated_at change:
UPDATE datetime_examples SET class_time = '11:00:00' WHERE birth_date = '2002-08-20';
SELECT * FROM datetime_examples;

DROP TABLE datetime_examples;

-- ─────────────────────────────────────────────
-- 4. CHOOSING THE RIGHT TYPE — Quick Reference
-- ─────────────────────────────────────────────

-- | Data              | Recommended Type      | Why                        |
-- |-------------------|-----------------------|----------------------------|
-- | Person's name     | VARCHAR(100)          | Variable length            |
-- | Email             | VARCHAR(150)          | Variable, needs UNIQUE     |
-- | Phone number      | VARCHAR(15)           | Contains + and dashes      |
-- | Price/Money       | DECIMAL(10,2)         | Exact arithmetic           |
-- | Age               | TINYINT UNSIGNED      | 0-255 is plenty            |
-- | Primary Key ID    | INT AUTO_INCREMENT    | Standard practice          |
-- | Yes/No flag       | BOOLEAN               | TRUE/FALSE                 |
-- | Status choices    | ENUM('a','b','c')     | Limited, predefined values |
-- | Long description  | TEXT                  | Can be very long           |
-- | Birthday          | DATE                  | No time needed             |
-- | Record created    | TIMESTAMP             | Auto-fills with NOW()      |
-- | Country code      | CHAR(2)               | Always 2 characters        |
