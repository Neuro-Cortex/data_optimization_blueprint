SELECT Students.name, Courses.course_name
FROM Students
INNER JOIN Enrollments 
ON Students.student_id = Enrollments.student_id
INNER JOIN Courses 
ON Enrollments.course_id = Courses.course_id;