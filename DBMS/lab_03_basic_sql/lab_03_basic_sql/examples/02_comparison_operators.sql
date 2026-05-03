-- ============================================================
-- Lab 03 | Example 02: Comparison Operators
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. BETWEEN — range (inclusive)
-- ─────────────────────────────────────────────

-- Products priced between 1,000 and 10,000
SELECT name, price FROM products
WHERE price BETWEEN 1000 AND 10000;

-- Orders from February 2025
SELECT order_id, order_date, status FROM orders
WHERE order_date BETWEEN '2025-02-01' AND '2025-02-28';

-- NOT BETWEEN
SELECT name, price FROM products
WHERE price NOT BETWEEN 1000 AND 10000;

-- ─────────────────────────────────────────────
-- 2. IN — match any value in a list
-- ─────────────────────────────────────────────

-- Customers from specific cities
SELECT first_name, last_name, city FROM customers
WHERE city IN ('Dhaka', 'Chittagong', 'Sylhet');

-- Products in Electronics, Books, or Sports
SELECT name, category_id FROM products
WHERE category_id IN (1, 3, 5);

-- NOT IN
SELECT first_name, city FROM customers
WHERE city NOT IN ('Dhaka');

-- ─────────────────────────────────────────────
-- 3. LIKE — pattern matching
-- ─────────────────────────────────────────────

-- % matches zero or more characters
-- _ matches exactly one character

-- Products starting with 'A'
SELECT name FROM products WHERE name LIKE 'A%';

-- Products ending with 'Pro'
SELECT name FROM products WHERE name LIKE '%Pro';

-- Products containing 'Shirt'
SELECT name FROM products WHERE name LIKE '%Shirt%';

-- Names with exactly 4 characters
SELECT first_name FROM customers WHERE first_name LIKE '____';

-- Second character is 'a'
SELECT first_name FROM customers WHERE first_name LIKE '_a%';

-- Emails from Gmail
SELECT first_name, email FROM customers
WHERE email LIKE '%@gmail.com';

-- ─────────────────────────────────────────────
-- 4. Combining operators
-- ─────────────────────────────────────────────

-- Products between 1000-5000, from Electronics or Books
SELECT name, price, category_id FROM products
WHERE price BETWEEN 1000 AND 5000
  AND category_id IN (1, 3);

-- Customers from Dhaka whose name starts with 'R' or 'T'
SELECT first_name, last_name, city FROM customers
WHERE city = 'Dhaka'
  AND (first_name LIKE 'R%' OR first_name LIKE 'T%');
