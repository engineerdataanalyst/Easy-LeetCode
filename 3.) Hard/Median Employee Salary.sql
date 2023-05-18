/* Write an SQL query to find the rows that contain the median salary of each company. 
   While calculating the median, when you sort the salaries of the company, break the ties by id. */

WITH RowNumbers AS
(
    SELECT
        id,
        company,
        salary,
        COUNT(*) OVER(PARTITION BY company) as cnt,
        ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary) AS row_num
    FROM Employee
),
Ranges AS
(
    SELECT
        id,
        company,
        CASE
            WHEN MOD(cnt, 2) = 0 THEN cnt/2
            ELSE ROUND(cnt/2) 
        END AS low,
        CASE
            WHEN MOD(cnt, 2) = 0 THEN cnt/2+1
            ELSE ROUND(cnt/2)
        END AS high
    FROM RowNumbers
)
SELECT
    R1.id,
    R1.company,
    R1.salary
FROM RowNumbers R1
LEFT JOIN Ranges R2 ON R1.id = R2.id
WHERE R1.row_num IN (R2.low, R2.high);
