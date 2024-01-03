/* Write a solution to find the name of the manager from the largest department.
   There may be multiple largest departments when the number of employees in those departments is the same.

   Return the result table sorted by dep_id in ascending order. */

WITH NumberOfEmployees AS
(
    SELECT
        *,
        COUNT(*) OVER(PARTITION BY dep_id) AS number_of_employees
    FROM Employees
),
EmployeeRanks AS
(
    SELECT
        *,
        DENSE_RANK() OVER(ORDER BY number_of_employees DESC) AS rank_num
    FROM NumberOfEmployees
)
SELECT
    emp_name AS manager_name,
    dep_id
FROM EmployeeRanks
WHERE rank_num = 1 AND position = 'Manager'
ORDER BY dep_id;
