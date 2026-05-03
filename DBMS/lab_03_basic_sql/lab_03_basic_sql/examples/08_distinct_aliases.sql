-- ============================================================
-- Lab 03 | Example 08: DISTINCT and Aliases
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. DISTINCT — unique values
-- ─────────────────────────────────────────────

-- All cities (with duplicates)
SELECT city FROM customers;

-- Unique cities only
SELECT DISTINCT city FROM customers;

-- Unique categories in products
SELECT DISTINCT category_id FROM products;

-- Unique order statuses
SELECT DISTINCT status FROM orders;

-- ─────────────────────────────────────────────
-- 2. DISTINCT with multiple columns
-- ─────────────────────────────────────────────

-- Unique combinations of city and first_name starting letter
SELECT DISTINCT city, LEFT(first_name, 1) AS initial
FROM customers;

-- ─────────────────────────────────────────────
-- 3. Column Aliases — AS
-- ─────────────────────────────────────────────

-- Rename output columns
SELECT 
    name AS product_name,
    price AS "Price (BDT)",
    stock AS units_available
FROM products;

-- AS is optional (but recommended for readability)
SELECT name product_name, price unit_price
FROM products;

-- Aliases with spaces need quotes
SELECT name AS "Product Name", price AS "Unit Price (BDT)"
FROM products;

-- ─────────────────────────────────────────────
-- 4. Aliases for calculated columns
-- ─────────────────────────────────────────────

SELECT 
    name,
    price,
    price * 0.85 AS sale_price,
    price * stock AS total_value,
    CONCAT('BDT ', FORMAT(price, 2)) AS formatted_price
FROM products;

-- ─────────────────────────────────────────────
-- 5. Table Aliases
-- ─────────────────────────────────────────────

-- Without alias (verbose)
SELECT products.name, products.price, categories.name
FROM products
JOIN categories ON products.category_id = categories.category_id;

-- With table aliases (concise)
SELECT p.name, p.price, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.category_id;

-- ⚠️ Once you define a table alias, you MUST use it
-- (can't mix products.name and p.name in the same query)

-- ─────────────────────────────────────────────
-- 6. COUNT with DISTINCT
-- ─────────────────────────────────────────────

-- Total rows
SELECT COUNT(*) AS total_products FROM products;

-- Count of unique categories
SELECT COUNT(DISTINCT category_id) AS unique_categories FROM products;

-- Count of unique cities
SELECT COUNT(DISTINCT city) AS unique_cities FROM customers;
