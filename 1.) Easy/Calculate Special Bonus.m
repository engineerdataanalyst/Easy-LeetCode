/* Write an SQL query to calculate the bonus of each employee. 
   The bonus of an employee is 100% of their salary if the ID of the employee is an odd number 
   and the employee name does not start with the character 'M'. 
   The bonus of an employee is 0 otherwise. */

SELECT
    employee_id,
    CASE 
        WHEN MOD(employee_id, 2) != 0 AND LEFT(name, 1) != 'M' THEN salary
        ELSE 0
    END AS bonus
FROM Employees
ORDER BY employee_id;
