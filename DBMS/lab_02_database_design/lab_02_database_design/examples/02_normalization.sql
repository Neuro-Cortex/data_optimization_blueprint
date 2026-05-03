-- ============================================================
-- Lab 02 | Example 02: Normalization (1NF → 2NF → 3NF)
-- ============================================================
-- Demonstrates normalization step-by-step with practical
-- examples using the E-Commerce domain.
-- ============================================================

USE ecommerce_db;

-- ═══════════════════════════════════════════════
-- UNNORMALIZED FORM (UNF) — The problem
-- ═══════════════════════════════════════════════

-- Imagine storing everything in ONE table:
CREATE TABLE bad_orders_unnormalized (
    order_id       INT,
    order_date     DATE,
    customer_name  VARCHAR(100),
    customer_email VARCHAR(150),
    customer_city  VARCHAR(50),
    products       VARCHAR(500),     -- "iPhone, AirPods, Case" ← MULTI-VALUED!
    quantities     VARCHAR(100),     -- "1, 2, 1" ← MULTI-VALUED!
    prices         VARCHAR(200)      -- "129999, 24999, 999" ← MULTI-VALUED!
);

-- Problems:
-- 1. Can't query "Find all orders containing iPhone" easily
-- 2. Can't calculate total per product
-- 3. Adding a product to an order means editing a string

-- ═══════════════════════════════════════════════
-- FIRST NORMAL FORM (1NF) — No multi-valued columns
-- ═══════════════════════════════════════════════

-- Rule: Each column contains ONLY atomic (single) values
-- Fix: One row per product in the order

CREATE TABLE bad_orders_1nf (
    order_id       INT,
    order_date     DATE,
    customer_name  VARCHAR(100),
    customer_email VARCHAR(150),
    customer_city  VARCHAR(50),
    product_name   VARCHAR(200),     -- Single value ✅
    quantity       INT,               -- Single value ✅
    price          DECIMAL(10,2),     -- Single value ✅
    PRIMARY KEY (order_id, product_name)  -- Composite key
);

INSERT INTO bad_orders_1nf VALUES
    (1, '2025-03-01', 'Rafiq Ahmed', 'rafiq@gmail.com', 'Dhaka', 'iPhone 15', 1, 129999.00),
    (1, '2025-03-01', 'Rafiq Ahmed', 'rafiq@gmail.com', 'Dhaka', 'AirPods Pro', 2, 24999.00),
    (1, '2025-03-01', 'Rafiq Ahmed', 'rafiq@gmail.com', 'Dhaka', 'Phone Case', 1, 999.00),
    (2, '2025-03-02', 'Nusrat Jahan', 'nusrat@gmail.com', 'Chittagong', 'Laptop', 1, 85000.00),
    (2, '2025-03-02', 'Nusrat Jahan', 'nusrat@gmail.com', 'Chittagong', 'Mouse', 1, 1500.00);

SELECT * FROM bad_orders_1nf;

-- Remaining problems:
-- customer_name, customer_email, customer_city are REPEATED
-- → Update anomaly: Changing Rafiq's email requires updating 3 rows
-- → product_name appears in the PK but price depends only on product_name (partial dependency)

-- ═══════════════════════════════════════════════
-- SECOND NORMAL FORM (2NF) — No partial dependencies
-- ═══════════════════════════════════════════════

-- Rule: Every non-key column depends on the ENTIRE primary key
-- Fix: Separate product info (depends only on product) from order info

CREATE TABLE products_2nf (
    product_id    INT AUTO_INCREMENT PRIMARY KEY,
    product_name  VARCHAR(200) NOT NULL,
    price         DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders_2nf (
    order_id       INT,
    order_date     DATE,
    customer_name  VARCHAR(100),
    customer_email VARCHAR(150),
    customer_city  VARCHAR(50),
    product_id     INT,
    quantity       INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (product_id) REFERENCES products_2nf(product_id)
);

INSERT INTO products_2nf (product_name, price) VALUES
    ('iPhone 15', 129999.00),
    ('AirPods Pro', 24999.00),
    ('Phone Case', 999.00),
    ('Laptop', 85000.00),
    ('Mouse', 1500.00);

INSERT INTO orders_2nf VALUES
    (1, '2025-03-01', 'Rafiq Ahmed', 'rafiq@gmail.com', 'Dhaka', 1, 1),
    (1, '2025-03-01', 'Rafiq Ahmed', 'rafiq@gmail.com', 'Dhaka', 2, 2),
    (1, '2025-03-01', 'Rafiq Ahmed', 'rafiq@gmail.com', 'Dhaka', 3, 1),
    (2, '2025-03-02', 'Nusrat Jahan', 'nusrat@gmail.com', 'Chittagong', 4, 1),
    (2, '2025-03-02', 'Nusrat Jahan', 'nusrat@gmail.com', 'Chittagong', 5, 1);

-- ✅ Price is now in products_2nf — no partial dependency
-- ❌ But: customer_email depends on customer_name, not on order_id
--    This is a TRANSITIVE dependency: order_id → customer_name → customer_email

-- ═══════════════════════════════════════════════
-- THIRD NORMAL FORM (3NF) — No transitive dependencies
-- ═══════════════════════════════════════════════

-- Rule: Non-key columns depend ONLY on the primary key, nothing else
-- Fix: Extract customer info into its own table

-- See the final schema in 01_erd_to_schema.sql — 
-- that IS the 3NF version! The tables we created there
-- (categories, customers, products, orders, order_items)
-- are all in 3NF.

-- ═══════════════════════════════════════════════
-- Summary comparison
-- ═══════════════════════════════════════════════

-- | Form | Tables | Redundancy | Problem Solved              |
-- |------|--------|------------|-----------------------------|
-- | UNF  | 1      | Extreme    | Nothing — it's a mess       |
-- | 1NF  | 1      | High       | Multi-valued columns        |
-- | 2NF  | 2      | Medium     | Partial dependencies        |
-- | 3NF  | 5      | Minimal    | Transitive dependencies     |

-- ─────────────────────────────────────────────
-- Cleanup demo tables
-- ─────────────────────────────────────────────
DROP TABLE IF EXISTS orders_2nf;
DROP TABLE IF EXISTS products_2nf;
DROP TABLE IF EXISTS bad_orders_1nf;
DROP TABLE IF EXISTS bad_orders_unnormalized;
