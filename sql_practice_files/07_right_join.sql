SELECT Students.name, Courses.course_name
FROM Students
RIGHT JOIN Enrollments 
ON Students.student_id = Enrollments.student_id
RIGHT JOIN Courses 
ON Enrollments.course_id = Courses.course_id;