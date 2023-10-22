/* Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.
   The indirect relation between managers will not exceed three managers as the company is small. */

SELECT E1.employee_id
FROM Employees E1
LEFT JOIN Employees E2 ON E1.manager_id = E2.employee_id
LEFT JOIN Employees E3 ON E2.manager_id = E3.employee_id
WHERE E1.employee_id != 1 AND
      E3.manager_id = 1;
