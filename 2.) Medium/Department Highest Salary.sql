-- Write an SQL query to find employees who have the highest salary in each of the departments.

SELECT
    D.name AS Department,
    E.name AS Employee,
    E.salary AS Salary
FROM Employee E
LEFT JOIN Department D ON E.departmentId = D.id
WHERE (E.departmentId, E.salary) IN
    (SELECT
         departmentId,
         MAX(salary)
     FROM Employee
     GROUP BY departmentId);
