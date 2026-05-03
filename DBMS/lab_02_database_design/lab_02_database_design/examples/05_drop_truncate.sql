-- ============================================================
-- Lab 02 | Example 05: DROP vs TRUNCATE vs DELETE
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- Setup: Create a demo table to experiment with
-- ─────────────────────────────────────────────
CREATE TABLE demo_data (
    id    INT AUTO_INCREMENT PRIMARY KEY,
    name  VARCHAR(50),
    value INT
);

INSERT INTO demo_data (name, value) VALUES
    ('Alpha', 100),
    ('Beta', 200),
    ('Gamma', 300),
    ('Delta', 400),
    ('Epsilon', 500);

SELECT * FROM demo_data;
-- 5 rows: id 1-5

-- ─────────────────────────────────────────────
-- 1. DELETE — removes specific rows (DML)
-- ─────────────────────────────────────────────

-- Delete specific rows with WHERE
DELETE FROM demo_data WHERE value < 300;
SELECT * FROM demo_data;
-- Remaining: Gamma(3), Delta(4), Epsilon(5)

-- AUTO_INCREMENT continues from where it left off:
INSERT INTO demo_data (name, value) VALUES ('Zeta', 600);
SELECT * FROM demo_data;
-- Zeta gets id = 6 (NOT 1)

-- DELETE all rows (without WHERE)
DELETE FROM demo_data;
SELECT * FROM demo_data;
-- 0 rows, but table structure still exists

-- AUTO_INCREMENT still continues:
INSERT INTO demo_data (name, value) VALUES ('New', 700);
SELECT * FROM demo_data;
-- id = 7 ← doesn't reset!

-- ─────────────────────────────────────────────
-- 2. TRUNCATE — removes ALL rows instantly (DDL)
-- ─────────────────────────────────────────────

TRUNCATE TABLE demo_data;
SELECT * FROM demo_data;
-- 0 rows

-- AUTO_INCREMENT RESETS:
INSERT INTO demo_data (name, value) VALUES ('Fresh Start', 100);
SELECT * FROM demo_data;
-- id = 1 ← reset!

-- Key differences from DELETE:
-- ✅ Much faster (doesn't log individual rows)
-- ✅ Resets AUTO_INCREMENT
-- ❌ Cannot use WHERE clause
-- ❌ Cannot be rolled back (in most cases)
-- ❌ Doesn't fire triggers

-- ─────────────────────────────────────────────
-- 3. DROP — removes the entire table (DDL)
-- ─────────────────────────────────────────────

DROP TABLE demo_data;

-- Table is GONE — structure AND data
-- SHOW TABLES; -- demo_data no longer listed

-- ❌ This would fail now:
-- SELECT * FROM demo_data;
-- Error: Table 'ecommerce_db.demo_data' doesn't exist

-- Use IF EXISTS to avoid errors:
DROP TABLE IF EXISTS demo_data;  -- No error even if table doesn't exist

-- ─────────────────────────────────────────────
-- 4. Summary comparison
-- ─────────────────────────────────────────────

-- | Feature              | DELETE          | TRUNCATE        | DROP           |
-- |----------------------|-----------------|-----------------|----------------|
-- | Type                 | DML             | DDL             | DDL            |
-- | Removes              | Specific rows   | All rows        | Table + data   |
-- | WHERE clause?        | ✅ Yes          | ❌ No           | ❌ No          |
-- | Table structure?     | Kept            | Kept            | Removed        |
-- | AUTO_INCREMENT?      | Not reset       | Reset           | N/A            |
-- | Speed                | Slower          | Very fast       | Fast           |
-- | Triggers fire?       | ✅ Yes          | ❌ No           | ❌ No          |
-- | Can ROLLBACK?        | ✅ Yes          | ❌ No           | ❌ No          |
-- | FK check?            | ✅ Yes          | ❌ Fails if FK  | ❌ Fails if FK |

-- ─────────────────────────────────────────────
-- 5. DROP order matters with Foreign Keys!
-- ─────────────────────────────────────────────

-- ❌ Can't drop categories if products references it:
-- DROP TABLE categories;
-- Error: Cannot drop table referenced by a foreign key

-- ✅ Must drop in reverse dependency order:
-- DROP TABLE order_items;   -- depends on orders, products
-- DROP TABLE orders;        -- depends on customers
-- DROP TABLE products;      -- depends on categories
-- DROP TABLE customers;
-- DROP TABLE categories;

-- Or drop all at once (MySQL handles order):
-- DROP TABLE IF EXISTS order_items, orders, products, customers, categories;
