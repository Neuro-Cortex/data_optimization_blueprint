# Lab 03 — Basic SQL Queries

> **Duration:** 2 hours | **Type:** Lab Session | **CO:** CO1  
> **Goal:** Master the SELECT statement — filtering, operators, functions, sorting, and pagination.  
> **Prerequisites:** Lab 02 E-Commerce database must be created with sample data.

---

## 📋 Session Outline

| Time | Topic | Files |
|------|-------|-------|
| 0:00 – 0:15 | SELECT and WHERE basics | `01_select_where.sql` |
| 0:15 – 0:30 | Comparison operators | `02_comparison_operators.sql` |
| 0:30 – 0:45 | Math operations | `03_math_operations.sql` |
| 0:45 – 0:55 | String functions | `04_string_functions.sql` |
| 0:55 – 1:05 | ☕ Break | — |
| 1:05 – 1:15 | Date functions | `05_date_functions.sql` |
| 1:15 – 1:25 | NULL handling | `06_null_handling.sql` |
| 1:25 – 1:35 | ORDER BY, LIMIT, OFFSET | `07_order_limit.sql` |
| 1:35 – 1:45 | DISTINCT and aliases | `08_distinct_aliases.sql` |
| 1:45 – 2:00 | Lab Task | `labtask/` |

---

## 0. Database Setup

All examples use the E-Commerce database from Lab 02. If you haven't created it yet, run `lab_02_database_design/labtask/solution.sql` first.

```sql
USE ecommerce_db;
```

---

## 1. SELECT and WHERE

### 1.1 Basic SELECT

```sql
-- All columns, all rows
SELECT * FROM products;

-- Specific columns only
SELECT name, price, stock FROM products;

-- With a filter
SELECT name, price FROM products WHERE price > 10000;
```

### 1.2 WHERE with Logical Operators

| Operator | Meaning |
|:--------:|---------|
| `AND` | Both conditions must be true |
| `OR` | At least one condition must be true |
| `NOT` | Reverses the condition |

```sql
-- AND: Electronics AND price over 50,000
SELECT name, price FROM products
WHERE category_id = 1 AND price > 50000;

-- OR: Electronics OR Sports
SELECT name, price, category_id FROM products
WHERE category_id = 1 OR category_id = 5;

-- NOT: Not in Clothing category
SELECT name, price FROM products
WHERE NOT category_id = 2;

-- Combined: (Electronics OR Books) AND price under 30,000
SELECT name, price, category_id FROM products
WHERE (category_id = 1 OR category_id = 3) AND price < 30000;
```

> ⚠️ **Pitfall:** Without parentheses, `AND` binds tighter than `OR`. Always use parentheses to make intent clear.

---

## 2. Comparison Operators

| Operator | Meaning | Example |
|:--------:|---------|---------|
| `=` | Equal to | `WHERE city = 'Dhaka'` |
| `<>` or `!=` | Not equal to | `WHERE status <> 'cancelled'` |
| `>` | Greater than | `WHERE price > 1000` |
| `<` | Less than | `WHERE stock < 10` |
| `>=` | Greater than or equal | `WHERE gpa >= 3.5` |
| `<=` | Less than or equal | `WHERE price <= 5000` |
| `BETWEEN` | In a range (inclusive) | `WHERE price BETWEEN 1000 AND 5000` |
| `IN` | Matches any in a list | `WHERE city IN ('Dhaka', 'Sylhet')` |
| `LIKE` | Pattern matching | `WHERE name LIKE '%phone%'` |

### 2.1 BETWEEN

```sql
-- Products priced between 1,000 and 10,000 BDT
SELECT name, price FROM products
WHERE price BETWEEN 1000 AND 10000;
-- Same as: WHERE price >= 1000 AND price <= 10000
```

### 2.2 IN

```sql
-- Customers from specific cities
SELECT first_name, last_name, city FROM customers
WHERE city IN ('Dhaka', 'Chittagong', 'Sylhet');

-- NOT IN
SELECT first_name, city FROM customers
WHERE city NOT IN ('Dhaka');
```

### 2.3 LIKE (Pattern Matching)

| Pattern | Matches |
|:-------:|---------|
| `'A%'` | Starts with A |
| `'%phone'` | Ends with "phone" |
| `'%code%'` | Contains "code" |
| `'_haka'` | 5 chars, ending in "haka" |
| `'R____'` | Exactly 5 chars, starting with R |

```sql
-- Products containing "phone" (case-insensitive in MySQL)
SELECT name FROM products WHERE name LIKE '%phone%';

-- Customers whose name starts with 'A'
SELECT first_name, last_name FROM customers
WHERE first_name LIKE 'A%';

-- Emails from Gmail
SELECT first_name, email FROM customers
WHERE email LIKE '%@gmail.com';
```

> 📁 **See:** `examples/01_select_where.sql` and `examples/02_comparison_operators.sql`

---

## 3. Math Operations

SQL can perform arithmetic directly in queries:

```sql
-- Calculate discounted price (20% off)
SELECT name, price, price * 0.80 AS discounted_price
FROM products;

-- Calculate total inventory value
SELECT name, price, stock, (price * stock) AS inventory_value
FROM products;

-- Price with 15% VAT
SELECT name, price, price * 1.15 AS price_with_vat
FROM products;

-- Useful math functions
SELECT 
    ABS(-25)      AS absolute_value,    -- 25
    CEIL(4.3)     AS ceiling,           -- 5
    FLOOR(4.7)    AS floored,           -- 4
    ROUND(3.456, 2)  AS rounded,        -- 3.46
    MOD(10, 3)    AS modulo,            -- 1
    POWER(2, 10)  AS power_result,      -- 1024
    SQRT(144)     AS square_root;       -- 12
```

> 📁 **See:** `examples/03_math_operations.sql`

---

## 4. String Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `CONCAT(a, b)` | Join strings | `CONCAT(first, ' ', last)` |
| `UPPER(s)` | To uppercase | `UPPER('hello')` → `'HELLO'` |
| `LOWER(s)` | To lowercase | `LOWER('HELLO')` → `'hello'` |
| `LENGTH(s)` | Character count | `LENGTH('Dhaka')` → `5` |
| `SUBSTRING(s, start, len)` | Extract part | `SUBSTRING('Hello', 1, 3)` → `'Hel'` |
| `TRIM(s)` | Remove spaces | `TRIM('  hi  ')` → `'hi'` |
| `REPLACE(s, old, new)` | Replace text | `REPLACE('abc', 'b', 'x')` → `'axc'` |
| `LEFT(s, n)` | First n chars | `LEFT('Hello', 3)` → `'Hel'` |
| `RIGHT(s, n)` | Last n chars | `RIGHT('Hello', 3)` → `'llo'` |
| `REVERSE(s)` | Reverse string | `REVERSE('abc')` → `'cba'` |

```sql
-- Full name from first + last
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- Email username (before @)
SELECT email, SUBSTRING_INDEX(email, '@', 1) AS username
FROM customers;

-- Uppercase product names
SELECT UPPER(name) AS product_name, price
FROM products;
```

> 📁 **See:** `examples/04_string_functions.sql`

---

## 5. Date Functions

| Function | Returns | Example |
|----------|---------|---------|
| `NOW()` | Current date+time | `2025-03-03 14:30:00` |
| `CURDATE()` | Current date | `2025-03-03` |
| `CURTIME()` | Current time | `14:30:00` |
| `YEAR(d)` | Year part | `YEAR('2025-03-03')` → `2025` |
| `MONTH(d)` | Month part | `MONTH('2025-03-03')` → `3` |
| `DAY(d)` | Day part | `DAY('2025-03-03')` → `3` |
| `DATEDIFF(d1, d2)` | Days between | `DATEDIFF('2025-03-10', '2025-03-01')` → `9` |
| `DATE_ADD(d, INTERVAL)` | Add to date | `DATE_ADD('2025-03-01', INTERVAL 7 DAY)` |
| `DATE_FORMAT(d, fmt)` | Format output | `DATE_FORMAT(NOW(), '%d/%m/%Y')` |

```sql
-- Orders from March 2025
SELECT * FROM orders
WHERE YEAR(order_date) = 2025 AND MONTH(order_date) = 3;

-- Days since order was placed
SELECT order_id, order_date,
       DATEDIFF(CURDATE(), order_date) AS days_ago
FROM orders;

-- Format order dates nicely
SELECT order_id,
       DATE_FORMAT(order_date, '%d %b %Y') AS formatted_date
FROM orders;
```

> 📁 **See:** `examples/05_date_functions.sql`

---

## 6. NULL Handling

`NULL` means **unknown/missing** — it's not zero, not empty string, not false.

### 6.1 Key Rules

- `NULL = NULL` → `NULL` (not TRUE!)
- `NULL <> 'abc'` → `NULL` (not TRUE!)
- Any arithmetic with NULL → `NULL`
- Use `IS NULL` / `IS NOT NULL` to test

```sql
-- Find products with no description
SELECT name FROM products WHERE description IS NULL;

-- Find products that DO have a description
SELECT name FROM products WHERE description IS NOT NULL;

-- COALESCE: return first non-NULL value
SELECT name, COALESCE(description, 'No description available') AS desc
FROM products;

-- IFNULL: MySQL-specific (simpler for two args)
SELECT name, IFNULL(phone, 'N/A') AS phone
FROM customers;
```

### 6.2 NULL in Math

```sql
SELECT 10 + NULL;    -- NULL (not 10!)
SELECT NULL * 5;     -- NULL
SELECT NULL = NULL;  -- NULL (not TRUE!)
```

> 📁 **See:** `examples/06_null_handling.sql`

---

## 7. ORDER BY, LIMIT, OFFSET

### 7.1 Sorting

```sql
-- Sort by price ascending (cheapest first — default)
SELECT name, price FROM products ORDER BY price;

-- Sort descending (most expensive first)
SELECT name, price FROM products ORDER BY price DESC;

-- Multi-column sort: by category, then by price desc
SELECT name, category_id, price FROM products
ORDER BY category_id ASC, price DESC;

-- Sort by column position (not recommended but possible)
SELECT name, price FROM products ORDER BY 2 DESC;
```

### 7.2 LIMIT and OFFSET (Pagination)

```sql
-- Top 3 most expensive products
SELECT name, price FROM products ORDER BY price DESC LIMIT 3;

-- Pagination: page 1 (items 1-3)
SELECT name, price FROM products ORDER BY price DESC LIMIT 3 OFFSET 0;

-- Page 2 (items 4-6)
SELECT name, price FROM products ORDER BY price DESC LIMIT 3 OFFSET 3;

-- Alternative syntax: LIMIT offset, count
SELECT name, price FROM products ORDER BY price DESC LIMIT 3, 3;
```

> 📁 **See:** `examples/07_order_limit.sql`

---

## 8. DISTINCT and Aliases

### 8.1 DISTINCT

```sql
-- All unique cities
SELECT DISTINCT city FROM customers;

-- Unique category IDs in products
SELECT DISTINCT category_id FROM products;

-- Unique combinations
SELECT DISTINCT city, gender FROM customers;
```

### 8.2 Column Aliases

```sql
-- Rename columns in output
SELECT name AS product_name, price AS "Price (BDT)"
FROM products;

-- Calculated column with alias
SELECT name, price * 0.85 AS sale_price
FROM products;
```

### 8.3 Table Aliases

```sql
-- Short table names for convenience
SELECT p.name, p.price, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.category_id;
```

> 📁 **See:** `examples/08_distinct_aliases.sql`

---

## ⚠️ Common Pitfalls

| Mistake | Problem | Fix |
|---------|---------|-----|
| `WHERE name = NULL` | Never TRUE (NULL ≠ NULL) | Use `WHERE name IS NULL` |
| Missing `%` in LIKE | `LIKE 'phone'` matches exact "phone" only | `LIKE '%phone%'` for contains |
| LIMIT without ORDER BY | Random rows returned | Always ORDER BY before LIMIT |
| `'` inside strings | Syntax error | Escape: `'it''s'` or use `"it's"` |
| Forgetting parentheses | `A OR B AND C` ≠ `(A OR B) AND C` | Always use parentheses |

---

## 🔗 In the Industry

- **Pagination** (`LIMIT`/`OFFSET`) is used on every page of Google, Amazon, Facebook
- **String functions** are essential for data cleaning and ETL pipelines
- **Date functions** power reporting dashboards and analytics
- **NULL handling** is one of the most common sources of bugs in production systems

---

## 🧪 Lab Task 3 — SQL Query Challenge

**Duration:** 30–40 minutes  
**Difficulty:** ⭐⭐⭐ (Medium)

Write 15 queries on the `ecommerce_db` database:

1. List all products with name and price
2. Find all customers from Dhaka
3. Find products priced between 1,000 and 5,000 BDT
4. Find products whose name contains "Shirt" or "Shoe"
5. List all pending orders
6. Show products sorted by price (most expensive first)
7. Show the top 5 cheapest products
8. List products not in the Electronics category
9. Show customer full names (first + last) and their emails
10. Calculate the total inventory value (price × stock) for each product
11. Show products with a 25% discount applied
12. Find orders placed in March 2025
13. Show how many days ago each order was placed
14. Find customers whose email is from Gmail
15. Show products with no description (NULL)

### Grading Criteria

| Criteria | Points |
|----------|:------:|
| Queries 1–5 correct (basic) | 25 |
| Queries 6–10 correct (intermediate) | 30 |
| Queries 11–15 correct (functions/NULL) | 30 |
| Code formatting and comments | 15 |
| **Total** | **100** |

---

**📁 Reference Solution:** `lab_03_basic_sql/labtask/solution.sql`
