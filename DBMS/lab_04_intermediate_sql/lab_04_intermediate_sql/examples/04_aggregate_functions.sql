-- ============================================================
-- Lab 04 | Example 04: Aggregate Functions
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. COUNT
-- ─────────────────────────────────────────────

-- Count all products
SELECT COUNT(*) AS total_products FROM products;

-- Count products with descriptions (ignores NULL)
SELECT COUNT(description) AS products_with_desc FROM products;

-- Count unique categories used by products
SELECT COUNT(DISTINCT category_id) AS categories_used FROM products;

-- ─────────────────────────────────────────────
-- 2. SUM
-- ─────────────────────────────────────────────

-- Total stock across all products
SELECT SUM(stock) AS total_stock FROM products;

-- Total inventory value
SELECT SUM(price * stock) AS total_inventory_value FROM products;

-- Total revenue from all orders
SELECT SUM(quantity * unit_price) AS total_revenue FROM order_items;

-- ─────────────────────────────────────────────
-- 3. AVG
-- ─────────────────────────────────────────────

-- Average product price
SELECT ROUND(AVG(price), 2) AS avg_price FROM products;

-- Average order total
SELECT ROUND(AVG(total_amount), 2) AS avg_order_value FROM orders;

-- ─────────────────────────────────────────────
-- 4. MIN and MAX
-- ─────────────────────────────────────────────

-- Cheapest and most expensive products
SELECT 
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive,
    MAX(price) - MIN(price) AS price_range
FROM products;

-- Earliest and latest orders
SELECT 
    MIN(order_date) AS first_order,
    MAX(order_date) AS latest_order,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS days_span
FROM orders;

-- ─────────────────────────────────────────────
-- 5. Combining all aggregates
-- ─────────────────────────────────────────────

SELECT 
    COUNT(*) AS total_products,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price,
    SUM(stock) AS total_stock,
    ROUND(SUM(price * stock), 2) AS total_value
FROM products;

-- ─────────────────────────────────────────────
-- 6. Aggregates with WHERE
-- ─────────────────────────────────────────────

-- Average price of Electronics only
SELECT ROUND(AVG(price), 2) AS avg_electronics_price
FROM products WHERE category_id = 1;

-- Total value of delivered orders
SELECT SUM(total_amount) AS delivered_revenue
FROM orders WHERE status = 'delivered';

-- Count of pending orders
SELECT COUNT(*) AS pending_orders
FROM orders WHERE status = 'pending';
