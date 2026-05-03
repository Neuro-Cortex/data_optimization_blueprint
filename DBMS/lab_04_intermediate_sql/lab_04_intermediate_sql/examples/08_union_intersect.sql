-- ============================================================
-- Lab 04 | Example 08: UNION and Set Operations
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. UNION — combine results, remove duplicates
-- ─────────────────────────────────────────────

-- All unique cities (from customers)
-- combined with a list of office locations
SELECT city AS location, 'Customer' AS type FROM customers
UNION
SELECT 'Dhaka HQ', 'Office'
UNION
SELECT 'Chittagong Branch', 'Office';

-- ─────────────────────────────────────────────
-- 2. UNION ALL — keep duplicates (faster)
-- ─────────────────────────────────────────────

-- Count: UNION removes duplicates, UNION ALL keeps them
SELECT city FROM customers          -- may have duplicate cities
UNION ALL
SELECT city FROM customers;         -- ALL rows, including duplicates

-- ─────────────────────────────────────────────
-- 3. Rules for UNION
-- ─────────────────────────────────────────────

-- ✅ Same number of columns
-- ✅ Compatible data types
-- ✅ Column names come from the FIRST query
-- ❌ Can't UNION queries with different column counts

-- Combined product search: by name OR category name
SELECT 'Product' AS type, p.name, p.price
FROM products p
WHERE p.name LIKE '%phone%'
UNION
SELECT 'Category' AS type, c.name, NULL
FROM categories c
WHERE c.name LIKE '%Electronics%';

-- ─────────────────────────────────────────────
-- 4. UNION with ORDER BY
-- ─────────────────────────────────────────────

-- ORDER BY must come at the very end (applies to combined result)
SELECT name, price, 'Expensive' AS tier
FROM products WHERE price > 10000
UNION ALL
SELECT name, price, 'Affordable' AS tier
FROM products WHERE price <= 10000
ORDER BY price DESC;

-- ─────────────────────────────────────────────
-- 5. Practical: Activity log from multiple sources
-- ─────────────────────────────────────────────

-- Combine orders and reviews into a timeline
SELECT 'Order' AS activity,
       CONCAT('Order #', o.order_id) AS description,
       o.created_at AS activity_date
FROM orders o
UNION ALL
SELECT 'Review' AS activity,
       CONCAT('Review for product #', pr.product_id) AS description,
       pr.review_date AS activity_date
FROM product_reviews pr
ORDER BY activity_date DESC;
