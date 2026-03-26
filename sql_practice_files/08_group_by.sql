SELECT department, COUNT(*) AS total_students
FROM Students
GROUP BY department;