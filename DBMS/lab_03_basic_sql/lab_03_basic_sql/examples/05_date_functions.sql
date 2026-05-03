-- ============================================================
-- Lab 03 | Example 05: Date Functions
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. Current date/time functions
-- ─────────────────────────────────────────────

SELECT 
    NOW()       AS current_datetime,    -- 2025-03-03 14:30:00
    CURDATE()   AS current_date_only,   -- 2025-03-03
    CURTIME()   AS current_time_only,   -- 14:30:00
    SYSDATE()   AS system_datetime;     -- Same as NOW()

-- ─────────────────────────────────────────────
-- 2. Extracting parts of a date
-- ─────────────────────────────────────────────

SELECT order_id, order_date,
    YEAR(order_date)       AS order_year,
    MONTH(order_date)      AS order_month,
    DAY(order_date)        AS order_day,
    DAYNAME(order_date)    AS day_name,      -- Saturday
    MONTHNAME(order_date)  AS month_name,    -- March
    DAYOFWEEK(order_date)  AS day_of_week,   -- 1=Sun, 7=Sat
    WEEK(order_date)       AS week_number,   -- 1-53
    QUARTER(order_date)    AS quarter        -- 1-4
FROM orders;

-- ─────────────────────────────────────────────
-- 3. Date arithmetic
-- ─────────────────────────────────────────────

-- Days between two dates
SELECT order_id, order_date,
       DATEDIFF(CURDATE(), order_date) AS days_since_order
FROM orders;

-- Add days/months/years
SELECT 
    CURDATE() AS today,
    DATE_ADD(CURDATE(), INTERVAL 7 DAY)    AS next_week,
    DATE_ADD(CURDATE(), INTERVAL 1 MONTH)  AS next_month,
    DATE_ADD(CURDATE(), INTERVAL 1 YEAR)   AS next_year,
    DATE_SUB(CURDATE(), INTERVAL 30 DAY)   AS thirty_days_ago;

-- Estimated delivery (7 days after order)
SELECT order_id, order_date,
       DATE_ADD(order_date, INTERVAL 7 DAY) AS estimated_delivery
FROM orders;

-- ─────────────────────────────────────────────
-- 4. Formatting dates
-- ─────────────────────────────────────────────

-- Common format specifiers:
-- %Y = 4-digit year    %y = 2-digit year
-- %M = Month name       %m = Month number (01-12)
-- %d = Day (01-31)      %D = Day with suffix (1st, 2nd)
-- %H = Hour (24h)       %h = Hour (12h)
-- %i = Minutes           %s = Seconds
-- %p = AM/PM             %W = Weekday name

SELECT order_id, order_date,
    DATE_FORMAT(order_date, '%d/%m/%Y')         AS british_format,
    DATE_FORMAT(order_date, '%M %d, %Y')        AS us_format,
    DATE_FORMAT(order_date, '%W, %D %M %Y')     AS full_format,
    DATE_FORMAT(order_date, '%d-%b-%Y')          AS short_format
FROM orders;

-- ─────────────────────────────────────────────
-- 5. Filtering by date parts
-- ─────────────────────────────────────────────

-- Orders from March 2025
SELECT * FROM orders
WHERE YEAR(order_date) = 2025 AND MONTH(order_date) = 3;

-- Orders from the last 30 days
SELECT * FROM orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Orders placed on a specific weekday
SELECT order_id, order_date, DAYNAME(order_date) AS day_name
FROM orders
WHERE DAYNAME(order_date) = 'Saturday';

-- ─────────────────────────────────────────────
-- 6. Time difference
-- ─────────────────────────────────────────────

SELECT 
    TIMESTAMPDIFF(HOUR, '2025-03-01 08:00:00', '2025-03-01 17:30:00')  AS hours_diff,
    TIMESTAMPDIFF(MINUTE, '2025-03-01 08:00:00', '2025-03-01 17:30:00') AS mins_diff,
    TIMESTAMPDIFF(DAY, '2025-01-01', '2025-12-31')                      AS days_in_year;
