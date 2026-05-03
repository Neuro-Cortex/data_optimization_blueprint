-- ============================================================
-- Lab 09 | Example 05: Transactions & ACID
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Basic Transaction
-- ─────────────────────────────────────────────

START TRANSACTION;

-- Place a new order
INSERT INTO orders (customer_id, order_date, status, total_amount)
VALUES (1, CURDATE(), 'pending', 0);

SET @new_order = LAST_INSERT_ID();

-- Add items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (@new_order, 1, 1, 129999.00);

-- Reduce stock
UPDATE products SET stock = stock - 1 WHERE product_id = 1;

-- Everything worked — save it
COMMIT;

-- ─────────────────────────────────────────────
-- 2. Rollback Example
-- ─────────────────────────────────────────────

START TRANSACTION;

-- Check stock first
SELECT stock INTO @current_stock FROM products WHERE product_id = 10;

-- Try to remove 1000 items
UPDATE products SET stock = stock - 1000 WHERE product_id = 10;

-- Check if stock went negative
SELECT stock INTO @new_stock FROM products WHERE product_id = 10;

-- Rollback if invalid
-- In a stored procedure you would use IF/ELSE
-- For demo, let's just rollback
ROLLBACK;

-- Stock should be unchanged
SELECT product_id, name, stock FROM products WHERE product_id = 10;

-- ─────────────────────────────────────────────
-- 3. Savepoints — partial rollback
-- ─────────────────────────────────────────────

START TRANSACTION;

INSERT INTO categories (name) VALUES ('Test Category 1');
SAVEPOINT sp1;

INSERT INTO categories (name) VALUES ('Test Category 2');
SAVEPOINT sp2;

INSERT INTO categories (name) VALUES ('Test Category 3');

-- Undo only the last insert
ROLLBACK TO sp2;

-- Category 1 and 2 are kept, 3 is undone
COMMIT;

-- Cleanup
DELETE FROM categories WHERE name LIKE 'Test Category%';
