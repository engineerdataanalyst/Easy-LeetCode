-- Write an SQL query to report all the classes that have at least five students.

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(class) >= 5;
