-- ============================================================
-- Lab 04 | Example 05: GROUP BY and HAVING
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Basic GROUP BY
-- ─────────────────────────────────────────────

-- Products per category
SELECT category_id, COUNT(*) AS product_count
FROM products
GROUP BY category_id;

-- With category names (JOIN + GROUP BY)
SELECT c.name AS category, COUNT(*) AS product_count
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY product_count DESC;

-- Orders per customer
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id;

-- Orders per status
SELECT status, COUNT(*) AS count
FROM orders
GROUP BY status;

-- ─────────────────────────────────────────────
-- 2. GROUP BY with aggregate functions
-- ─────────────────────────────────────────────

-- Total stock per category
SELECT c.name, SUM(p.stock) AS total_stock
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name;

-- Average price per category
SELECT c.name, ROUND(AVG(p.price), 2) AS avg_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_price DESC;

-- Revenue per customer
SELECT CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       COUNT(o.order_id) AS orders,
       SUM(o.total_amount) AS total_spent,
       ROUND(AVG(o.total_amount), 2) AS avg_order
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id;

-- Revenue per month
SELECT YEAR(order_date) AS year,
       MONTH(order_date) AS month,
       COUNT(*) AS order_count,
       SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

-- ─────────────────────────────────────────────
-- 3. HAVING — filter groups
-- ─────────────────────────────────────────────

-- Categories with more than 2 products
SELECT c.name, COUNT(*) AS product_count
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
HAVING COUNT(*) > 2;

-- Customers who placed more than 1 order
SELECT CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       COUNT(*) AS order_count
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id
HAVING COUNT(*) > 1;

-- Categories where average price > 5000
SELECT c.name, ROUND(AVG(p.price), 2) AS avg_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
HAVING AVG(p.price) > 5000;

-- ─────────────────────────────────────────────
-- 4. WHERE + GROUP BY + HAVING together
-- ─────────────────────────────────────────────

-- Among active products, categories with avg price > 2000
SELECT c.name, COUNT(*) AS count, ROUND(AVG(p.price), 2) AS avg_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE          -- WHERE filters ROWS (before grouping)
GROUP BY c.name
HAVING AVG(p.price) > 2000        -- HAVING filters GROUPS (after grouping)
ORDER BY avg_price DESC;

-- Execution order:
-- 1. FROM + JOIN
-- 2. WHERE (filter rows)
-- 3. GROUP BY (group remaining rows)
-- 4. HAVING (filter groups)
-- 5. SELECT (choose columns)
-- 6. ORDER BY (sort)
-- 7. LIMIT (restrict output)
