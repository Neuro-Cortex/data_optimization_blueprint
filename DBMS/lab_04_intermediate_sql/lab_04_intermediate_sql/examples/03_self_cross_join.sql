-- ============================================================
-- Lab 04 | Example 03: Self JOIN and Cross JOIN
-- ============================================================

USE ecommerce_db;

-- ─────────────────────────────────────────────
-- 1. SELF JOIN — joining a table with itself
-- ─────────────────────────────────────────────

-- Create an employees table with manager hierarchy
CREATE TABLE employees (
    emp_id     INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    position   VARCHAR(100),
    salary     DECIMAL(10,2),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

INSERT INTO employees (name, position, salary, manager_id) VALUES
    ('Karim Rahman', 'CEO', 200000, NULL),
    ('Fatima Begum', 'VP Engineering', 150000, 1),
    ('Rashid Khan', 'VP Sales', 140000, 1),
    ('Sadia Akter', 'Lead Developer', 100000, 2),
    ('Nabil Hossain', 'Senior Developer', 85000, 2),
    ('Tamim Iqbal', 'Sales Manager', 90000, 3),
    ('Jannatul Ferdous', 'Junior Developer', 60000, 4);

-- Find each employee's manager
SELECT e.name AS employee, 
       e.position,
       COALESCE(m.name, 'No Manager') AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Find employees who earn more than their manager
SELECT e.name AS employee, e.salary AS emp_salary,
       m.name AS manager, m.salary AS mgr_salary
FROM employees e
INNER JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- Find products in the same category (pairs)
SELECT p1.name AS product_1, p2.name AS product_2, 
       c.name AS category
FROM products p1
INNER JOIN products p2 ON p1.category_id = p2.category_id
                       AND p1.product_id < p2.product_id
INNER JOIN categories c ON p1.category_id = c.category_id;

DROP TABLE employees;

-- ─────────────────────────────────────────────
-- 2. CROSS JOIN — Cartesian product
-- ─────────────────────────────────────────────

-- Create small tables for demo
CREATE TABLE sizes (size VARCHAR(5));
CREATE TABLE colors (color VARCHAR(20));

INSERT INTO sizes VALUES ('S'), ('M'), ('L'), ('XL');
INSERT INTO colors VALUES ('Red'), ('Blue'), ('Black');

-- Every size-color combination
SELECT s.size, cl.color
FROM sizes s
CROSS JOIN colors cl
ORDER BY s.size, cl.color;
-- 4 sizes × 3 colors = 12 combinations

-- Alternative syntax (implicit cross join)
SELECT s.size, cl.color
FROM sizes s, colors cl
ORDER BY s.size, cl.color;

DROP TABLE sizes;
DROP TABLE colors;
