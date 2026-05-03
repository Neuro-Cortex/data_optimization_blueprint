# Lab 04 — Intermediate SQL Queries

> **Duration:** 2 hours | **Type:** Lab Session | **CO:** CO1  
> **Goal:** Master JOINs, aggregate functions, GROUP BY, HAVING, subqueries, and set operations.  
> **Prerequisites:** Lab 02 E-Commerce database with sample data.

---

## 📋 Session Outline

| Time | Topic | Files |
|------|-------|-------|
| 0:00 – 0:20 | INNER JOIN | `01_inner_join.sql` |
| 0:20 – 0:35 | LEFT/RIGHT JOIN | `02_left_right_join.sql` |
| 0:35 – 0:45 | Self & Cross JOIN | `03_self_cross_join.sql` |
| 0:45 – 0:55 | Aggregate functions | `04_aggregate_functions.sql` |
| 0:55 – 1:05 | ☕ Break | — |
| 1:05 – 1:20 | GROUP BY & HAVING | `05_group_by_having.sql` |
| 1:20 – 1:35 | Subqueries | `06_subqueries.sql` |
| 1:35 – 1:45 | EXISTS & IN | `07_exists_in.sql` |
| 1:45 – 1:55 | UNION | `08_union_intersect.sql` |
| 1:55 – 2:00 | Lab Task | `labtask/` |

---

## 1. Joins — Combining Tables

### 1.1 Why JOINs?

In a normalized database, data is spread across multiple tables. To get meaningful answers, you need to **combine** them:

- "Which products belong to which category?" → products + categories
- "Who ordered what?" → customers + orders + order_items + products

> **Real-world analogy:** Think of JOINs like matching students to their sections using a shared `section_id`. The student table has the `section_id`, and the section table has the details. JOIN is how you look up the section name for each student.

### 1.2 How JOINs Work — The Matching Process

```mermaid
flowchart LR
    subgraph Step1["Pick a row from Table A"]
        A1["product_id=1, category_id=3"]
    end
    subgraph Step2["Find matching rows in Table B"]
        B1["category_id=3 Match"]
        B2["category_id=1 No"]
        B3["category_id=2 No"]
    end
    subgraph Step3["Combine into result"]
        R1["product_id=1, category=Electronics"]
    end
    A1 --> B1
    B1 --> R1
    style B1 fill:#2d6a4f,color:#fff
    style B2 fill:#6c757d,color:#fff
    style B3 fill:#6c757d,color:#fff
    style R1 fill:#1d3557,color:#fff
```

### 1.3 Types of JOINs — Visual Overview

```mermaid
graph TB
    J["SQL JOINs"] --> INNER["INNER JOIN"]
    J --> OUTER["OUTER JOINs"]
    J --> OTHER["Other JOINs"]
    OUTER --> LEFT["LEFT JOIN"]
    OUTER --> RIGHT["RIGHT JOIN"]
    OUTER --> FULL["FULL OUTER JOIN"]
    OTHER --> CROSS["CROSS JOIN"]
    OTHER --> SELF["SELF JOIN"]

    style INNER fill:#2d6a4f,color:#fff,stroke:#2d6a4f
    style LEFT fill:#1d3557,color:#fff,stroke:#1d3557
    style RIGHT fill:#6a1d55,color:#fff,stroke:#6a1d55
    style FULL fill:#7b2d8b,color:#fff,stroke:#7b2d8b
    style CROSS fill:#e76f51,color:#fff,stroke:#e76f51
    style SELF fill:#e9c46a,color:#000,stroke:#e9c46a
```

| JOIN Type | Description |
|---|---|
| **INNER JOIN** | Only matching rows from BOTH tables |
| **LEFT JOIN** | ALL from left + matching from right |
| **RIGHT JOIN** | ALL from right + matching from left |
| **FULL OUTER JOIN** | ALL from both (MySQL: use UNION) |
| **CROSS JOIN** | Every combination (Cartesian product) |
| **SELF JOIN** | A table joined with itself |

### 1.4 Quick Reference — What Each Join Returns

| JOIN Type | Returns | NULL Behavior |
|-----------|---------|---------------|
| `INNER JOIN` | Only rows that match in **both** tables | No NULLs from join |
| `LEFT JOIN` | **All** rows from left table + matching from right | NULL if no match on right |
| `RIGHT JOIN` | **All** rows from right table + matching from left | NULL if no match on left |
| `CROSS JOIN` | Every possible combination (Cartesian product) | No NULLs from join |
| `SELF JOIN` | A table joined with itself | Depends on join type used |

---

## 2. INNER JOIN

### 2.1 Concept — Only the Overlap

**INNER JOIN** returns only the rows that have a matching value in **both** tables. If a row in Table A has no match in Table B, it is **excluded** from the result.

```mermaid
flowchart LR
    subgraph TableA["🟦 Table A (products)"]
        A1["Laptop (cat_id=1)"]
        A2["Phone (cat_id=1)"]
        A3["Mystery Box (cat_id=NULL)"]
    end
    subgraph Result["✅ INNER JOIN Result"]
        R1["Laptop → Electronics"]
        R2["Phone → Electronics"]
    end
    subgraph TableB["🟩 Table B (categories)"]
        B1["cat_id=1: Electronics"]
        B2["cat_id=2: Books"]
    end
    A1 -->|"match"| R1
    A2 -->|"match"| R2
    A3 -.->|"❌ no match"| X1[ ]
    B2 -.->|"❌ no match"| X2[ ]

    style A3 fill:#e76f51,color:#fff
    style B2 fill:#e76f51,color:#fff
    style R1 fill:#2d6a4f,color:#fff
    style R2 fill:#2d6a4f,color:#fff
    style X1 fill:none,stroke:none
    style X2 fill:none,stroke:none
```

### 2.2 Example with Sample Data

**Given these tables:**

**products**

| product_id | name | price | category_id |
|:---:|---|---:|:---:|
| 1 | iPhone 15 | 129999.00 | 1 |
| 2 | Samsung Galaxy | 89999.00 | 1 |
| 3 | Cotton T-Shirt | 599.00 | 2 |
| 4 | Mystery Box | 999.00 | **NULL** |

**categories**

| category_id | name |
|:---:|---|
| 1 | Electronics |
| 2 | Clothing |
| 3 | Books |

**Query:**

```sql
SELECT p.name AS product, p.price, c.name AS category
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;
```

**Result:** _(only rows where `category_id` exists in BOTH tables)_

| product | price | category |
|---|---:|---|
| iPhone 15 | 129999.00 | Electronics |
| Samsung Galaxy | 89999.00 | Electronics |
| Cotton T-Shirt | 599.00 | Clothing |

> ❌ **"Mystery Box"** is excluded — it has `category_id = NULL`, which doesn't match anything.  
> ❌ **"Books"** category doesn't appear — no products have `category_id = 3`.

### 2.3 Multi-Table JOIN

You can chain multiple JOINs to connect 3, 4, or more tables:

```mermaid
flowchart LR
    OI["order_items"] -->|"order_id"| O["orders"]
    O -->|"customer_id"| CU["customers"]
    OI -->|"product_id"| P["products"]
    P -->|"category_id"| C["categories"]

    style OI fill:#264653,color:#fff
    style O fill:#2a9d8f,color:#fff
    style CU fill:#e9c46a,color:#000
    style P fill:#f4a261,color:#000
    style C fill:#e76f51,color:#fff
```

```sql
-- Products with their category names
SELECT p.name AS product, p.price, c.name AS category
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;

-- Orders with customer names
SELECT o.order_id, 
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       o.order_date, o.status, o.total_amount
FROM orders o
INNER JOIN customers cu ON o.customer_id = cu.customer_id;

-- Multi-table JOIN: order details with product and customer info
SELECT o.order_id,
       CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       p.name AS product,
       oi.quantity,
       oi.unit_price,
       (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN customers cu ON o.customer_id = cu.customer_id
INNER JOIN products p ON oi.product_id = p.product_id;
```

**Multi-table result example:**

| order_id | customer | product | quantity | unit_price | line_total |
|:---:|---|---|:---:|---:|---:|
| 1 | Rafiq Ahmed | iPhone 15 | 1 | 129999.00 | 129999.00 |
| 1 | Rafiq Ahmed | AirPods Pro | 2 | 24999.00 | 49998.00 |
| 2 | Nusrat Jahan | Cotton T-Shirt | 3 | 599.00 | 1797.00 |

---

## 3. LEFT / RIGHT JOIN

### 3.1 LEFT JOIN — Keep Everything from the Left

**LEFT JOIN** returns **all rows from the left table**, even if there's no match. If there's no match, the right table's columns are filled with `NULL`.

```mermaid
flowchart LR
    subgraph TableA["🟦 Table A (customers) — ALL KEPT"]
        A1["Rafiq (has orders)"]
        A2["Nusrat (has orders)"]
        A3["Kamal (NO orders)"]
    end
    subgraph Result["✅ LEFT JOIN Result"]
        R1["Rafiq → Order #1"]
        R2["Nusrat → Order #2"]
        R3["Kamal → NULL ⚠️"]
    end
    subgraph TableB["🟩 Table B (orders)"]
        B1["Order #1 (Rafiq)"]
        B2["Order #2 (Nusrat)"]
    end
    A1 -->|"match"| R1
    A2 -->|"match"| R2
    A3 -->|"no match → NULL"| R3

    style A3 fill:#e9c46a,color:#000
    style R3 fill:#e9c46a,color:#000
    style R1 fill:#2d6a4f,color:#fff
    style R2 fill:#2d6a4f,color:#fff
```

### 3.2 LEFT JOIN — Concrete Example

**customers**

| customer_id | first_name | last_name |
|:---:|---|---|
| 1 | Rafiq | Ahmed |
| 2 | Nusrat | Jahan |
| 3 | Kamal | Hossain |

**orders**

| order_id | customer_id | order_date | status |
|:---:|:---:|---|---|
| 101 | 1 | 2024-01-15 | delivered |
| 102 | 2 | 2024-02-20 | shipped |

**Query:**

```sql
SELECT cu.first_name, cu.last_name, o.order_id, o.order_date
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id;
```

**Result:**

| first_name | last_name | order_id | order_date |
|---|---|:---:|---|
| Rafiq | Ahmed | 101 | 2024-01-15 |
| Nusrat | Jahan | 102 | 2024-02-20 |
| Kamal | Hossain | **NULL** | **NULL** |

> ✅ Kamal appears even though he has no orders — the order columns are filled with **NULL**.

### 3.3 The "Find Missing" Pattern (LEFT JOIN + WHERE IS NULL)

This is one of the most practical patterns in SQL — finding records that **don't** have a corresponding entry in another table:

```mermaid
flowchart LR
    subgraph Step1["1. LEFT JOIN"]
        S1["All customers + orders, NULL if none"]
    end
    subgraph Step2["2. WHERE IS NULL"]
        S2["Filter to keep only NULLs"]
    end
    subgraph Step3["3. Result"]
        S3["Customers with no orders"]
    end
    Step1 --> Step2 --> Step3
    style Step1 fill:#1d3557,color:#fff
    style Step2 fill:#e76f51,color:#fff
    style Step3 fill:#2d6a4f,color:#fff
```

```sql
-- ALL products, even those without a category
SELECT p.name, p.price, c.name AS category
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;

-- Find products WITHOUT a category (orphaned products)
SELECT p.name, p.price
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;
```

**Before filter (LEFT JOIN only):**

| name | price | category |
|---|---:|---|
| iPhone 15 | 129999.00 | Electronics |
| Samsung Galaxy | 89999.00 | Electronics |
| Cotton T-Shirt | 599.00 | Clothing |
| Mystery Box | 999.00 | **NULL** |

**After filter (+ WHERE IS NULL):**

| name | price |
|---|---:|
| Mystery Box | 999.00 |

### 3.4 RIGHT JOIN

Same concept but reversed — **all rows from the right table** are kept.

```mermaid
flowchart LR
    subgraph TableA["🟦 Table A (products)"]
        A1["iPhone (cat=1)"]
        A2["T-Shirt (cat=2)"]
    end
    subgraph Result["✅ RIGHT JOIN Result"]
        R1["iPhone → Electronics"]
        R2["T-Shirt → Clothing"]
        R3["NULL → Books ⚠️"]
    end
    subgraph TableB["🟩 Table B (categories) — ALL KEPT"]
        B1["1: Electronics"]
        B2["2: Clothing"]
        B3["3: Books (no products)"]
    end
    A1 -->|"match"| R1
    A2 -->|"match"| R2
    B3 -->|"no match → NULL"| R3

    style B3 fill:#e9c46a,color:#000
    style R3 fill:#e9c46a,color:#000
    style R1 fill:#2d6a4f,color:#fff
    style R2 fill:#2d6a4f,color:#fff
```

```sql
-- ALL categories, even those with no products
SELECT c.name AS category, p.name AS product
FROM products p
RIGHT JOIN categories c ON p.category_id = c.category_id;

-- Find empty categories (no products)
SELECT c.name AS empty_category
FROM products p
RIGHT JOIN categories c ON p.category_id = c.category_id
WHERE p.product_id IS NULL;
```

**Result of RIGHT JOIN:**

| category | product |
|---|---|
| Electronics | iPhone 15 |
| Electronics | Samsung Galaxy |
| Clothing | Cotton T-Shirt |
| Books | **NULL** |

> **Tip:** `LEFT JOIN` is more common. You can always rewrite a `RIGHT JOIN` as a `LEFT JOIN` by swapping the table order.

### 3.5 LEFT vs INNER vs RIGHT — Side-by-Side Comparison

Let's use two tiny tables to see the difference clearly:

**Table A: `students`**

| id | name |
|:---:|---|
| 1 | Rafiq |
| 2 | Nusrat |
| 3 | Kamal |

**Table B: `enrollments`**

| student_id | course |
|:---:|---|
| 1 | RDBMS |
| 2 | OOP |
| 99 | Networking |

> Notice: **Kamal (id=3)** has no enrollment. **Networking (student_id=99)** has no matching student.

---

#### INNER JOIN — only matching rows

```sql
SELECT s.name, e.course
FROM students s
INNER JOIN enrollments e ON s.id = e.student_id;
```

| name | course |
|---|---|
| Rafiq | RDBMS |
| Nusrat | OOP |

> ❌ Kamal is gone (no enrollment). ❌ Networking is gone (no student).

---

#### LEFT JOIN — keep ALL students

```sql
SELECT s.name, e.course
FROM students s
LEFT JOIN enrollments e ON s.id = e.student_id;
```

| name | course |
|---|---|
| Rafiq | RDBMS |
| Nusrat | OOP |
| **Kamal** | **NULL** |

> ✅ Kamal is kept with NULL. ❌ Networking is still gone.

---

#### RIGHT JOIN — keep ALL enrollments

```sql
SELECT s.name, e.course
FROM students s
RIGHT JOIN enrollments e ON s.id = e.student_id;
```

| name | course |
|---|---|
| Rafiq | RDBMS |
| Nusrat | OOP |
| **NULL** | **Networking** |

> ❌ Kamal is gone. ✅ Networking is kept with NULL.

---

#### Summary

| Row | INNER | LEFT | RIGHT |
|---|:---:|:---:|:---:|
| Rafiq — RDBMS | ✅ | ✅ | ✅ |
| Nusrat — OOP | ✅ | ✅ | ✅ |
| Kamal — ??? | ❌ | ✅ (NULL) | ❌ |
| ??? — Networking | ❌ | ❌ | ✅ (NULL) |
| **Total rows** | **2** | **3** | **3** |

---

## 4. Self JOIN and Cross JOIN

### 4.1 Self JOIN — a Table Joined with Itself

A **self join** is when a table has a foreign key that points **back to its own primary key**. The classic example is an org chart:

```mermaid
graph TD
    CEO["Karim Rahman — CEO"]
    VP1["Fatima Begum — VP Engineering"]
    VP2["Rashid Khan — VP Sales"]
    DEV["Sadia Akter — Lead Dev"]
    SR["Nabil Hossain — Sr Dev"]
    SM["Tamim Iqbal — Sales Mgr"]
    JR["Jannatul Ferdous — Jr Dev"]

    CEO --> VP1
    CEO --> VP2
    VP1 --> DEV
    VP1 --> SR
    VP2 --> SM
    DEV --> JR

    style CEO fill:#e76f51,color:#fff
    style VP1 fill:#f4a261,color:#000
    style VP2 fill:#f4a261,color:#000
    style DEV fill:#e9c46a,color:#000
    style SR fill:#e9c46a,color:#000
    style SM fill:#e9c46a,color:#000
    style JR fill:#2a9d8f,color:#fff
```

The trick is to treat **the same table as two different tables** using aliases:

```mermaid
flowchart LR
    subgraph Same["employees table used TWICE"]
        E["e — Employee: Jannatul, manager_id=4"]
        M["m — Manager: Sadia, emp_id=4"]
    end
    subgraph Result["Result Row"]
        R["employee=Jannatul, manager=Sadia"]
    end
    E -->|"manager_id = emp_id"| M
    M --> R
    style E fill:#1d3557,color:#fff
    style M fill:#e76f51,color:#fff
    style R fill:#2d6a4f,color:#fff
```

```sql
-- Example: Employees table with manager hierarchy
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

INSERT INTO employees (name, manager_id) VALUES
    ('CEO', NULL), ('VP Sales', 1), ('VP Tech', 1),
    ('Sales Manager', 2), ('Developer', 3);

-- Find each employee's manager
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

DROP TABLE employees;
```

**Result:**

| employee | manager |
|---|---|
| CEO | **NULL** |
| VP Sales | CEO |
| VP Tech | CEO |
| Sales Manager | VP Sales |
| Developer | VP Tech |

> 💡 We use `LEFT JOIN` (not `INNER JOIN`) so the CEO (who has no manager) still appears.

### 4.2 Cross JOIN — Cartesian Product

**CROSS JOIN** combines **every row** from Table A with **every row** from Table B. If A has `m` rows and B has `n` rows, the result has `m × n` rows.

```mermaid
flowchart TB
    subgraph Sizes["sizes (4 rows)"]
        S1["S"]
        S2["M"]
        S3["L"]
        S4["XL"]
    end
    subgraph Colors["colors (3 rows)"]
        C1["Red"]
        C2["Blue"]
        C3["Black"]
    end
    subgraph Result["CROSS JOIN Result (4 × 3 = 12 rows)"]
        R1["S-Red, S-Blue, S-Black"]
        R2["M-Red, M-Blue, M-Black"]
        R3["L-Red, L-Blue, L-Black"]
        R4["XL-Red, XL-Blue, XL-Black"]
    end
    Sizes --> Result
    Colors --> Result
    style Result fill:#264653,color:#fff
```

**Example result:**

| size | color |
|:---:|---|
| S | Red |
| S | Blue |
| S | Black |
| M | Red |
| M | Blue |
| M | Black |
| L | Red |
| L | Blue |
| L | Black |
| XL | Red |
| XL | Blue |
| XL | Black |

```sql
-- Every product paired with every category (usually not useful)
SELECT p.name, c.name
FROM products p
CROSS JOIN categories c
LIMIT 20;
-- If 10 products × 5 categories = 50 rows
```

> ⚠️ **Be careful!** `CROSS JOIN` can produce enormous result sets. 1000 × 1000 = 1,000,000 rows!

### 4.3 JOIN Decision Guide — Which JOIN Do I Need?

```mermaid
flowchart TD
    Q1{"Need rows from BOTH tables?"}
    Q2{"Need ALL rows from one side?"}
    Q3{"Which side keeps all rows?"}
    Q4{"Table referencing itself?"}
    Q5{"Need every combination?"}

    INNER["Use INNER JOIN"]
    LEFT["Use LEFT JOIN"]
    RIGHT["Use RIGHT JOIN"]
    SELF["Use SELF JOIN"]
    CROSS["Use CROSS JOIN"]

    Q1 -->|"Yes, only matching"| INNER
    Q1 -->|"Maybe unmatched too"| Q2
    Q2 -->|"Yes"| Q3
    Q2 -->|"Table refers to itself?"| Q4
    Q2 -->|"Every combo"| Q5
    Q3 -->|"Left table"| LEFT
    Q3 -->|"Right table"| RIGHT
    Q4 -->|"Yes"| SELF
    Q5 -->|"Yes"| CROSS

    style INNER fill:#2d6a4f,color:#fff
    style LEFT fill:#1d3557,color:#fff
    style RIGHT fill:#6a1d55,color:#fff
    style SELF fill:#e9c46a,color:#000
    style CROSS fill:#e76f51,color:#fff
```

---

## 5. Aggregate Functions

Aggregate functions compute a **single value** from a set of rows.

| Function | Purpose | Example |
|----------|---------|---------|
| `COUNT(*)` | Count all rows | `SELECT COUNT(*) FROM products;` |
| `COUNT(col)` | Count non-NULL values | `COUNT(description)` |
| `SUM(col)` | Sum of values | `SUM(price * stock)` |
| `AVG(col)` | Average | `AVG(price)` |
| `MIN(col)` | Minimum value | `MIN(price)` |
| `MAX(col)` | Maximum value | `MAX(price)` |

### 5.1 Visual — How Aggregates Collapse Rows

```mermaid
flowchart LR
    subgraph Input["Input: 5 Rows"]
        R1["Laptop: 85,000"]
        R2["Phone: 130,000"]
        R3["T-Shirt: 599"]
        R4["Mouse: 1,200"]
        R5["Headphones: 4,500"]
    end
    subgraph Output["Aggregate Output: 1 Row"]
        O1["COUNT=5"]
        O2["MIN=599"]
        O3["MAX=130,000"]
        O4["AVG=44,259"]
        O5["SUM=221,299"]
    end
    Input -->|"aggregate functions"| Output
    style Output fill:#2d6a4f,color:#fff
```

```sql
-- Product statistics
SELECT 
    COUNT(*) AS total_products,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive,
    ROUND(AVG(price), 2) AS average_price,
    SUM(stock) AS total_stock,
    SUM(price * stock) AS total_inventory_value
FROM products;
```

**Result (single row):**

| total_products | cheapest | most_expensive | average_price | total_stock | total_inventory_value |
|:---:|---:|---:|---:|:---:|---:|
| 10 | 299.00 | 129999.00 | 28459.70 | 750 | 21344775.00 |

---

## 6. GROUP BY and HAVING

### 6.1 GROUP BY — Group Rows by Column

`GROUP BY` splits the rows into groups, then applies aggregate functions **per group**.

```mermaid
flowchart LR
    subgraph Input["All Products"]
        R1["Laptop — Electronics"]
        R2["Phone — Electronics"]
        R3["Mouse — Electronics"]
        R4["T-Shirt — Clothing"]
        R5["Jeans — Clothing"]
        R6["Novel — Books"]
    end
    subgraph Groups["GROUP BY category"]
        G1["Electronics: Laptop, Phone, Mouse"]
        G2["Clothing: T-Shirt, Jeans"]
        G3["Books: Novel"]
    end
    subgraph Result["COUNT per group"]
        O1["Electronics: 3"]
        O2["Clothing: 2"]
        O3["Books: 1"]
    end
    Input --> Groups --> Result
    style G1 fill:#264653,color:#fff
    style G2 fill:#2a9d8f,color:#fff
    style G3 fill:#e9c46a,color:#000
```

```sql
-- Count products per category
SELECT c.name AS category, COUNT(*) AS product_count
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name;

-- Total revenue per customer
SELECT CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       COUNT(o.order_id) AS order_count,
       SUM(o.total_amount) AS total_spent
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id;
```

**Example result:**

| category | product_count |
|---|:---:|
| Electronics | 4 |
| Clothing | 3 |
| Books | 2 |
| Home & Kitchen | 1 |

### 6.2 HAVING — Filtering Groups (like WHERE but for Aggregates)

```mermaid
flowchart LR
    subgraph Step1["① GROUP BY"]
        direction TB
        G1["Electronics: 4 products"]
        G2["Clothing: 3 products"]
        G3["Books: 2 products"]
        G4["Home: 1 product"]
    end
    subgraph Step2["② HAVING COUNT > 2"]
        direction TB
        H1["Electronics: 4 ✅"]
        H2["Clothing: 3 ✅"]
        H3["Books: 2 ❌"]
        H4["Home: 1 ❌"]
    end
    subgraph Result["③ Final Result"]
        direction TB
        R1["Electronics: 4"]
        R2["Clothing: 3"]
    end
    Step1 --> Step2 --> Result
    style H1 fill:#2d6a4f,color:#fff
    style H2 fill:#2d6a4f,color:#fff
    style H3 fill:#e76f51,color:#fff
    style H4 fill:#e76f51,color:#fff
```

```sql
-- Categories with more than 2 products
SELECT c.name, COUNT(*) AS product_count
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
HAVING COUNT(*) > 2;

-- Customers who spent more than 50,000 BDT
SELECT CONCAT(cu.first_name, ' ', cu.last_name) AS customer,
       SUM(o.total_amount) AS total_spent
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id
HAVING SUM(o.total_amount) > 50000;
```

### 6.3 WHERE vs HAVING — Execution Order

```mermaid
flowchart LR
    A["FROM + JOINs"] --> B["WHERE"] --> C["GROUP BY"] --> D["HAVING"] --> E["SELECT"] --> F["ORDER BY"]

    style B fill:#e76f51,color:#fff
    style D fill:#2d6a4f,color:#fff
```

| | WHERE | HAVING |
|---|---|---|
| Filters | Individual rows | Groups |
| Runs | **Before** GROUP BY | **After** GROUP BY |
| Can use aggregates? | ❌ No | ✅ Yes |

**Example — using both together:**

```sql
-- Categories with more than 2 ACTIVE products priced above 500 BDT
SELECT c.name, COUNT(*) AS product_count
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.price > 500         -- ← filters individual rows FIRST
  AND p.is_active = TRUE
GROUP BY c.name
HAVING COUNT(*) > 2;        -- ← then filters the groups
```

---

## 7. Subqueries

A subquery is a query nested inside another query.

### 7.1 Scalar Subquery (returns single value)

```mermaid
flowchart LR
    subgraph Inner["Inner Query"]
        IQ["AVG of price = 28459.70"]
    end
    subgraph Outer["Outer Query"]
        OQ["WHERE price > 28459.70"]
    end
    Inner -->|"single value"| Outer
    style Inner fill:#1d3557,color:#fff
    style Outer fill:#2d6a4f,color:#fff
```

```sql
-- Products priced above average
SELECT name, price FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Most expensive product
SELECT name, price FROM products
WHERE price = (SELECT MAX(price) FROM products);
```

### 7.2 Row Subquery (returns multiple values)

```sql
-- Products in the most popular category
SELECT name, price FROM products
WHERE category_id = (
    SELECT category_id FROM products
    GROUP BY category_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
```

### 7.3 Table Subquery (returns a result set)

```sql
-- Customers who have placed orders
SELECT first_name, last_name FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM orders
);
```

### 7.4 Correlated Subquery

A **correlated subquery** runs once for **each row** in the outer query — it references the outer query's columns.

```mermaid
flowchart TB
    subgraph Outer["Outer: for EACH product row"]
        P1["Laptop, category_id=1, price=85000"]
    end
    subgraph Inner["Inner: runs for THIS row"]
        IQ["AVG price WHERE category_id=1 = 72000"]
    end
    subgraph Check["Comparison"]
        CK["85000 > 72000? YES, include row"]
    end
    Outer -->|"category_id=1"| Inner
    Inner -->|"72000"| Check
    style Outer fill:#1d3557,color:#fff
    style Inner fill:#e76f51,color:#fff
    style Check fill:#2d6a4f,color:#fff
```

```sql
-- Products priced above their category's average
SELECT p.name, p.price, p.category_id
FROM products p
WHERE p.price > (
    SELECT AVG(p2.price) FROM products p2
    WHERE p2.category_id = p.category_id
);
```

**Step-by-step for Electronics (category_id=1):**

| product | price | category avg | Above avg? |
|---|---:|---:|:---:|
| iPhone 15 | 129999 | 72000 | ✅ Yes |
| Samsung Galaxy | 89999 | 72000 | ✅ Yes |
| Mouse | 1200 | 72000 | ❌ No |
| Headphones | 4500 | 72000 | ❌ No |

---

## 8. EXISTS vs IN

### 8.1 EXISTS — Checks if Subquery Returns Any Rows

`EXISTS` returns `TRUE` if the subquery produces **at least one row**, and `FALSE` if it produces zero rows. It doesn't care about the actual values.

```mermaid
flowchart LR
    subgraph ForEachRow["For each customer row"]
        CU["customer_id=1, Rafiq Ahmed"]
    end
    subgraph Subquery["Subquery"]
        SQ["SELECT 1 FROM orders WHERE customer_id=1 ... Found 2 rows"]
    end
    subgraph Decision["EXISTS?"]
        D["2 rows > 0, EXISTS = TRUE, include Rafiq"]
    end
    ForEachRow --> Subquery --> Decision
    style Decision fill:#2d6a4f,color:#fff
```

```sql
-- Customers who have orders
SELECT first_name, last_name FROM customers cu
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = cu.customer_id
);

-- Customers who have NOT ordered
SELECT first_name, last_name FROM customers cu
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = cu.customer_id
);
```

### 8.2 IN vs EXISTS — When to Use Which

```mermaid
flowchart TD
    Q["Which should I use?"]
    Q -->|"Small subquery result"| IN_USE["Use IN"]
    Q -->|"Small outer table"| EXISTS_USE["Use EXISTS"]
    Q -->|"NULLs in subquery"| EXISTS_SAFE["Use EXISTS"]

    style IN_USE fill:#1d3557,color:#fff
    style EXISTS_USE fill:#2d6a4f,color:#fff
    style EXISTS_SAFE fill:#e9c46a,color:#000
```

| | `IN` | `EXISTS` |
|---|---|---|
| Best when | Subquery result is **small** | Outer table is **small** |
| Evaluates | Entire subquery first | Stops at first match |
| NULL handling | Can give unexpected results | Handles NULLs correctly |

---

## 9. Set Operations

### 9.1 UNION — Combining Result Sets

`UNION` stacks two queries on top of each other (vertically), removing duplicates. `UNION ALL` keeps duplicates.

```mermaid
flowchart TB
    subgraph Q1["Query 1 Results"]
        direction TB
        A1["Dhaka"]
        A2["Chittagong"]
        A3["Dhaka"]
    end
    subgraph Q2["Query 2 Results"]
        direction TB
        B1["Chittagong"]
        B2["Sylhet"]
    end
    subgraph UNION_R["UNION (no duplicates)"]
        direction TB
        U1["Dhaka"]
        U2["Chittagong"]
        U3["Sylhet"]
    end
    subgraph UNION_ALL_R["UNION ALL (keep duplicates)"]
        direction TB
        V1["Dhaka"]
        V2["Chittagong"]
        V3["Dhaka"]
        V4["Chittagong"]
        V5["Sylhet"]
    end
    Q1 --> UNION_R
    Q2 --> UNION_R
    Q1 --> UNION_ALL_R
    Q2 --> UNION_ALL_R
    style UNION_R fill:#2d6a4f,color:#fff
    style UNION_ALL_R fill:#1d3557,color:#fff
```

```sql
-- UNION: combine results, remove duplicates
SELECT city FROM customers
UNION
SELECT 'Online' AS city;

-- UNION ALL: combine results, KEEP duplicates (faster)
SELECT city FROM customers
UNION ALL
SELECT city FROM customers;
```

### 9.2 UNION Rules

| Rule | Explanation |
|------|-------------|
| Same number of columns | Both queries must return the same column count |
| Compatible data types | Column 1 in Query A must match Column 1 in Query B |
| Column names from first query | The result uses column names from the first SELECT |

---

## ⚠️ Common Pitfalls

| Mistake | Problem | Fix |
|---------|---------|-----|
| SELECT non-grouped column | Error or random value | Add to GROUP BY or use aggregate |
| HAVING without GROUP BY | Treats entire result as one group | Add GROUP BY first |
| Cartesian product | Missing JOIN condition → millions of rows | Always specify ON clause |
| Wrong JOIN type | Missing data or extra NULLs | Choose LEFT/INNER carefully |
| Subquery returns multiple rows with `=` | Error | Use `IN` instead of `=` |

---

## 📐 Complete JOIN Cheatsheet

| JOIN | SQL Pattern | Use Case | Row Count |
|------|-------------|----------|-----------|
| **INNER** | `A INNER JOIN B ON A.id = B.id` | Show only matching data | ≤ min(A, B) |
| **LEFT** | `A LEFT JOIN B ON A.id = B.id` | Keep all from A, even without match | ≥ rows in A |
| **RIGHT** | `A RIGHT JOIN B ON A.id = B.id` | Keep all from B, even without match | ≥ rows in B |
| **CROSS** | `A CROSS JOIN B` | Generate all combinations | A × B |
| **SELF** | `A e1 JOIN A e2 ON e1.col = e2.col` | Hierarchy, compare rows | Varies |
| **LEFT + NULL** | `A LEFT JOIN B ... WHERE B.key IS NULL` | Find orphans / missing | ≤ rows in A |

---

## 🔗 In the Industry

- **JOINs** are the backbone of every reporting system and business intelligence tool
- **GROUP BY** powers every dashboard chart: sales per month, users per country
- **Subqueries** are used in complex filtering but **CTEs** (Common Table Expressions) are preferred in modern SQL
- **EXISTS** is often faster than `IN` for large datasets — database optimizers are smart but not perfect

---

## 🧪 Lab Task 4 — Analytical Query Challenge

**Duration:** 40 minutes  
**Difficulty:** ⭐⭐⭐⭐ (Medium-Hard)

Write 12 queries using the `ecommerce_db`:

1. List all products with their category name
2. List all orders with customer full name and order status
3. Show full order details: order ID, customer name, product name, quantity, unit price, line total
4. Find categories that have no products (empty categories)
5. Find customers who have not placed any orders
6. Count the number of products per category
7. Show total revenue per category (sum of quantity × unit_price in order_items)
8. Find the most expensive product in each category
9. Find customers who have spent more than 100,000 BDT total
10. Find products that are priced above the overall average price
11. Find the category with the highest total revenue
12. List orders that contain more than 2 items

### Grading Criteria

| Criteria | Points |
|----------|:------:|
| Queries 1–4 (JOINs) | 30 |
| Queries 5–8 (GROUP BY, LEFT JOIN) | 30 |
| Queries 9–12 (Subqueries, Complex) | 30 |
| Code formatting and comments | 10 |
| **Total** | **100** |

---

**📁 Reference Solution:** `lab_04_intermediate_sql/labtask/solution.sql`
