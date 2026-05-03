-- ============================================================
-- Lab 04 | Lab Task Solution: Analytical Queries
-- ============================================================

USE ecommerce_db;

-- ─── JOINs (1-4) ───────────────────────────────

-- 1. All products with their category name
SELECT p.name AS product, p.price, c.name AS category
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY c.name, p.name;

-- 2. All orders with customer full name and status
SELECT o.order_id,
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       o.order_date, o.status, o.total_amount
FROM orders o
INNER JOIN customers cu ON o.customer_id = cu.customer_id
ORDER BY o.order_date DESC;

-- 3. Full order details
SELECT o.order_id,
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       p.name AS product,
       oi.quantity,
       oi.unit_price,
       (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN customers cu ON o.customer_id = cu.customer_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- 4. Empty categories (no products)
SELECT c.name AS empty_category
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
WHERE p.product_id IS NULL;

-- ─── GROUP BY & LEFT JOIN (5-8) ────────────────

-- 5. Customers who have not placed any orders
SELECT cu.first_name, cu.last_name, cu.email
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 6. Number of products per category
SELECT c.name AS category, COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.name
ORDER BY product_count DESC;

-- 7. Total revenue per category
SELECT c.name AS category,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.name
ORDER BY total_revenue DESC;

-- 8. Most expensive product in each category
SELECT c.name AS category, p.name AS product, p.price
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.price = (
    SELECT MAX(p2.price) 
    FROM products p2 
    WHERE p2.category_id = p.category_id
)
ORDER BY p.price DESC;

-- ─── Subqueries & Complex (9-12) ──────────────

-- 9. Customers who spent more than 100,000 BDT
SELECT CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       SUM(o.total_amount) AS total_spent
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id
HAVING SUM(o.total_amount) > 100000;

-- 10. Products priced above overall average
SELECT name, price, 
       ROUND((SELECT AVG(price) FROM products), 2) AS avg_price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- 11. Category with highest total revenue
SELECT c.name AS category,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 1;

-- 12. Orders with more than 2 items
SELECT o.order_id,
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       COUNT(oi.order_item_id) AS item_count
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, cu.first_name, cu.last_name
HAVING COUNT(oi.order_item_id) > 2;
