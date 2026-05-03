-- ============================================================
-- Lab 01 | Example 04: Inserting Data
-- ============================================================
-- This file demonstrates various ways to INSERT data into
-- tables, including single rows, multiple rows, and handling
-- AUTO_INCREMENT and DEFAULT values.
-- ============================================================

USE shop_db;

-- ─────────────────────────────────────────────
-- 1. Insert single row — specifying columns
-- ─────────────────────────────────────────────
INSERT INTO categories (name, description)
VALUES ('Electronics', 'Gadgets, phones, and devices');

-- category_id is auto-generated, created_at uses DEFAULT
-- Check the generated ID:
SELECT LAST_INSERT_ID();
-- Output: 1

-- ─────────────────────────────────────────────
-- 2. Insert multiple rows at once
-- ─────────────────────────────────────────────
INSERT INTO categories (name, description) VALUES
    ('Clothing', 'Apparel, shoes, and accessories'),
    ('Books', 'Physical and digital books'),
    ('Home & Garden', 'Furniture, decor, and gardening'),
    ('Sports', 'Equipment, gear, and fitness');

-- Verify:
SELECT * FROM categories;
-- category_id: 1, 2, 3, 4, 5 (auto-generated)

-- ─────────────────────────────────────────────
-- 3. Insert into products (with foreign key)
-- ─────────────────────────────────────────────
INSERT INTO products (name, description, price, stock, category_id) VALUES
    ('iPhone 15', '6.1-inch display, A16 chip', 129999.00, 50, 1),
    ('Samsung Galaxy S24', '6.2-inch, Snapdragon 8 Gen 3', 109999.00, 35, 1),
    ('AirPods Pro', 'Active noise cancellation', 24999.00, 100, 1),
    ('Classic T-Shirt', '100% cotton, crew neck', 799.00, 200, 2),
    ('Running Shoes', 'Lightweight, breathable mesh', 3499.00, 80, 2),
    ('Clean Code', 'Robert C. Martin, Software craftsmanship', 1500.00, 30, 3),
    ('Database Systems', 'Elmasri & Navathe, 7th Edition', 2200.00, 25, 3),
    ('Standing Desk', 'Adjustable height, electric motor', 18999.00, 15, 4),
    ('Cricket Bat', 'English willow, Grade A', 5500.00, 40, 5),
    ('Yoga Mat', 'Non-slip, 6mm thick', 1200.00, 60, 5);

-- ─────────────────────────────────────────────
-- 4. Insert into customers
-- ─────────────────────────────────────────────
INSERT INTO customers (first_name, last_name, email, phone, city, gender, date_of_birth) VALUES
    ('Rafiq', 'Ahmed', 'rafiq@gmail.com', '01711234567', 'Dhaka', 'Male', '2000-05-15'),
    ('Nusrat', 'Jahan', 'nusrat@gmail.com', '01819876543', 'Chittagong', 'Female', '2001-03-20'),
    ('Tanvir', 'Hasan', 'tanvir@gmail.com', '01512345678', 'Dhaka', 'Male', '1999-11-08'),
    ('Ayesha', 'Khan', 'ayesha@gmail.com', '01698765432', 'Sylhet', 'Female', '2002-07-25'),
    ('Imran', 'Ali', 'imran@gmail.com', '01412341234', 'Rajshahi', 'Male', '2000-01-30');

-- ─────────────────────────────────────────────
-- 5. Verify all inserted data
-- ─────────────────────────────────────────────
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM customers;

-- ─────────────────────────────────────────────
-- 6. What happens with constraints?
-- ─────────────────────────────────────────────

-- ❌ This FAILS — duplicate UNIQUE value:
-- INSERT INTO categories (name) VALUES ('Electronics');
-- Error: Duplicate entry 'Electronics' for key 'name'

-- ❌ This FAILS — NOT NULL violation:
-- INSERT INTO products (name, price, stock) VALUES (NULL, 100, 5);
-- Error: Column 'name' cannot be null

-- ❌ This FAILS — CHECK constraint violation:
-- INSERT INTO products (name, price, stock) VALUES ('Test', -50, 5);
-- Error: Check constraint 'products_chk_1' is violated

-- ❌ This FAILS — FOREIGN KEY violation:
-- INSERT INTO products (name, price, stock, category_id) 
-- VALUES ('Test', 100, 5, 999);
-- Error: Cannot add or update a child row: foreign key constraint fails

-- ─────────────────────────────────────────────
-- 7. Using DEFAULT values
-- ─────────────────────────────────────────────

-- stock defaults to 0, is_active defaults to TRUE, city defaults to 'Dhaka'
INSERT INTO products (name, price, category_id)
VALUES ('Mystery Product', 999.99, 1);

SELECT name, stock, is_active FROM products WHERE name = 'Mystery Product';
-- stock: 0, is_active: 1 (TRUE) ← defaults applied!
