-- Write an SQL query to find the team size of each of the employees.

SELECT
    employee_id,
    COUNT(*) OVER(PARTITION BY team_id) AS team_size
FROM Employee
ORDER BY employee_id;
