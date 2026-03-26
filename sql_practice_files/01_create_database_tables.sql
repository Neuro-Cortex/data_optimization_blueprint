CREATE DATABASE University;

USE University;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    age INT
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    teacher VARCHAR(50)
);

CREATE TABLE Enrollments (
    enroll_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);