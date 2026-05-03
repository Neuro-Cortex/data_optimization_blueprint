-- ============================================================
-- Lab 01 | Example 05: Basic SELECT Queries
-- ============================================================
-- A quick preview of SELECT. We'll go much deeper in Lab 03.
-- ============================================================

USE shop_db;

-- ─────────────────────────────────────────────
-- 1. Select everything
-- ─────────────────────────────────────────────
SELECT * FROM products;
SELECT * FROM categories;
SELECT * FROM customers;

-- ─────────────────────────────────────────────
-- 2. Select specific columns
-- ─────────────────────────────────────────────
SELECT name, price FROM products;

SELECT first_name, last_name, email FROM customers;

-- ─────────────────────────────────────────────
-- 3. Filter with WHERE
-- ─────────────────────────────────────────────
-- Products over 10,000 BDT
SELECT name, price FROM products WHERE price > 10000;

-- Customers from Dhaka
SELECT first_name, last_name, city 
FROM customers 
WHERE city = 'Dhaka';

-- Products in Electronics category (category_id = 1)
SELECT name, price, stock 
FROM products 
WHERE category_id = 1;

-- ─────────────────────────────────────────────
-- 4. Sort results
-- ─────────────────────────────────────────────
-- Products sorted by price (cheapest first)
SELECT name, price FROM products ORDER BY price ASC;

-- Products sorted by price (most expensive first)
SELECT name, price FROM products ORDER BY price DESC;

-- ─────────────────────────────────────────────
-- 5. Limit results
-- ─────────────────────────────────────────────
-- Top 3 most expensive products
SELECT name, price 
FROM products 
ORDER BY price DESC 
LIMIT 3;

-- ─────────────────────────────────────────────
-- 6. Count rows
-- ─────────────────────────────────────────────
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_categories FROM categories;

-- ─────────────────────────────────────────────
-- 7. Combine WHERE + ORDER + LIMIT
-- ─────────────────────────────────────────────
-- Top 5 cheapest electronics
SELECT name, price 
FROM products 
WHERE category_id = 1 
ORDER BY price ASC 
LIMIT 5;

-- 🎯 We'll explore SELECT in depth in Lab 03!
