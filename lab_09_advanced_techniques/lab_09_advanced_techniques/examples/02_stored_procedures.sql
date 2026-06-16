-- ============================================================
-- Lab 09 | Example 02: Stored Procedures
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Simple procedure — no parameters
-- ─────────────────────────────────────────────
DELIMITER //
CREATE PROCEDURE sp_show_low_stock()
BEGIN
    SELECT name, stock, price
    FROM products
    WHERE stock < 30
    ORDER BY stock ASC;
END //
DELIMITER ;

CALL sp_show_low_stock();

-- ─────────────────────────────────────────────
-- 2. IN parameter
-- ─────────────────────────────────────────────
DELIMITER //
CREATE PROCEDURE sp_products_by_category(IN p_category VARCHAR(100))
BEGIN
    SELECT p.name, p.price, p.stock
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE c.name = p_category
    ORDER BY p.price DESC;
END //
DELIMITER ;

CALL sp_products_by_category('Electronics');
CALL sp_products_by_category('Books');

-- ─────────────────────────────────────────────
-- 3. IN + OUT parameters
-- ─────────────────────────────────────────────
DELIMITER //
CREATE PROCEDURE sp_category_stats(
    IN  p_category VARCHAR(100),
    OUT p_count    INT,
    OUT p_avg_price DECIMAL(10,2),
    OUT p_total_stock INT
)
BEGIN
    SELECT COUNT(*), ROUND(AVG(price), 2), SUM(stock)
    INTO p_count, p_avg_price, p_total_stock
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE c.name = p_category;
END //
DELIMITER ;

CALL sp_category_stats('Electronics', @cnt, @avg, @stk);
SELECT @cnt AS count, @avg AS avg_price, @stk AS total_stock;

-- ─────────────────────────────────────────────
-- 4. Procedure with conditional logic
-- ─────────────────────────────────────────────
DELIMITER //
CREATE PROCEDURE sp_update_stock(
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_action VARCHAR(10)  -- 'add' or 'remove'
)
BEGIN
    IF p_action = 'add' THEN
        UPDATE products SET stock = stock + p_quantity
        WHERE product_id = p_product_id;
    ELSEIF p_action = 'remove' THEN
        UPDATE products SET stock = stock - p_quantity
        WHERE product_id = p_product_id AND stock >= p_quantity;
    END IF;
    
    SELECT name, stock FROM products WHERE product_id = p_product_id;
END //
DELIMITER ;

CALL sp_update_stock(1, 5, 'add');
CALL sp_update_stock(1, 2, 'remove');

-- ─────────────────────────────────────────────
-- 5. View/Drop procedures
-- ─────────────────────────────────────────────
SHOW PROCEDURE STATUS WHERE Db = 'ecommerce_db';
DROP PROCEDURE IF EXISTS sp_show_low_stock;
