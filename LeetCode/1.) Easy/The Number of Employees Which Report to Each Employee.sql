/* For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

   Write an SQL query to report the ids and the names of all managers,
   the number of employees who report directly to them, and
   the average age of the reports rounded to the nearest integer.

   Return the result table ordered by employee_id. */
 
SELECT
    E2.employee_id,
    E2.name,
    COUNT(E2.employee_id) AS reports_count,
    ROUND(AVG(E1.age)) AS average_age
FROM Employees E1
LEFT JOIN Employees E2 ON E1.reports_to = E2.employee_id
GROUP BY E2.employee_id
HAVING reports_count >= 1
ORDER BY E2.employee_id;
