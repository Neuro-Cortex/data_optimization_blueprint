-- SmartUniversity Database Full Advanced SQL Script

-- 1. Create Database
CREATE DATABASE SmartUniversity;
USE SmartUniversity;

-- 2. Tables
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50),
    cgpa DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    credit INT,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

CREATE TABLE Enrollments (
    enroll_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 3. Sample Data
INSERT INTO Students (name, email, department, cgpa)
VALUES 
('Sana Rahman', 'sana@gmail.com', 'CSE', 3.80),
('Karim Hasan', 'karim@gmail.com', 'EEE', 3.50),
('Ayesha Noor', 'ayesha@gmail.com', 'CSE', 3.90);

INSERT INTO Teachers (name, department, salary)
VALUES 
('Dr. Ahmed', 'CSE', 80000),
('Dr. Khan', 'EEE', 75000);

INSERT INTO Courses (course_name, credit, teacher_id)
VALUES 
('Database Systems', 3, 1),
('Algorithms', 3, 1),
('Circuits', 3, 2);

INSERT INTO Enrollments (student_id, course_id, grade)
VALUES 
(1, 1, 'A'),
(1, 2, 'A'),
(2, 3, 'B'),
(3, 1, 'A');

-- 4. Complex Query
SELECT 
    s.name,
    AVG(
        CASE 
            WHEN e.grade = 'A' THEN 4
            WHEN e.grade = 'B' THEN 3
            WHEN e.grade = 'C' THEN 2
            ELSE 0
        END
    ) AS avg_grade
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING avg_grade > 3.5;

-- 5. Subquery
SELECT name
FROM Students
WHERE student_id IN (
    SELECT student_id
    FROM Enrollments
    WHERE course_id IN (
        SELECT course_id FROM Courses WHERE course_name LIKE '%Database%'
    )
);

-- 6. Stored Procedure
DELIMITER $$

CREATE PROCEDURE GetStudentCourses(IN sid INT)
BEGIN
    SELECT s.name, c.course_name
    FROM Students s
    JOIN Enrollments e ON s.student_id = e.student_id
    JOIN Courses c ON e.course_id = c.course_id
    WHERE s.student_id = sid;
END $$

DELIMITER ;

-- Call Procedure
CALL GetStudentCourses(1);

-- 7. Trigger
DELIMITER $$

CREATE TRIGGER UpdateCGPA
AFTER INSERT ON Enrollments
FOR EACH ROW
BEGIN
    UPDATE Students
    SET cgpa = cgpa + 0.01
    WHERE student_id = NEW.student_id;
END $$

DELIMITER ;

-- 8. Indexing
CREATE INDEX idx_student_department ON Students(department);
CREATE INDEX idx_course_name ON Courses(course_name);

-- 9. Window Function
SELECT 
    name,
    cgpa,
    RANK() OVER (ORDER BY cgpa DESC) AS rank_position
FROM Students;

-- 10. Transaction Example
START TRANSACTION;

UPDATE Students SET cgpa = cgpa - 0.5 WHERE student_id = 1;

ROLLBACK;
-- COMMIT;
