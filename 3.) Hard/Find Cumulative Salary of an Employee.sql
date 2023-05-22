/* Write an SQL query to calculate the cumulative salary summary for every employee in a single unified table.
   The cumulative salary summary for an employee can be calculated as follows:

   For each month that the employee worked, sum up the salaries in that month and the previous two months. 
   This is their 3-month sum for that month. 
   If an employee did not work for the company in previous months, their effective salary for those months is 0.
   Do not include the 3-month sum for the most recent month that the employee worked for in the summary.

   Do not include the 3-month sum for any month the employee did not work.
   Return the result table ordered by id in ascending order. 
   In case of a tie, order it by month in descending order. */

WITH RECURSIVE Months AS
(
    SELECT 
        1 AS month,
        0 AS salary

    UNION

    SELECT
        month+1 AS month,
        0 AS salary
    FROM Months
    WHERE month < 12
),
MonthRanges AS
(
    SELECT
        id,
        MIN(month) AS earliest_month,
        MAX(month) AS latest_month
    FROM Employee
    GROUP BY id
),
NewEmployeeUnstacked AS
(
    SELECT
        E.id,
        E.month AS month1,
        E.salary AS Salary1,
        M.month AS month2,
        M.salary AS Salary2
    FROM Months M
    CROSS JOIN Employee E
    WHERE E.month != M.month
    ORDER BY
        E.id,
        month1,
        month2
),
NewEmployeeUnsummed AS
(
    SELECT
        id,
        month1 AS month,
        Salary1 AS salary
    FROM NewEmployeeUnstacked

    UNION

    SELECT
        id,
        month2 AS month,
        Salary2 AS salary
    FROM NewEmployeeUnstacked
    ORDER BY
        id,
        month
),
NewEmployee AS
(
    SELECT
        id,
        month,
        SUM(salary) AS salary
    FROM NewEmployeeUnsummed N
    WHERE month >= ALL 
         (SELECT earliest_month
          FROM MonthRanges L
          WHERE L.id = N.id) AND
          month < ALL
         (SELECT latest_month
          FROM MonthRanges L
          WHERE L.id = N.id)
    GROUP BY
        id,
        month
    ORDER BY
        id,
        month DESC
),
SalarySum AS
(
    SELECT
        id,
        month,
        salary,
        SUM(salary) OVER(PARTITION BY id ORDER BY month DESC ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS salary_sum
    FROM NewEmployee
)
SELECT
    id,
    month,
    salary_sum AS Salary
FROM SalarySum
WHERE salary != 0;
