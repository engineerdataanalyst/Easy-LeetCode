/* Write a solution to calculate the difference between the highest salaries in the marketing and engineering department.
   Output the absolute difference in salaries. */

WITH MaxSalaries AS
(
    SELECT
        department,
        MAX(salary) AS max_salary,
        CASE
            WHEN department = 'Engineering' THEN 1
            ELSE -1
        END AS sign
    FROM Salaries
    GROUP BY department
)
SELECT ABS(SUM(max_salary*sign)) AS salary_difference
FROM MaxSalaries;
