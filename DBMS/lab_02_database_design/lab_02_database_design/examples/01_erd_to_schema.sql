-- ============================================================
-- Lab 02 | Example 01: ERD to SQL Schema
-- ============================================================
-- Translating the E-Commerce ERD into MySQL tables.
-- IMPORTANT: Create parent tables FIRST, child tables SECOND.
-- ============================================================

-- ─────────────────────────────────────────────
-- Setup
-- ─────────────────────────────────────────────
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

-- ─────────────────────────────────────────────
-- Step 1: Parent tables (no foreign key dependencies)
-- ─────────────────────────────────────────────

-- Categories — the simplest table, no FK
CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL UNIQUE,
    description   TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers — independent entity
CREATE TABLE customers (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    phone         VARCHAR(15),
    address       VARCHAR(255),
    city          VARCHAR(50) DEFAULT 'Dhaka',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────
-- Step 2: Child tables (depend on parent tables)
-- ─────────────────────────────────────────────

-- Products — depends on Categories
CREATE TABLE products (
    product_id    INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(200) NOT NULL,
    description   TEXT,
    price         DECIMAL(10,2) NOT NULL,
    stock         INT NOT NULL DEFAULT 0,
    is_active     BOOLEAN DEFAULT TRUE,
    category_id   INT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (price >= 0),
    CHECK (stock >= 0),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Orders — depends on Customers
CREATE TABLE orders (
    order_id      INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT NOT NULL,
    order_date    DATE NOT NULL DEFAULT (CURRENT_DATE),
    status        ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')
                  DEFAULT 'pending',
    total_amount  DECIMAL(12,2) DEFAULT 0.00,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ─────────────────────────────────────────────
-- Step 3: Junction/detail table (depends on multiple parents)
-- ─────────────────────────────────────────────

-- Order Items — depends on Orders AND Products
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL DEFAULT 1,
    unit_price    DECIMAL(10,2) NOT NULL,
    CHECK (quantity > 0),
    CHECK (unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ─────────────────────────────────────────────
-- Verify: show all tables
-- ─────────────────────────────────────────────
SHOW TABLES;

-- Expected output:
-- categories
-- customers
-- order_items
-- orders
-- products

-- Check structure of each:
DESCRIBE categories;
DESCRIBE products;
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
