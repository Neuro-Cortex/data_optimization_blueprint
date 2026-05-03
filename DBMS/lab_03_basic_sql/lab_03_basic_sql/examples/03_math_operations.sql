-- ============================================================
-- Lab 03 | Example 03: Math Operations in SQL
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Arithmetic in SELECT
-- ─────────────────────────────────────────────

-- 20% discount
SELECT name, price, 
       price * 0.80 AS discounted_price
FROM products;

-- Price with 15% VAT
SELECT name, price, 
       ROUND(price * 1.15, 2) AS price_with_vat
FROM products;

-- Inventory value (price × stock)
SELECT name, price, stock,
       price * stock AS inventory_value
FROM products;

-- Profit margin (assuming 40% markup)
SELECT name, price,
       ROUND(price / 1.40, 2) AS cost_price,
       ROUND(price - (price / 1.40), 2) AS profit
FROM products;

-- ─────────────────────────────────────────────
-- 2. Math Functions
-- ─────────────────────────────────────────────

SELECT 
    ABS(-42)           AS absolute_value,     -- 42
    CEIL(4.1)          AS ceiling,            -- 5
    FLOOR(4.9)         AS floored,            -- 4
    ROUND(3.456, 2)    AS rounded_2dp,        -- 3.46
    ROUND(3.456, 0)    AS rounded_whole,      -- 3
    ROUND(1567, -2)    AS rounded_hundreds,   -- 1600
    MOD(17, 5)         AS modulo,             -- 2
    POWER(2, 10)       AS two_to_the_ten,     -- 1024
    SQRT(144)          AS square_root,        -- 12
    PI()               AS pi_value,           -- 3.141593
    GREATEST(10, 20, 5) AS biggest,           -- 20
    LEAST(10, 20, 5)   AS smallest;           -- 5

-- ─────────────────────────────────────────────
-- 3. Practical examples
-- ─────────────────────────────────────────────

-- Mark products as "low stock" if stock < 20
SELECT name, stock,
       CASE 
           WHEN stock < 20 THEN 'Low Stock ⚠️'
           WHEN stock < 50 THEN 'Medium'
           ELSE 'Well Stocked ✅'
       END AS stock_status
FROM products;

-- Round prices to nearest 100
SELECT name, price, 
       ROUND(price, -2) AS rounded_price
FROM products;

-- Calculate total order value
SELECT order_id, 
       SUM(quantity * unit_price) AS order_total
FROM order_items
GROUP BY order_id;
