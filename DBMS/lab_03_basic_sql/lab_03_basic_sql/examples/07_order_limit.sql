-- ============================================================
-- Lab 03 | Example 07: ORDER BY, LIMIT, OFFSET
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. ORDER BY — sorting results
-- ─────────────────────────────────────────────

-- Ascending (default)
SELECT name, price FROM products ORDER BY price;
SELECT name, price FROM products ORDER BY price ASC;  -- same

-- Descending
SELECT name, price FROM products ORDER BY price DESC;

-- Alphabetical order
SELECT name FROM products ORDER BY name;

-- ─────────────────────────────────────────────
-- 2. Multi-column sorting
-- ─────────────────────────────────────────────

-- Sort by category first, then by price within each category
SELECT name, category_id, price FROM products
ORDER BY category_id ASC, price DESC;

-- Sort orders by status then by date
SELECT order_id, status, order_date FROM orders
ORDER BY status ASC, order_date DESC;

-- ─────────────────────────────────────────────
-- 3. ORDER BY with expressions
-- ─────────────────────────────────────────────

-- Sort by inventory value (calculated column)
SELECT name, price, stock, (price * stock) AS inventory_value
FROM products
ORDER BY inventory_value DESC;

-- Sort by column alias
SELECT name, price * 0.85 AS sale_price
FROM products
ORDER BY sale_price ASC;

-- Sort by column position (not recommended)
SELECT name, price FROM products ORDER BY 2 DESC;
-- 2 refers to the second column (price)

-- ─────────────────────────────────────────────
-- 4. LIMIT — restrict number of rows
-- ─────────────────────────────────────────────

-- Top 3 most expensive products
SELECT name, price FROM products
ORDER BY price DESC
LIMIT 3;

-- Cheapest 5 products
SELECT name, price FROM products
ORDER BY price ASC
LIMIT 5;

-- ─────────────────────────────────────────────
-- 5. OFFSET — skip rows (for pagination)
-- ─────────────────────────────────────────────

-- Page 1: first 3 products
SELECT name, price FROM products
ORDER BY price DESC
LIMIT 3 OFFSET 0;

-- Page 2: next 3 products (skip first 3)
SELECT name, price FROM products
ORDER BY price DESC
LIMIT 3 OFFSET 3;

-- Page 3: next 3 products (skip first 6)
SELECT name, price FROM products
ORDER BY price DESC
LIMIT 3 OFFSET 6;

-- Alternative syntax: LIMIT offset, count
SELECT name, price FROM products
ORDER BY price DESC
LIMIT 3, 3;  -- skip 3, take 3 (same as LIMIT 3 OFFSET 3)

-- ─────────────────────────────────────────────
-- 6. Common patterns
-- ─────────────────────────────────────────────

-- Most recent orders
SELECT order_id, order_date, status FROM orders
ORDER BY order_date DESC
LIMIT 5;

-- Single most expensive product
SELECT name, price FROM products
ORDER BY price DESC
LIMIT 1;

-- Second most expensive product
SELECT name, price FROM products
ORDER BY price DESC
LIMIT 1 OFFSET 1;

-- ⚠️ LIMIT without ORDER BY gives RANDOM results!
-- Don't do this:
-- SELECT * FROM products LIMIT 5;  -- which 5? undefined!
