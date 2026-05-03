-- ============================================================
-- Lab 09 | Example 04: Triggers
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Audit log table
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS audit_log (
    log_id     INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    action     VARCHAR(10),
    record_id  INT,
    old_value  TEXT,
    new_value  TEXT,
    changed_by VARCHAR(100) DEFAULT (CURRENT_USER()),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────
-- 2. AFTER UPDATE trigger — log price changes
-- ─────────────────────────────────────────────
DELIMITER //
CREATE TRIGGER trg_product_price_audit
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT INTO audit_log (table_name, action, record_id, old_value, new_value)
        VALUES ('products', 'UPDATE', OLD.product_id,
                CONCAT('price=', OLD.price),
                CONCAT('price=', NEW.price));
    END IF;
END //
DELIMITER ;

-- Test it
UPDATE products SET price = price * 1.10 WHERE product_id = 1;
SELECT * FROM audit_log;

-- ─────────────────────────────────────────────
-- 3. AFTER INSERT trigger — auto-update order total
-- ─────────────────────────────────────────────
DELIMITER //
CREATE TRIGGER trg_update_order_total_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = (
        SELECT SUM(quantity * unit_price)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END //
DELIMITER ;

-- ─────────────────────────────────────────────
-- 4. BEFORE INSERT trigger — validate data
-- ─────────────────────────────────────────────
DELIMITER //
CREATE TRIGGER trg_validate_product_price
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price cannot be negative!';
    END IF;
    IF NEW.stock < 0 THEN
        SET NEW.stock = 0;  -- Auto-correct negative stock
    END IF;
END //
DELIMITER ;

-- ─────────────────────────────────────────────
-- 5. View/Drop triggers
-- ─────────────────────────────────────────────
SHOW TRIGGERS;
-- DROP TRIGGER IF EXISTS trg_product_price_audit;
