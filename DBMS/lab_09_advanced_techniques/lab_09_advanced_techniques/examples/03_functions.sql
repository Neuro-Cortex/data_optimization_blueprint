-- ============================================================
-- Lab 09 | Example 03: User-Defined Functions
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Simple function — calculate discount
-- ─────────────────────────────────────────────
DELIMITER //
CREATE FUNCTION fn_discount_price(
    original DECIMAL(10,2),
    discount_pct DECIMAL(5,2)
) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(original * (1 - discount_pct / 100), 2);
END //
DELIMITER ;

-- Use in SELECT
SELECT name, price, fn_discount_price(price, 20) AS sale_price
FROM products;

-- ─────────────────────────────────────────────
-- 2. Function with database lookup
-- ─────────────────────────────────────────────
DELIMITER //
CREATE FUNCTION fn_category_revenue(p_category_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0) INTO total
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    WHERE p.category_id = p_category_id;
    RETURN total;
END //
DELIMITER ;

SELECT c.name, fn_category_revenue(c.category_id) AS revenue
FROM categories c ORDER BY revenue DESC;

-- ─────────────────────────────────────────────
-- 3. Function — format BDT currency
-- ─────────────────────────────────────────────
DELIMITER //
CREATE FUNCTION fn_format_bdt(amount DECIMAL(12,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    RETURN CONCAT('৳ ', FORMAT(amount, 2));
END //
DELIMITER ;

SELECT name, fn_format_bdt(price) AS formatted_price FROM products;

-- ─────────────────────────────────────────────
-- 4. Drop functions
-- ─────────────────────────────────────────────
-- DROP FUNCTION IF EXISTS fn_discount_price;
-- DROP FUNCTION IF EXISTS fn_category_revenue;
-- DROP FUNCTION IF EXISTS fn_format_bdt;
