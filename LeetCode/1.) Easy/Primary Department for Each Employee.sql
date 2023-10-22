/* Employees can belong to multiple departments.
   When the employee joins other departments, they need to decide which department is their primary department.
   Note that when an employee belongs to only one department, their primary column is 'N'.

   Write an SQL query to report all the employees with their primary department. For employees who belong to one department, report their only department. */

WITH NewEmployee AS
(
    SELECT
        employee_id,
        department_id,
        primary_flag,
        row_num,
        MAX(row_num) OVER(PARTITION BY employee_id) AS max_row_num
    FROM
    (
        SELECT
            employee_id,
            department_id,
            primary_flag,
            ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY department_id) AS row_num
        FROM Employee
    ) E
)
SELECT
    employee_id,
    department_id
FROM NewEmployee
WHERE primary_flag = 'Y' AND max_row_num != 1

UNION

SELECT
    employee_id,
    department_id
FROM NewEmployee
WHERE row_num = 1 AND max_row_num = 1
ORDER BY employee_id;
