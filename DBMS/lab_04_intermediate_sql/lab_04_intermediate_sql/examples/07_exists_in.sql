-- ============================================================
-- Lab 04 | Example 07: EXISTS and IN
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. EXISTS — returns TRUE if subquery has any rows
-- ─────────────────────────────────────────────

-- Customers who have at least one order
SELECT cu.first_name, cu.last_name, cu.email
FROM customers cu
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = cu.customer_id
);

-- Customers who have NOT placed any orders
SELECT cu.first_name, cu.last_name, cu.email
FROM customers cu
WHERE NOT EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = cu.customer_id
);

-- Categories that have at least one product
SELECT c.name AS category
FROM categories c
WHERE EXISTS (
    SELECT 1 FROM products p 
    WHERE p.category_id = c.category_id
);

-- Empty categories
SELECT c.name AS empty_category
FROM categories c
WHERE NOT EXISTS (
    SELECT 1 FROM products p 
    WHERE p.category_id = c.category_id
);

-- ─────────────────────────────────────────────
-- 2. IN — matches against a list
-- ─────────────────────────────────────────────

-- Same queries using IN instead of EXISTS:

-- Customers who have orders
SELECT first_name, last_name FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM orders
);

-- Customers with no orders
SELECT first_name, last_name FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM orders
);

-- ─────────────────────────────────────────────
-- 3. EXISTS vs IN — when to use which?
-- ─────────────────────────────────────────────

-- | Scenario                    | Use      | Why                         |
-- |-----------------------------|----------|-----------------------------|
-- | Large outer, small inner    | IN       | Inner query runs once       |
-- | Small outer, large inner    | EXISTS   | Stops at first match        |
-- | Inner has NULLs             | EXISTS   | IN with NULL gives issues   |
-- | Simple value matching       | IN       | More readable               |
-- | Correlated conditions       | EXISTS   | Natural for correlation     |

-- ⚠️ NULL trap with NOT IN:
-- If the subquery returns any NULL value, NOT IN returns EMPTY results!
-- EXISTS handles NULLs correctly.

-- ─────────────────────────────────────────────
-- 4. Practical examples
-- ─────────────────────────────────────────────

-- Products ordered in delivered orders only
SELECT DISTINCT p.name, p.price
FROM products p
WHERE EXISTS (
    SELECT 1 FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE oi.product_id = p.product_id
      AND o.status = 'delivered'
);

-- Customers who ordered Electronics
SELECT DISTINCT cu.first_name, cu.last_name
FROM customers cu
WHERE EXISTS (
    SELECT 1 FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.customer_id = cu.customer_id
      AND p.category_id = 1
);
