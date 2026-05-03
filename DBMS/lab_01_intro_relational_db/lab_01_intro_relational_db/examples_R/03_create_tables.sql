-- ============================================================
-- Lab 01 | Example 03: Creating Tables with Constraints
-- ============================================================
-- This file demonstrates CREATE TABLE with all common
-- constraints: NOT NULL, DEFAULT, UNIQUE, PRIMARY KEY,
-- AUTO_INCREMENT, CHECK, and FOREIGN KEY.
-- ============================================================

DROP DATABASE IF EXISTS shop_db;
CREATE DATABASE shop_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shop_db;

-- ─────────────────────────────────────────────
-- 1. Simple table — Categories
-- ─────────────────────────────────────────────
CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL UNIQUE,
    description   TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- What each constraint does:
-- AUTO_INCREMENT  → MySQL generates 1, 2, 3, ... automatically
-- PRIMARY KEY     → Unique identifier, cannot be NULL
-- NOT NULL        → This column must have a value
-- UNIQUE          → No two rows can have the same value
-- DEFAULT         → Uses this value if none is provided

-- ─────────────────────────────────────────────
-- 2. Table with more constraints — Products
-- ─────────────────────────────────────────────
CREATE TABLE products (
    product_id    INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(200) NOT NULL,
    description   TEXT,
    price         DECIMAL(10,2) NOT NULL,
    stock         INT NOT NULL DEFAULT 0,
    weight_kg     DECIMAL(5,2),
    category_id   INT,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
                  ON UPDATE CURRENT_TIMESTAMP,
    
    -- Table-level constraints
    CHECK (price >= 0),
    CHECK (stock >= 0),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- ─────────────────────────────────────────────
-- 3. Table with ENUM and composite UNIQUE — Customers
-- ─────────────────────────────────────────────
CREATE TABLE customers (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    phone         VARCHAR(15),
    address       VARCHAR(255),
    city          VARCHAR(50) DEFAULT 'Dhaka',
    gender        ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────
-- 4. Viewing table structure
-- ─────────────────────────────────────────────

-- List all tables in current database
SHOW TABLES;

-- Show column details
DESCRIBE products;

-- Alternative way to see columns
SHOW COLUMNS FROM products;

-- See the full CREATE TABLE statement (useful for copying)
SHOW CREATE TABLE products;

-- ─────────────────────────────────────────────
-- 5. Understanding PRIMARY KEY vs UNIQUE
-- ─────────────────────────────────────────────

-- | Feature          | PRIMARY KEY       | UNIQUE            |
-- |------------------|-------------------|-------------------|
-- | NULL allowed?    | ❌ Never          | ✅ Yes (one NULL) |
-- | Per table?       | Only ONE          | Multiple allowed  |
-- | Index created?   | Clustered         | Non-clustered     |
-- | Purpose          | Row identifier    | Prevent duplicates|
