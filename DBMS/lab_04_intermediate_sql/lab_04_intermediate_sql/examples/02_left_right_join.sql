-- ============================================================
-- Lab 04 | Example 02: LEFT JOIN and RIGHT JOIN
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. LEFT JOIN — all from left, matching from right
-- ─────────────────────────────────────────────

-- ALL products, even those without a category
SELECT p.name, p.price, c.name AS category
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;
-- Products with NULL category_id show NULL for category name

-- Find products WITHOUT a category (orphaned)
SELECT p.name, p.price
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

-- ALL customers, even those without orders
SELECT cu.first_name, cu.last_name, o.order_id, o.order_date
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id;

-- Find customers who have NEVER ordered
SELECT cu.first_name, cu.last_name, cu.email
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- ─────────────────────────────────────────────
-- 2. RIGHT JOIN — all from right, matching from left
-- ─────────────────────────────────────────────

-- ALL categories, even those without products
SELECT c.name AS category, p.name AS product, p.price
FROM products p
RIGHT JOIN categories c ON p.category_id = c.category_id;

-- Find empty categories (no products)
SELECT c.name AS empty_category
FROM products p
RIGHT JOIN categories c ON p.category_id = c.category_id
WHERE p.product_id IS NULL;

-- ─────────────────────────────────────────────
-- 3. LEFT JOIN vs INNER JOIN comparison
-- ─────────────────────────────────────────────

-- INNER JOIN: only products WITH categories
SELECT COUNT(*) AS inner_count
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;

-- LEFT JOIN: ALL products (including those without categories)
SELECT COUNT(*) AS left_count
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;

-- The difference shows orphaned products!

-- ─────────────────────────────────────────────
-- 4. Multi-table LEFT JOIN
-- ─────────────────────────────────────────────

-- All customers with their order count (including 0)
SELECT cu.first_name, cu.last_name,
       COUNT(o.order_id) AS order_count,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name;
