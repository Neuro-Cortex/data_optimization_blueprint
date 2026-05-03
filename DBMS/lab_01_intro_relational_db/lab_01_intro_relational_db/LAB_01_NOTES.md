# Lab 01 — Introduction to Relational Databases & MySQL Setup

> **Duration:** 2 hours | **Type:** Lab Session | **CO:** CO2  
> **Goal:** Students will be familiarized with relational database systems and the environment to work with them.

---

## 📋 Session Outline

| Time | Topic | Files |
|------|-------|-------|
| 0:00 – 0:20 | Course overview & RDBMS theory | — |
| 0:20 – 0:40 | MySQL installation & tools | — |
| 0:40 – 0:55 | Creating databases & data types | `01_create_database.sql`, `02_data_types.sql` |
| 0:55 – 1:05 | ☕ Break | — |
| 1:05 – 1:30 | Creating tables with constraints | `03_create_tables.sql` |
| 1:30 – 1:45 | Inserting & querying data | `04_insert_data.sql`, `05_basic_select.sql` |
| 1:45 – 2:00 | Lab Task briefing | `labtask/` |

---

## 1. Course Overview

Welcome to **Relational Database Management Systems Lab**. This semester we will:

1. **Design** relational databases from real-world case studies (ERD, normalization)
2. **Implement** databases using MySQL with SQL queries (basic → advanced)
3. **Build** web applications using PHP + MySQL
4. **Develop** a team project using database theories and techniques
5. **Secure** databases with user management, privileges, and backup strategies

### Course Assessment

| Component | CO | Weight |
|-----------|:--:|:------:|
| Attendance | — | 5% |
| Class Performance | CO1 | 20% |
| Presentation, Report & Viva | CO3 | 25% |
| Project Development | CO4 | 10% |
| Lab Quiz | CO2 | 40% |

### Tools We'll Use

- **MySQL 8.x** — Our relational database engine
- **MySQL Workbench** — GUI for database design and queries
- **MySQL CLI** — Command-line interface for quick queries
- **XAMPP** — Apache + PHP + MySQL stack (for Lab 5 onwards)
- **VS Code** — For editing SQL files and PHP code

---

## 2. What is a Database?

A **database** is an organized collection of structured data stored electronically. Think of it as a digital filing cabinet that allows you to:

- **Store** millions of records efficiently
- **Retrieve** specific data in milliseconds
- **Update** data without inconsistency
- **Share** data across multiple users simultaneously

### 2.1 Why Not Just Use Excel?

| Feature | Spreadsheet | Database |
|---------|:-----------:|:--------:|
| Handle millions of rows | ❌ Slow/crashes | ✅ Optimized |
| Multiple simultaneous users | ❌ Conflicts | ✅ Concurrency control |
| Data validation rules | ⚠️ Limited | ✅ Constraints |
| Relationships between data | ❌ Manual | ✅ Foreign keys |
| Security & access control | ❌ File-level | ✅ User/role-level |
| Backup & recovery | ❌ Manual | ✅ Built-in tools |

### 2.2 Types of Databases

| Type | Examples | Best For |
|------|---------|----------|
| **Relational (RDBMS)** | MySQL, PostgreSQL, Oracle, SQL Server | Structured data with relationships |
| **NoSQL (Document)** | MongoDB, CouchDB | Flexible, schema-less data |
| **NoSQL (Key-Value)** | Redis, DynamoDB | Caching, sessions |
| **NoSQL (Graph)** | Neo4j | Social networks, recommendations |

> **This course focuses on RDBMS** — the most widely used type in enterprise applications.

---

## 3. Relational Database Concepts

### 3.1 The Relational Model

A relational database organizes data into **tables** (also called **relations**). Each table has:

- **Columns** (attributes) — define what data is stored
- **Rows** (tuples/records) — each row is one data entry
- **Primary Key (PK)** — uniquely identifies each row
- **Foreign Key (FK)** — links one table to another

**Example: A `students` table**

| student_id (PK) | name | email | gpa |
|:---:|---|---|:---:|
| 1 | Rafiq Ahmed | rafiq@uiu.ac.bd | 3.75 |
| 2 | Nusrat Jahan | nusrat@uiu.ac.bd | 3.90 |
| 3 | Tanvir Hasan | tanvir@uiu.ac.bd | 3.50 |

### 3.2 ACID Properties

Every reliable RDBMS guarantees **ACID**:

| Property | Meaning | Example |
|----------|---------|---------|
| **A**tomicity | All or nothing — a transaction either fully completes or fully rolls back | Transferring money: debit AND credit both succeed, or neither does |
| **C**onsistency | Data always moves from one valid state to another | GPA must be between 0.00 and 4.00 |
| **I**solation | Concurrent transactions don't interfere with each other | Two students registering for the last seat simultaneously |
| **D**urability | Once committed, data survives crashes | Power outage after `COMMIT` — data is safe |

### 3.3 SQL — Structured Query Language

SQL is the standard language for working with relational databases. It has several sub-languages:

| Category | Commands | Purpose |
|----------|----------|---------|
| **DDL** (Data Definition) | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` | Define/modify structure |
| **DML** (Data Manipulation) | `INSERT`, `UPDATE`, `DELETE`, `SELECT` | Work with data |
| **DCL** (Data Control) | `GRANT`, `REVOKE` | Permissions |
| **TCL** (Transaction Control) | `COMMIT`, `ROLLBACK`, `SAVEPOINT` | Transaction management |

---

## 4. Setting Up MySQL

### 4.1 Installation Options

| Option | Platform | Recommended For |
|--------|----------|----------------|
| **XAMPP** | Windows/Mac/Linux | This course — includes Apache + PHP + MySQL |
| **MySQL Installer** | Windows | MySQL-only installation |
| **Homebrew** (`brew install mysql`) | Mac | Advanced users |
| **Docker** | All | Advanced setup |

### 4.2 Step-by-Step: XAMPP Installation

1. **Download XAMPP** from [https://www.apachefriends.org](https://www.apachefriends.org)
2. **Install** with default settings (make sure MySQL is checked)
3. **Start XAMPP Control Panel** → Start **Apache** and **MySQL**
4. **Verify:** Open browser → go to `http://localhost/phpmyadmin`
5. **Open MySQL CLI:** In XAMPP, click "Shell" → type `mysql -u root`

### 4.3 MySQL Workbench

MySQL Workbench provides a visual interface for:
- Writing and executing SQL queries
- Designing ERDs (Entity-Relationship Diagrams)
- Managing users, schemas, and server settings

**Download:** [https://dev.mysql.com/downloads/workbench/](https://dev.mysql.com/downloads/workbench/)

### 4.4 Connecting to MySQL via CLI

```sql
-- Connect to MySQL (default: no password for root in XAMPP)
mysql -u root

-- If password is set:
mysql -u root -p
```

---

## 5. Creating Your First Database

### 5.1 Database Operations

```sql
-- See all existing databases
SHOW DATABASES;

-- Create a new database
CREATE DATABASE shop_db;

-- Use (switch to) the database
USE shop_db;

-- Check which database you're currently using
SELECT DATABASE();

-- Delete a database (CAREFUL!)
DROP DATABASE shop_db;
```

> 📁 **See:** `examples/01_create_database.sql`

### 5.2 Naming Conventions

| Rule | Good ✅ | Bad ❌ |
|------|---------|--------|
| Use lowercase | `student_records` | `StudentRecords` |
| Use underscores | `order_items` | `order-items`, `orderitems` |
| Be descriptive | `product_categories` | `pc`, `tbl1` |
| Avoid reserved words | `user_accounts` | `order`, `select` |
| Singular table names | `student` | `students` (debatable — pick one and be consistent) |

> **For this course**, we'll use **lowercase with underscores** and **plural table names** (e.g., `students`, `orders`).

---

## 6. MySQL Data Types

Choosing the right data type is critical for performance, storage, and data integrity.

### 6.1 Numeric Types

| Type | Bytes | Range | Use Case |
|------|:-----:|-------|----------|
| `TINYINT` | 1 | -128 to 127 | Age, status flags |
| `SMALLINT` | 2 | -32,768 to 32,767 | Year, small counts |
| `INT` | 4 | -2.1B to 2.1B | IDs, quantities |
| `BIGINT` | 8 | Very large | Financial IDs |
| `DECIMAL(p,s)` | Varies | Exact | Money: `DECIMAL(10,2)` |
| `FLOAT` | 4 | Approximate | Scientific data |
| `DOUBLE` | 8 | Approximate | Scientific data |

> ⚠️ **Never use `FLOAT` for money!** Use `DECIMAL(10,2)` — floating-point math causes rounding errors.

### 6.2 String Types

| Type | Max Length | Use Case |
|------|:---------:|----------|
| `CHAR(n)` | 255 | Fixed-length: country codes `CHAR(2)` |
| `VARCHAR(n)` | 65,535 | Variable-length: names, emails |
| `TEXT` | 65,535 | Long text: descriptions, comments |
| `MEDIUMTEXT` | 16MB | Articles, blog posts |
| `LONGTEXT` | 4GB | Very long content |
| `ENUM('a','b','c')` | — | Predefined choices: status, gender |

### 6.3 Date/Time Types

| Type | Format | Example | Use Case |
|------|--------|---------|----------|
| `DATE` | YYYY-MM-DD | `2025-03-03` | Birthdays, deadlines |
| `TIME` | HH:MM:SS | `14:30:00` | Durations, schedules |
| `DATETIME` | YYYY-MM-DD HH:MM:SS | `2025-03-03 14:30:00` | Timestamps |
| `TIMESTAMP` | Same as DATETIME | Auto-updates | `created_at`, `updated_at` |
| `YEAR` | YYYY | `2025` | Year-only data |

> 📁 **See:** `examples/02_data_types.sql`

---

## 7. Creating Tables

### 7.1 CREATE TABLE Syntax

```sql
CREATE TABLE table_name (
    column1  datatype  constraints,
    column2  datatype  constraints,
    ...
    table_constraints
);
```

### 7.2 Column Constraints

| Constraint | Meaning | Example |
|-----------|---------|---------|
| `NOT NULL` | Cannot be empty | `name VARCHAR(100) NOT NULL` |
| `DEFAULT value` | Default if not provided | `status VARCHAR(20) DEFAULT 'active'` |
| `UNIQUE` | No duplicate values | `email VARCHAR(150) UNIQUE` |
| `PRIMARY KEY` | Unique identifier for each row | `id INT PRIMARY KEY` |
| `AUTO_INCREMENT` | Auto-generates sequential numbers | `id INT AUTO_INCREMENT PRIMARY KEY` |
| `CHECK` | Validates values | `CHECK (price >= 0)` |
| `FOREIGN KEY` | References another table | Covered in Lab 02 |

### 7.3 Example: Building Tables

```sql
CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL UNIQUE,
    description   TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id    INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(200) NOT NULL,
    price         DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock         INT NOT NULL DEFAULT 0,
    category_id   INT,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
```

### 7.4 Viewing Table Structure

```sql
-- Show all tables in current database
SHOW TABLES;

-- Show column details of a table
DESCRIBE products;
-- or
SHOW COLUMNS FROM products;

-- Show the full CREATE TABLE statement
SHOW CREATE TABLE products;
```

> 📁 **See:** `examples/03_create_tables.sql`

---

## 8. Inserting Data

### 8.1 INSERT Syntax

```sql
-- Insert a single row (specifying columns)
INSERT INTO categories (name, description)
VALUES ('Electronics', 'Gadgets and devices');

-- Insert a single row (all columns — must match order)
INSERT INTO categories VALUES (NULL, 'Books', 'Physical and digital books', NOW());

-- Insert multiple rows at once
INSERT INTO categories (name, description) VALUES
    ('Clothing', 'Apparel and accessories'),
    ('Food', 'Groceries and snacks'),
    ('Sports', 'Sports equipment and gear');
```

### 8.2 AUTO_INCREMENT Behavior

When a column is `AUTO_INCREMENT`:
- You can pass `NULL` or omit it — MySQL generates the next number
- After inserting, use `SELECT LAST_INSERT_ID();` to get the generated ID
- The counter never resets even if you delete rows (use `ALTER TABLE t AUTO_INCREMENT = 1;` to reset)

> 📁 **See:** `examples/04_insert_data.sql`

---

## 9. Basic SELECT Queries

### 9.1 Retrieving Data

```sql
-- Select all columns, all rows
SELECT * FROM categories;

-- Select specific columns
SELECT name, description FROM categories;

-- Select with a condition
SELECT * FROM products WHERE price > 100;

-- Count rows
SELECT COUNT(*) FROM products;
```

### 9.2 A Quick Preview

We'll dive deep into `SELECT` in Lab 03. For now, just know:
- `*` means all columns
- `WHERE` filters rows
- `ORDER BY` sorts results
- `LIMIT` restricts how many rows to return

> 📁 **See:** `examples/05_basic_select.sql`

---

## ⚠️ Common Pitfalls

| Mistake | Problem | Fix |
|---------|---------|-----|
| Forgetting `USE database_name;` | Queries run on wrong DB | Always `USE` first |
| `FLOAT` for money | Rounding errors: `0.1 + 0.2 ≠ 0.3` | Use `DECIMAL(10,2)` |
| No `NOT NULL` on required fields | Allows empty data | Add `NOT NULL` to mandatory columns |
| Forgetting `AUTO_INCREMENT` on PK | Must manually provide IDs | Add it to avoid errors |
| Missing semicolons | MySQL waits for more input | End every statement with `;` |
| Using reserved words as names | Syntax errors | Rename or use backticks `` `order` `` |

---

## 🔗 In the Industry

- **MySQL** powers some of the world's biggest websites: Facebook, Twitter, YouTube, Netflix
- **Schema design** decisions made today will affect performance for years — choose data types carefully
- **Naming conventions** are critical in teams — inconsistent names cause bugs and confusion
- **ACID compliance** is what separates enterprise databases from simple file storage

---

## 🧪 Lab Task 1 — Build a Library Database

**Duration:** 30–40 minutes  
**Difficulty:** ⭐⭐ (Easy-Medium)

### Requirements

Build a `library_db` database with the following tables:

1. **`members`** table with:
    - `member_id` — auto-incrementing primary key
    - `first_name`, `last_name` — required, max 50 chars each
    - `email` — required, unique, max 150 chars
    - `phone` — optional, max 15 chars
    - `membership_type` — ENUM: 'standard', 'premium', default 'standard'
    - `join_date` — defaults to current date

2. **`books`** table with:
    - `book_id` — auto-incrementing primary key
    - `title` — required, max 200 chars
    - `author` — required, max 100 chars
    - `isbn` — unique, exactly 13 chars
    - `genre` — max 50 chars
    - `price` — decimal, must be ≥ 0
    - `stock` — integer, default 0
    - `published_year` — YEAR type

3. **Insert** at least 5 members and 8 books with realistic data

4. **Write queries** to:
    - Show all books
    - Show all premium members
    - Show books priced under 500 BDT
    - Count total books in the library

### Grading Criteria

| Criteria | Points |
|----------|:------:|
| Correct `CREATE DATABASE` and `USE` | 10 |
| `members` table with all constraints | 20 |
| `books` table with all constraints | 20 |
| Realistic sample data (5+ members, 8+ books) | 20 |
| All 4 queries working correctly | 20 |
| Naming conventions and code formatting | 10 |
| **Total** | **100** |

### Bonus Challenge ⭐

Add a `borrowings` table that tracks which member borrowed which book, with `borrow_date` and `return_date`. This previews foreign keys from Lab 02.

---

**📁 Reference Solution:** `lab_01_intro_relational_db/labtask/solution.sql`
