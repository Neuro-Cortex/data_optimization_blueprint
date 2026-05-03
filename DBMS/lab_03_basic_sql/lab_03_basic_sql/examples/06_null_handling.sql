-- ============================================================
-- Lab 03 | Example 06: NULL Handling
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Understanding NULL
-- ─────────────────────────────────────────────

-- NULL is NOT zero, NOT empty string, NOT false
-- NULL means UNKNOWN or MISSING

SELECT NULL = NULL;       -- NULL (not TRUE!)
SELECT NULL <> NULL;      -- NULL (not TRUE!)
SELECT NULL = 0;          -- NULL
SELECT NULL = '';          -- NULL
SELECT 10 + NULL;         -- NULL
SELECT CONCAT('Hi', NULL); -- NULL

-- ─────────────────────────────────────────────
-- 2. IS NULL / IS NOT NULL
-- ─────────────────────────────────────────────

-- Find products with no description
SELECT name FROM products WHERE description IS NULL;

-- Find products WITH a description
SELECT name, description FROM products WHERE description IS NOT NULL;

-- Find customers with no phone number
SELECT first_name, last_name FROM customers WHERE phone IS NULL;

-- Find customers who HAVE phone numbers
SELECT first_name, phone FROM customers WHERE phone IS NOT NULL;

-- ─────────────────────────────────────────────
-- 3. COALESCE — first non-NULL value
-- ─────────────────────────────────────────────

-- Provide a default when NULL
SELECT name, 
       COALESCE(description, 'No description available') AS description
FROM products;

-- Chain multiple fallbacks
SELECT first_name,
       COALESCE(phone, email, 'No contact info') AS contact
FROM customers;

-- ─────────────────────────────────────────────
-- 4. IFNULL — MySQL-specific (simpler, 2 args only)
-- ─────────────────────────────────────────────

SELECT name,
       IFNULL(description, 'N/A') AS description
FROM products;

SELECT first_name,
       IFNULL(phone, 'No phone') AS phone
FROM customers;

-- ─────────────────────────────────────────────
-- 5. NULLIF — returns NULL if two values are equal
-- ─────────────────────────────────────────────

-- Useful to avoid division by zero
SELECT name, stock,
       price / NULLIF(stock, 0) AS price_per_unit
FROM products;
-- If stock = 0, NULLIF returns NULL, avoiding division by zero error

-- ─────────────────────────────────────────────
-- 6. NULL in aggregate functions
-- ─────────────────────────────────────────────

-- COUNT(*) counts ALL rows including NULLs
-- COUNT(column) counts only non-NULL values

SELECT 
    COUNT(*) AS total_rows,
    COUNT(description) AS rows_with_description,
    COUNT(*) - COUNT(description) AS rows_without_description
FROM products;

-- AVG, SUM, MIN, MAX all ignore NULLs
