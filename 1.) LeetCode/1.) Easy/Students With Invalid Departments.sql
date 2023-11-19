-- Write an SQL query to find the id and the name of all students who are enrolled in departments that no longer exist.

SELECT
    S.id,
    S.name
FROM Students S
LEFT JOIN Departments D ON S.department_id = D.id
WHERE D.id IS NULL;
