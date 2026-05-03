# 📋 Quiz 1 — Study Guide & Syllabus

> **Course:** RDBMS Lab | **Quiz Date:** 13/04/2026  
> **Marks:** 20 | **Duration:** 40 minutes  
> **Covers:** Lab 01, Lab 02, Lab 03, Lab 04

---

## 📢 General Instructions

- This is a **closed-book, no-internet** exam.
- The quiz uses a **scenario-based** database. The schema and data will be provided in the question paper — **you do not need to memorize any tables**.
- Focus on **understanding concepts** and **writing correct SQL queries**.
- Partial marks are given for correct logic even with minor syntax errors.
- **No marks deducted** for missing semicolons.

---

## 📚 Topics to Study

### From Lab 01 — Introduction to RDBMS

| Topic | What You Should Know |
|---|---|
| What is RDBMS | Tables, rows, columns, PK, FK |
| ACID Properties | Define each: Atomicity, Consistency, Isolation, Durability |
| SQL Categories | Know which commands belong to DDL, DML, DCL, TCL |
| Data Types | When to use INT, VARCHAR, DECIMAL, DATE, ENUM, BOOLEAN |
| Constraints | PK, NOT NULL, UNIQUE, DEFAULT, CHECK, AUTO_INCREMENT |
| CREATE TABLE | Write correct syntax with columns and constraints |
| INSERT INTO | Single-row and multi-row insert syntax |

**Practice:**
- Write a `CREATE TABLE` from scratch with at least 5 constraints.
- Identify what SQL category a command belongs to (e.g., `ALTER TABLE` → DDL).

---

### From Lab 02 — Database Design

| Topic | What You Should Know |
|---|---|
| Normalization | 1NF: atomic values. 2NF: no partial dependency. 3NF: no transitive dependency |
| When a table violates 1NF/2NF/3NF | Given a table, identify which normal form is violated and why |
| Primary Key types | Surrogate (AUTO_INCREMENT) vs Natural (email) vs Composite |
| Foreign Keys | Syntax, purpose, and what happens with ON DELETE CASCADE / SET NULL / RESTRICT |
| DROP vs TRUNCATE vs DELETE | Know the differences: structure removal, WHERE clause, recoverability, AUTO_INCREMENT |
| ALTER TABLE | ADD, MODIFY, RENAME, DROP columns |

**Practice:**
- Given an unnormalized table, convert it to 3NF step by step.
- Explain what happens when you delete a parent row with CASCADE vs SET NULL.

---

### From Lab 03 — Basic SQL Queries

| Topic | What You Should Know |
|---|---|
| SELECT + WHERE | Filtering rows with conditions |
| Logical operators | AND, OR, NOT — and why **parentheses matter** |
| BETWEEN, IN, LIKE | Range checks, list matching, pattern matching (`%` and `_`) |
| String functions | CONCAT, UPPER, LOWER, LENGTH, SUBSTRING, REPLACE |
| Date functions | NOW, CURDATE, YEAR, MONTH, DATEDIFF, DATE_FORMAT |
| NULL handling | `IS NULL`, `IS NOT NULL`, why `= NULL` doesn't work, COALESCE, IFNULL |
| NULL arithmetic | `10 + NULL = NULL`, `NULL = NULL` is **not** TRUE |
| ORDER BY | ASC/DESC, multi-column sorting |
| LIMIT / OFFSET | Top-N queries, pagination |
| DISTINCT | Removing duplicate rows from results |
| Aliases | Column aliases (`AS`), table aliases for JOINs |

**Practice:**
- Write a query using LIKE with `%` to find emails from Gmail.
- Use COALESCE to replace NULL with a default value.
- Predict the output of `SELECT NULL + 5, NULL = NULL, NULL IS NULL;`

---

### From Lab 04 — Intermediate SQL (JOINs, Aggregates, Subqueries)

| Topic | What You Should Know |
|---|---|
| INNER JOIN | Returns only matching rows from both tables |
| LEFT JOIN | All from left table + matching from right (NULL if no match) |
| RIGHT JOIN | All from right table + matching from left |
| LEFT JOIN + WHERE IS NULL | The "find missing / orphan" pattern |
| Multi-table JOINs | Chaining 3+ tables in one query |
| COUNT, SUM, AVG, MIN, MAX | Aggregate functions — collapse rows into a single value |
| GROUP BY | Split rows into groups, apply aggregate per group |
| HAVING | Filter **groups** (vs WHERE which filters **rows**) |
| WHERE vs HAVING | WHERE runs before GROUP BY; HAVING runs after. Aggregates only in HAVING. |
| SQL Execution Order | FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY |
| Subqueries | Scalar (single value), table (IN list), correlated (references outer query) |
| EXISTS vs IN | EXISTS stops at first match; IN evaluates entire subquery |

**⚡ This is the most heavily tested topic. Practice writing queries with JOINs + GROUP BY + HAVING.**

**Practice:**
- Find customers who haven't placed any orders (LEFT JOIN + IS NULL).
- Count products per category, show only categories with > 3 products.
- Find products priced above the average (subquery in WHERE).
- Write a 3-table JOIN with GROUP BY and HAVING.

---

## 📐 Quiz Format (what to expect)

| Section | Type | Marks | Time Estimate |
|---|---|:---:|:---:|
| **A** | 5 Multiple Choice Questions | 5 | ~8 min |
| **B** | 2 questions: Predict query output / Find an error | 3 | ~8 min |
| **C** | 6 SQL query writing questions (scenario-based) | 12 | ~22 min |
| **Total** | | **20** | **~38 min** |

---

## 💡 Tips for Success

1. **Read the schema and data carefully** before writing any query.
2. **Start with the easy questions** in Section C — don't get stuck on hard ones.
3. For JOINs: always ask yourself _"Do I need ALL rows from one side?"_ → if yes, use LEFT JOIN.
4. For GROUP BY: if the question says "per category" or "per customer" → that's GROUP BY.
5. For HAVING: if the question says "only show groups where count > X" → that's HAVING.
6. **Write column aliases** (`AS`) — it makes your queries clearer and shows understanding.
7. Practice the **"find missing" pattern**: `LEFT JOIN ... WHERE right_table.pk IS NULL`.

---

## 📖 Study Resources

- Lab notes: `LAB_01_NOTES.md` through `LAB_04_NOTES.md`
- Example SQL files in each lab's `examples/` folder
- Practice by running queries on `ecommerce_db`

> **Good luck! 🍀**
