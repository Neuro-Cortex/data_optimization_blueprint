-- ============================================================
-- Lab 04 | Example 01: INNER JOIN
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Basic INNER JOIN — two tables
-- ─────────────────────────────────────────────

-- Products with their category names
SELECT p.name AS product, p.price, c.name AS category
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;

-- Orders with customer names
SELECT o.order_id, 
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       o.order_date, o.status
FROM orders o
INNER JOIN customers cu ON o.customer_id = cu.customer_id;

-- ─────────────────────────────────────────────
-- 2. Three-table JOIN
-- ─────────────────────────────────────────────

-- Order items with product Names
SELECT oi.order_item_id, o.order_id, p.name AS product,
       oi.quantity, oi.unit_price
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

-- ─────────────────────────────────────────────
-- 3. Four-table JOIN — complete order details
-- ─────────────────────────────────────────────

SELECT o.order_id,
       DATE_FORMAT(o.order_date, '%d %b %Y') AS order_date,
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       p.name AS product,
       c.name AS category,
       oi.quantity,
       oi.unit_price,
       (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN customers cu ON o.customer_id = cu.customer_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY o.order_id, p.name;

-- ─────────────────────────────────────────────
-- 4. JOIN with WHERE and ORDER BY
-- ─────────────────────────────────────────────

-- Electronics products that have been ordered
SELECT DISTINCT p.name, p.price, c.name AS category
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
WHERE c.name = 'Electronics'
ORDER BY p.price DESC;

-- Orders above 5,000 BDT with customer info
SELECT o.order_id, 
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       o.total_amount, o.status
FROM orders o
INNER JOIN customers cu ON o.customer_id = cu.customer_id
WHERE o.total_amount > 5000
ORDER BY o.total_amount DESC;
