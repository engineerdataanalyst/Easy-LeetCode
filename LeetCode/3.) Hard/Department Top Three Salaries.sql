/* A company's executives are interested in seeing who earns the most money in each of the company's departments. 
   A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
   
   Write an SQL query to find the employees who are high earners in each of the departments. */

WITH DepartmentRank AS
(
    SELECT
        E.id,
        E.name AS Employee,
        E.salary AS Salary,
        D.name AS Department,
        DENSE_RANK() OVER(PARTITION BY E.departmentId ORDER BY E.salary DESC) AS department_rank
    FROM Employee E
    LEFT JOIN Department D ON E.departmentId = D.id
)
SELECT
    Department,
    Employee,
    Salary
FROM DepartmentRank
WHERE department_rank <= 3;
