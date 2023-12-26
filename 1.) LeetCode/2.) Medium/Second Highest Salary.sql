/* Write an SQL query to report the second highest salary from the Employee table.
   If there is no second highest salary, the query should report null. */

WITH NewEmployee AS
(
    SELECT
        id,
        salary,
        DENSE_RANK() OVER(ORDER BY salary DESC) AS rank_num
    FROM Employee
)
SELECT DISTINCT
    CASE
        WHEN (SELECT MAX(rank_num) FROM NewEmployee) > 1 THEN salary
        ELSE NULL
    END AS SecondHighestSalary
FROM NewEmployee
WHERE rank_num = CASE
                     WHEN (SELECT MAX(rank_num) FROM NewEmployee) > 1 THEN 2
                     ELSE 1
                 END;
