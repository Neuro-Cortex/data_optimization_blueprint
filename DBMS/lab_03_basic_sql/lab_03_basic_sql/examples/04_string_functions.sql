-- ============================================================
-- Lab 03 | Example 04: String Functions
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. CONCAT — joining strings
-- ─────────────────────────────────────────────

-- Full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- Full name with title
SELECT CONCAT('Mr./Ms. ', first_name, ' ', last_name) AS greeting
FROM customers;

-- CONCAT_WS — concat with separator
SELECT CONCAT_WS(', ', city, address, phone) AS contact_info
FROM customers;

-- ─────────────────────────────────────────────
-- 2. UPPER / LOWER — case conversion
-- ─────────────────────────────────────────────

SELECT UPPER(name) AS upper_name, 
       LOWER(name) AS lower_name
FROM products;

-- Capitalize first letter only
SELECT CONCAT(UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2))) AS capitalized
FROM customers;

-- ─────────────────────────────────────────────
-- 3. LENGTH / CHAR_LENGTH
-- ─────────────────────────────────────────────

SELECT name, 
       LENGTH(name)      AS byte_length,
       CHAR_LENGTH(name)  AS char_length
FROM products;

-- Find products with long names (> 10 chars)
SELECT name, CHAR_LENGTH(name) AS name_length
FROM products
WHERE CHAR_LENGTH(name) > 10;

-- ─────────────────────────────────────────────
-- 4. SUBSTRING — extract parts
-- ─────────────────────────────────────────────

-- First 10 characters of product name
SELECT name, SUBSTRING(name, 1, 10) AS short_name
FROM products;

-- Extract email username (before @)
SELECT email, 
       SUBSTRING_INDEX(email, '@', 1) AS username,
       SUBSTRING_INDEX(email, '@', -1) AS domain
FROM customers;

-- ─────────────────────────────────────────────
-- 5. LEFT / RIGHT — from edges
-- ─────────────────────────────────────────────

SELECT name
      ,LEFT(name, 5)  AS first_five
      ,RIGHT(name, 5) AS last_five
FROM products;

-- ─────────────────────────────────────────────
-- 6. TRIM — remove whitespace
-- ─────────────────────────────────────────────

SELECT 
    TRIM('   Hello World   ')     AS trimmed,
    LTRIM('   Hello')              AS left_trimmed,
    RTRIM('Hello   ')              AS right_trimmed,
    TRIM(LEADING '0' FROM '000123') AS remove_leading_zeros;

-- ─────────────────────────────────────────────
-- 7. REPLACE — substitute text
-- ─────────────────────────────────────────────

SELECT name, REPLACE(name, ' ', '-') AS url_slug
FROM products;

-- Mask phone numbers: 0171****567
SELECT phone, 
       CONCAT(LEFT(phone, 4), '****', RIGHT(phone, 3)) AS masked_phone
FROM customers;

-- ─────────────────────────────────────────────
-- 8. REVERSE and LPAD/RPAD
-- ─────────────────────────────────────────────

SELECT REVERSE('Hello');   -- olleH

-- Pad product_id to 5 digits: 00001, 00002, ...
SELECT LPAD(product_id, 5, '0') AS padded_id, name
FROM products;

-- Right-pad name to 30 chars with dots
SELECT RPAD(name, 30, '.') AS padded_name, price
FROM products;
