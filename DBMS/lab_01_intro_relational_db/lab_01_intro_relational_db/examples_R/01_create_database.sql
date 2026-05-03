-- ============================================================
-- Lab 01 | Example 01: Creating and Managing Databases
-- ============================================================
-- This file demonstrates how to create, use, and manage
-- databases in MySQL.
-- ============================================================

-- ─────────────────────────────────────────────
-- 1. Show existing databases
-- ─────────────────────────────────────────────
SHOW DATABASES;
-- You'll see system databases like: information_schema, mysql, 
-- performance_schema, sys

-- ─────────────────────────────────────────────
-- 2. Create a new database
-- ─────────────────────────────────────────────
CREATE DATABASE shop_db;

-- With character set (recommended for Bangla/Unicode support):
CREATE DATABASE shop_db_unicode
    CHARACTER SET utf8mb4 problem 
    COLLATE utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────
-- 3. Use (switch to) a database
-- ─────────────────────────────────────────────
USE shop_db;

-- Check which database you're currently in:
SELECT DATABASE();
-- Output: shop_db

-- ─────────────────────────────────────────────
-- 4. Create only if it doesn't exist
-- ─────────────────────────────────────────────
-- This prevents errors if the database already exists
CREATE DATABASE IF NOT EXISTS shop_db;

-- ─────────────────────────────────────────────
-- 5. Show database creation details
-- ─────────────────────────────────────────────
SHOW CREATE DATABASE shop_db;

-- ─────────────────────────────────────────────
-- 6. Drop (delete) a database — BE CAREFUL!
-- ─────────────────────────────────────────────
-- ⚠️ This permanently deletes the database and ALL its data!
DROP DATABASE IF EXISTS shop_db_unicode;

-- ─────────────────────────────────────────────
-- 7. For this course, let's create and use our main database
-- ─────────────────────────────────────────────
DROP DATABASE IF EXISTS shop_db;
CREATE DATABASE shop_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE shop_db;

SELECT DATABASE();
-- Output: shop_db ✅
