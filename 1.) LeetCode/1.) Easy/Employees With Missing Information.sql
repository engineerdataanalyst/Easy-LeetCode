/* Write an SQL query to report the IDs of all the employees with missing information.
   The information of an employee is missing if:

   The employee's name is missing, or
   The employee's salary is missing.
   Return the result table ordered by employee_id in ascending order. */

SELECT s.employee_id
FROM Employees e
FULL JOIN Salaries s ON e.employee_id = s.employee_id
WHERE e.name IS NULL

UNION

SELECT e.employee_id
FROM Employees e
FULL JOIN Salaries s ON e.employee_id = s.employee_id
WHERE s.salary IS NULL;
