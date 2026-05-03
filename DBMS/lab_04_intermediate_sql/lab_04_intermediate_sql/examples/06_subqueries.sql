-- ============================================================
-- Lab 04 | Example 06: Subqueries
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Scalar subquery (returns single value)
-- ─────────────────────────────────────────────

-- Products priced above average
SELECT name, price FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Most expensive product
SELECT name, price FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- Cheapest product
SELECT name, price FROM products
WHERE price = (SELECT MIN(price) FROM products);

-- ─────────────────────────────────────────────
-- 2. Column subquery (returns list of values)
-- ─────────────────────────────────────────────

-- Customers who have placed orders
SELECT first_name, last_name FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM orders
);

-- Products that have been ordered at least once
SELECT name, price FROM products
WHERE product_id IN (
    SELECT DISTINCT product_id FROM order_items
);

-- Products that have NEVER been ordered
SELECT name, price FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id FROM order_items
);

-- ─────────────────────────────────────────────
-- 3. Table subquery (returns a result set)
-- ─────────────────────────────────────────────

-- Top spending customers (derived table)
SELECT sub.customer_name, sub.total_spent
FROM (
    SELECT CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
           SUM(o.total_amount) AS total_spent
    FROM customers cu
    JOIN orders o ON cu.customer_id = o.customer_id
    GROUP BY cu.customer_id
) AS sub
WHERE sub.total_spent > 50000;

-- ─────────────────────────────────────────────
-- 4. Correlated subquery
-- ─────────────────────────────────────────────

-- Products priced above their category's average
SELECT p.name, p.price, p.category_id
FROM products p
WHERE p.price > (
    SELECT AVG(p2.price) 
    FROM products p2
    WHERE p2.category_id = p.category_id  -- correlated!
);

-- Most expensive product in each category
SELECT p.name, p.price, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);

-- ─────────────────────────────────────────────
-- 5. Subquery in SELECT clause
-- ─────────────────────────────────────────────

-- Each product with its category's average price
SELECT name, price,
    (SELECT AVG(p2.price) FROM products p2 
     WHERE p2.category_id = p.category_id) AS category_avg,
    price - (SELECT AVG(p2.price) FROM products p2 
             WHERE p2.category_id = p.category_id) AS diff_from_avg
FROM products p;

-- ─────────────────────────────────────────────
-- 6. Subquery in FROM clause (Derived Table)
-- ─────────────────────────────────────────────

-- Category summary with product details
SELECT cat_summary.category, cat_summary.product_count,
       cat_summary.avg_price, cat_summary.total_stock
FROM (
    SELECT c.name AS category,
           COUNT(*) AS product_count,
           ROUND(AVG(p.price), 2) AS avg_price,
           SUM(p.stock) AS total_stock
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY c.name
) AS cat_summary
WHERE cat_summary.product_count >= 2;
