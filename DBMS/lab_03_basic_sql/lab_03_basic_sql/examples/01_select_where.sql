-- ============================================================
-- Lab 03 | Example 01: SELECT and WHERE Clause
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Basic SELECT
-- ─────────────────────────────────────────────

-- All columns, all rows
SELECT * FROM products;

-- Specific columns
SELECT name, price, stock FROM products;

-- Only names
SELECT name FROM products;

-- ─────────────────────────────────────────────
-- 2. WHERE — filtering rows
-- ─────────────────────────────────────────────

-- Exact match
SELECT name, price FROM products WHERE category_id = 1;

-- Not equal
SELECT name, price FROM products WHERE category_id <> 1;
-- Same as: WHERE category_id != 1

-- Greater than
SELECT name, price FROM products WHERE price > 10000;

-- Less than or equal
SELECT name, stock FROM products WHERE stock <= 30;

-- ─────────────────────────────────────────────
-- 3. AND — both conditions must be true
-- ─────────────────────────────────────────────

-- Electronics (category 1) with price over 50,000
SELECT name, price FROM products
WHERE category_id = 1 AND price > 50000;

-- Active products with stock > 0
SELECT name, stock, is_active FROM products
WHERE is_active = TRUE AND stock > 0;

-- ─────────────────────────────────────────────
-- 4. OR — at least one condition
-- ─────────────────────────────────────────────

-- Products from Electronics OR Sports
SELECT name, price, category_id FROM products
WHERE category_id = 1 OR category_id = 5;

-- Very cheap OR very expensive
SELECT name, price FROM products
WHERE price < 1000 OR price > 100000;

-- ─────────────────────────────────────────────
-- 5. NOT — negate a condition
-- ─────────────────────────────────────────────

-- Products NOT in Electronics
SELECT name, category_id FROM products
WHERE NOT category_id = 1;

-- Orders NOT pending
SELECT order_id, status FROM orders
WHERE NOT status = 'pending';

-- ─────────────────────────────────────────────
-- 6. Combining AND, OR with parentheses
-- ─────────────────────────────────────────────

-- ⚠️ WITHOUT parentheses — confusing!
-- AND binds tighter than OR, so:
-- category_id = 1 OR category_id = 3 AND price < 5000
-- is actually: category_id = 1 OR (category_id = 3 AND price < 5000)

-- ✅ WITH parentheses — clear!
SELECT name, price, category_id FROM products
WHERE (category_id = 1 OR category_id = 3) AND price < 30000;
