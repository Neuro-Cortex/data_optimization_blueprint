-- ============================================================
-- Lab 09 | Lab Task Solution
-- ============================================================

USE ecommerce_db;

-- ─── 1. View: Order Summary ──────────────────
CREATE OR REPLACE VIEW v_order_summary AS
SELECT o.order_id,
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
       COUNT(oi.order_item_id) AS total_items,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_amount
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, cu.first_name, cu.last_name;

SELECT * FROM v_order_summary;

-- ─── 2. Stored Procedure: Place Order ────────
DELIMITER //
CREATE PROCEDURE sp_place_order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_order_id INT;
    
    -- Get current price and stock
    SELECT price, stock INTO v_price, v_stock
    FROM products WHERE product_id = p_product_id;
    
    -- Check stock
    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock!';
    END IF;
    
    START TRANSACTION;
    
    -- Create order
    INSERT INTO orders (customer_id, order_date, status, total_amount)
    VALUES (p_customer_id, CURDATE(), 'pending', v_price * p_quantity);
    
    SET v_order_id = LAST_INSERT_ID();
    
    -- Add order item
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (v_order_id, p_product_id, p_quantity, v_price);
    
    -- Reduce stock
    UPDATE products SET stock = stock - p_quantity
    WHERE product_id = p_product_id;
    
    COMMIT;
    
    SELECT v_order_id AS new_order_id, 'Order placed successfully!' AS message;
END //
DELIMITER ;

-- Test: CALL sp_place_order(1, 2, 1);

-- ─── 3. Function: Category Revenue ──────────
DELIMITER //
CREATE FUNCTION fn_get_category_revenue(p_cat_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0) INTO total
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    WHERE p.category_id = p_cat_id;
    RETURN total;
END //
DELIMITER ;

SELECT c.name, fn_get_category_revenue(c.category_id) AS revenue
FROM categories c ORDER BY revenue DESC;

-- ─── 4. Trigger: Audit Price Changes ────────
CREATE TABLE IF NOT EXISTS audit_log (
    log_id     INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    action     VARCHAR(10),
    record_id  INT,
    old_value  TEXT,
    new_value  TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_product_price_log
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT INTO audit_log (table_name, action, record_id, old_value, new_value)
        VALUES ('products', 'PRICE_CHG', OLD.product_id,
                CAST(OLD.price AS CHAR), CAST(NEW.price AS CHAR));
    END IF;
END //
DELIMITER ;

-- Test
UPDATE products SET price = price + 100 WHERE product_id = 3;
SELECT * FROM audit_log;

-- ─── 5. Transaction: Atomic Order ───────────
START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status, total_amount)
VALUES (2, CURDATE(), 'pending', 24999.00);

SET @oid = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (@oid, 3, 1, 24999.00);

UPDATE products SET stock = stock - 1 WHERE product_id = 3;

-- Verify stock is not negative
SELECT stock INTO @stk FROM products WHERE product_id = 3;

-- Commit if valid (in real app, use IF/ELSE in a procedure)
COMMIT;

SELECT 'Transaction committed successfully' AS status;
