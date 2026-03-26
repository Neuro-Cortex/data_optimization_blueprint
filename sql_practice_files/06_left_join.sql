SELECT Students.name, Courses.course_name
FROM Students
LEFT JOIN Enrollments 
ON Students.student_id = Enrollments.student_id
LEFT JOIN Courses 
ON Enrollments.course_id = Courses.course_id;