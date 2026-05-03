-- ============================================================
-- Lab 02 | Example 03: Primary Keys & Foreign Keys Deep Dive
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Types of Primary Keys
-- ─────────────────────────────────────────────

-- Surrogate Key (recommended — auto-generated, no business meaning)
CREATE TABLE demo_surrogate (
    id    INT AUTO_INCREMENT PRIMARY KEY,
    name  VARCHAR(100)
);

-- Natural Key (uses real data — can change!)
CREATE TABLE demo_natural (
    email VARCHAR(150) PRIMARY KEY,    -- ⚠️ What if user changes email?
    name  VARCHAR(100)
);

-- Composite Key (two+ columns form the PK — used in junction tables)
CREATE TABLE demo_composite (
    student_id INT,
    course_id  INT,
    grade      CHAR(2),
    enrolled_at DATE,
    PRIMARY KEY (student_id, course_id)   -- Combination must be unique
);

DROP TABLE demo_surrogate;
DROP TABLE demo_natural;
DROP TABLE demo_composite;

-- ─────────────────────────────────────────────
-- 2. Foreign Key in Action
-- ─────────────────────────────────────────────

-- Insert sample data to test FK behavior
INSERT INTO categories (name, description) VALUES
    ('Electronics', 'Gadgets and devices'),
    ('Clothing', 'Apparel and accessories'),
    ('Books', 'Physical and digital books');

INSERT INTO products (name, price, stock, category_id) VALUES
    ('iPhone 15', 129999.00, 50, 1),
    ('T-Shirt', 799.00, 200, 2),
    ('Clean Code', 1500.00, 30, 3);

-- ✅ This works — category_id 1 exists
SELECT p.name, p.price, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.category_id;

-- ❌ This FAILS — category_id 999 doesn't exist
-- INSERT INTO products (name, price, stock, category_id)
-- VALUES ('Ghost Product', 500, 10, 999);
-- Error: Cannot add or update a child row: a foreign key constraint fails

-- ─────────────────────────────────────────────
-- 3. ON DELETE behavior demonstration
-- ─────────────────────────────────────────────

-- products FK to categories is ON DELETE SET NULL
-- So deleting a category sets product's category_id to NULL

SELECT product_id, name, category_id FROM products WHERE category_id = 2;
-- Shows: T-Shirt, category_id = 2

DELETE FROM categories WHERE category_id = 2;

SELECT product_id, name, category_id FROM products WHERE name = 'T-Shirt';
-- Now: T-Shirt, category_id = NULL ← SET NULL in action!

-- Re-insert for later examples
INSERT INTO categories (name, description) VALUES ('Clothing', 'Apparel');
UPDATE products SET category_id = (SELECT category_id FROM categories WHERE name = 'Clothing')
WHERE name = 'T-Shirt';

-- ─────────────────────────────────────────────
-- 4. ON UPDATE CASCADE demonstration
-- ─────────────────────────────────────────────

-- If we could update a category's PK (not recommended, but let's demo):
-- With CASCADE, the FK in products would auto-update

-- ─────────────────────────────────────────────
-- 5. RESTRICT demonstration (orders → customers)
-- ─────────────────────────────────────────────

INSERT INTO customers (first_name, last_name, email, phone)
VALUES ('Rafiq', 'Ahmed', 'rafiq@gmail.com', '01711234567');

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2025-03-01', 'pending');

-- ❌ This FAILS — customer has orders (RESTRICT behavior)
-- DELETE FROM customers WHERE customer_id = 1;
-- Error: Cannot delete or update a parent row: a foreign key constraint fails

-- ✅ Must delete orders first, then customer
-- DELETE FROM orders WHERE customer_id = 1;
-- DELETE FROM customers WHERE customer_id = 1;

-- ─────────────────────────────────────────────
-- 6. Viewing Foreign Key constraints
-- ─────────────────────────────────────────────

-- Method 1: SHOW CREATE TABLE
SHOW CREATE TABLE order_items;

-- Method 2: Query information_schema
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'ecommerce_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
