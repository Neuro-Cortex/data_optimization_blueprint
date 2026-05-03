-- ============================================================
-- Lab 09 | Example 01: Views
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Simple View — product catalog
-- ─────────────────────────────────────────────
CREATE OR REPLACE VIEW v_product_catalog AS
SELECT p.product_id, p.name AS product, p.price, p.stock,
       COALESCE(c.name, 'Uncategorized') AS category,
       CASE WHEN p.is_active THEN 'Active' ELSE 'Inactive' END AS status
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;

-- Use like a table
SELECT * FROM v_product_catalog;
SELECT * FROM v_product_catalog WHERE category = 'Electronics';
SELECT * FROM v_product_catalog WHERE price > 10000 ORDER BY price DESC;

-- ─────────────────────────────────────────────
-- 2. Complex View — order summary
-- ─────────────────────────────────────────────
CREATE OR REPLACE VIEW v_order_summary AS
SELECT o.order_id,
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       o.order_date,
       o.status,
       COUNT(oi.order_item_id) AS total_items,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, cu.first_name, cu.last_name, o.order_date, o.status;

SELECT * FROM v_order_summary;

-- ─────────────────────────────────────────────
-- 3. Security View — hide sensitive data
-- ─────────────────────────────────────────────
CREATE OR REPLACE VIEW v_customer_public AS
SELECT customer_id, first_name, city, created_at
FROM customers;
-- Hides: email, phone, address, last_name

-- ─────────────────────────────────────────────
-- 4. Manage Views
-- ─────────────────────────────────────────────
SHOW CREATE VIEW v_product_catalog;
DROP VIEW IF EXISTS v_customer_public;
