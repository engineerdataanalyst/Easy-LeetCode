/* Write an SQL query to find the current salary of each employee assuming that salaries increase each year.
   Output their emp_id, firstname, lastname, salary, and department_id.

   Return the result table ordered by emp_id in ascending order. */

SELECT
    emp_id,
    firstname,
    lastname,
    MAX(salary) AS salary,
    department_id
FROM Salary
GROUP BY emp_id
ORDER BY emp_id;
