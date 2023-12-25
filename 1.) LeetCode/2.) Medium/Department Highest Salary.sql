-- Write an SQL query to find employees who have the highest salary in each of the departments.

WITH RankNumbers AS
(
    SELECT
        D.name AS Department,
        E.name AS Employee,
        E.salary AS Salary,
        DENSE_RANK() OVER(PARTITION BY D.id ORDER BY E.salary DESC) AS rank_num
    FROM Employee E
    LEFT JOIN Department D ON E.departmentId = D.id
)
SELECT
    Department,
    Employee,
    Salary
FROM RankNumbers
WHERE rank_num = 1;
