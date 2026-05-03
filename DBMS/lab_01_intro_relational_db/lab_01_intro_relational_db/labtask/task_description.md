# Lab Task 1 — Build a Library Database

**Duration:** 30–40 minutes  
**Difficulty:** ⭐⭐ (Easy-Medium)

## Requirements

Build a `library_db` database with the following tables:

### 1. `members` table

| Column | Type | Constraints |
|--------|------|-------------|
| `member_id` | INT | AUTO_INCREMENT, PRIMARY KEY |
| `first_name` | VARCHAR(50) | NOT NULL |
| `last_name` | VARCHAR(50) | NOT NULL |
| `email` | VARCHAR(150) | NOT NULL, UNIQUE |
| `phone` | VARCHAR(15) | — |
| `membership_type` | ENUM('standard', 'premium') | DEFAULT 'standard' |
| `join_date` | DATE | DEFAULT CURRENT_DATE |

### 2. `books` table

| Column | Type | Constraints |
|--------|------|-------------|
| `book_id` | INT | AUTO_INCREMENT, PRIMARY KEY |
| `title` | VARCHAR(200) | NOT NULL |
| `author` | VARCHAR(100) | NOT NULL |
| `isbn` | CHAR(13) | UNIQUE |
| `genre` | VARCHAR(50) | — |
| `price` | DECIMAL(8,2) | CHECK >= 0 |
| `stock` | INT | DEFAULT 0 |
| `published_year` | YEAR | — |

### 3. Sample Data
- Insert at least **5 members** with realistic Bangladeshi names
- Insert at least **8 books** with real book titles and authors

### 4. Queries
Write queries to:
1. Show all books
2. Show all premium members
3. Show books priced under 500 BDT
4. Count total books in the library

## Grading Criteria

| Criteria | Points |
|----------|:------:|
| Correct `CREATE DATABASE` and `USE` | 10 |
| `members` table with all constraints | 20 |
| `books` table with all constraints | 20 |
| Realistic sample data (5+ members, 8+ books) | 20 |
| All 4 queries working correctly | 20 |
| Naming conventions and code formatting | 10 |
| **Total** | **100** |

## Bonus Challenge ⭐

Add a `borrowings` table that tracks which member borrowed which book, with `borrow_date` and `return_date` columns. Use foreign keys to reference `members` and `books`.
