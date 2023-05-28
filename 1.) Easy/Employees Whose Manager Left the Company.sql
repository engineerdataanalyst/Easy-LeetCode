/* Write an SQL query to report the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company.
   When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.

   Return the result table ordered by employee_id. */

SELECT employee_id
FROM Employees
WHERE salary < 30000 AND
      manager_id IS NOT NULL AND
      manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id;
