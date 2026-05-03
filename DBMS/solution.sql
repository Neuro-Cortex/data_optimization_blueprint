-- ============================================================
-- Lab 01 | Lab Task Solution: Library Database
-- ============================================================

-- ─────────────────────────────────────────────
-- 1. Create and use database
-- ─────────────────────────────────────────────
DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_db;

-- ─────────────────────────────────────────────
-- 2. Create members table
-- ─────────────────────────────────────────────
CREATE TABLE members (
    member_id       INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(15),
    membership_type ENUM('standard', 'premium') DEFAULT 'standard',
    join_date       DATE DEFAULT (CURRENT_DATE)
);

-- ─────────────────────────────────────────────
-- 3. Create books table
-- ─────────────────────────────────────────────
CREATE TABLE books (
    book_id        INT AUTO_INCREMENT PRIMARY KEY,
    title          VARCHAR(200) NOT NULL,
    author         VARCHAR(100) NOT NULL,
    isbn           CHAR(13) UNIQUE,
    genre          VARCHAR(50),
    price          DECIMAL(8,2) CHECK (price >= 0),
    stock          INT DEFAULT 0,
    published_year YEAR
);

-- ─────────────────────────────────────────────
-- 4. Insert members (5+)
-- ─────────────────────────────────────────────
INSERT INTO members (first_name, last_name, email, phone, membership_type) VALUES
    ('Rafiq', 'Ahmed', 'rafiq.ahmed@gmail.com', '01711234567', 'premium'),
    ('Nusrat', 'Jahan', 'nusrat.jahan@gmail.com', '01819876543', 'standard'),
    ('Tanvir', 'Hasan', 'tanvir.hasan@gmail.com', '01512345678', 'premium'),
    ('Ayesha', 'Khan', 'ayesha.khan@gmail.com', '01698765432', 'standard'),
    ('Imran', 'Ali', 'imran.ali@gmail.com', '01412341234', 'standard'),
    ('Farhana', 'Rahman', 'farhana.rahman@gmail.com', '01311112222', 'premium');

-- ─────────────────────────────────────────────
-- 5. Insert books (8+)
-- ─────────────────────────────────────────────
INSERT INTO books (title, author, isbn, genre, price, stock, published_year) VALUES
    ('Clean Code', 'Robert C. Martin', '9780132350884', 'Technology', 1500.00, 10, 2008),
    ('The Pragmatic Programmer', 'David Thomas', '9780135957059', 'Technology', 1800.00, 8, 2019),
    ('Database System Concepts', 'Abraham Silberschatz', '9780078022159', 'Textbook', 2200.00, 15, 2019),
    ('Introduction to Algorithms', 'Thomas H. Cormen', '9780262033848', 'Textbook', 2500.00, 5, 2009),
    ('The Alchemist', 'Paulo Coelho', '9780062315007', 'Fiction', 350.00, 20, 1988),
    ('Sapiens', 'Yuval Noah Harari', '9780062316110', 'Non-Fiction', 600.00, 12, 2011),
    ('Atomic Habits', 'James Clear', '9780735211292', 'Self-Help', 450.00, 18, 2018),
    ('Harry Potter and the Philosopher Stone', 'J.K. Rowling', '9780747532699', 'Fiction', 400.00, 25, 1997),
    ('Lalsalu', 'Syed Waliullah', '9789849025006', 'Bangla Literature', 200.00, 30, 1948),
    ('Pather Panchali', 'Bibhutibhushan Bandopadhyay', '9788172151560', 'Bangla Literature', 250.00, 22, 1929);

-- ─────────────────────────────────────────────
-- 6. Required queries
-- ─────────────────────────────────────────────

-- Query 1: Show all books
SELECT * FROM books;

-- Query 2: Show all premium members
SELECT * FROM members WHERE membership_type = 'premium';

-- Query 3: Show books priced under 500 BDT
SELECT title, author, price FROM books WHERE price < 500;

-- Query 4: Count total books in the library
SELECT COUNT(*) AS total_books FROM books;

-- ─────────────────────────────────────────────
-- BONUS: Borrowings table with foreign keys
-- ─────────────────────────────────────────────
CREATE TABLE borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id    INT NOT NULL,
    book_id      INT NOT NULL,
    borrow_date  DATE NOT NULL DEFAULT (CURRENT_DATE),
    return_date  DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO borrowings (member_id, book_id, borrow_date, return_date) VALUES
    (1, 1, '2025-02-01', '2025-02-15'),
    (1, 3, '2025-02-20', NULL),
    (2, 5, '2025-02-10', '2025-02-25'),
    (3, 7, '2025-03-01', NULL);

SELECT * FROM borrowings;
