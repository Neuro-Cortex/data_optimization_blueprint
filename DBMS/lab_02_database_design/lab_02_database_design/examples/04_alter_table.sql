-- ============================================================
-- Lab 02 | Example 04: ALTER TABLE Operations
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. ADD a new column
-- ─────────────────────────────────────────────
ALTER TABLE customers ADD COLUMN date_of_birth DATE;
ALTER TABLE customers ADD COLUMN loyalty_points INT DEFAULT 0;

DESCRIBE customers;

-- ─────────────────────────────────────────────
-- 2. MODIFY a column (change type/constraints)
-- ─────────────────────────────────────────────
-- Make phone wider
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20);

-- Make city NOT NULL with default
ALTER TABLE customers MODIFY COLUMN city VARCHAR(50) NOT NULL DEFAULT 'Dhaka';

DESCRIBE customers;

-- ─────────────────────────────────────────────
-- 3. RENAME a column
-- ─────────────────────────────────────────────
ALTER TABLE customers RENAME COLUMN address TO street_address;

DESCRIBE customers;

-- Rename it back
ALTER TABLE customers RENAME COLUMN street_address TO address;

-- ─────────────────────────────────────────────
-- 4. DROP a column
-- ─────────────────────────────────────────────
ALTER TABLE customers DROP COLUMN loyalty_points;
ALTER TABLE customers DROP COLUMN date_of_birth;

DESCRIBE customers;

-- ─────────────────────────────────────────────
-- 5. ADD a constraint after table creation
-- ─────────────────────────────────────────────

-- Add a CHECK constraint
ALTER TABLE products ADD CONSTRAINT chk_stock CHECK (stock >= 0);

-- Add a UNIQUE constraint
ALTER TABLE products ADD CONSTRAINT uq_product_name UNIQUE (name);

-- ─────────────────────────────────────────────
-- 6. DROP a constraint
-- ─────────────────────────────────────────────
ALTER TABLE products DROP CONSTRAINT uq_product_name;

-- ─────────────────────────────────────────────
-- 7. ADD an index (for performance)
-- ─────────────────────────────────────────────
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_customers_city ON customers(city);

-- View indexes
SHOW INDEX FROM products;
SHOW INDEX FROM customers;

-- Drop an index
DROP INDEX idx_products_price ON products;
DROP INDEX idx_customers_city ON customers;

-- ─────────────────────────────────────────────
-- 8. RENAME a table
-- ─────────────────────────────────────────────
ALTER TABLE categories RENAME TO product_categories;
SHOW TABLES;

-- Rename back
ALTER TABLE product_categories RENAME TO categories;
SHOW TABLES;
