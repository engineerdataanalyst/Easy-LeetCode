/* Write an SQL query to report the total sales amount of each item for each year, 
   with corresponding product_name, product_id, report_year, and total_amount.

   Return the result table ordered by product_id and report_year. */

WITH Years AS
(
    SELECT CAST(2018 AS CHAR) AS report_year
    UNION
    SELECT CAST(2019 AS CHAR) AS report_year
    UNION
    SELECT CAST(2020 AS CHAR) AS report_year
),
NewSales AS
(
    SELECT
        Y.report_year,
        S.product_id,
        S.period_start,
        S.period_end,
        S.average_daily_sales,
        CASE
            WHEN Y.report_year = YEAR(period_start) AND
                 Y.report_year = YEAR(period_end) THEN DATEDIFF(period_end, period_start)+1
            WHEN Y.report_year = YEAR(period_start) THEN DATEDIFF(CONCAT(Y.report_year, '-12-31'), period_start)+1
            WHEN Y.report_year = YEAR(period_end) THEN DATEDIFF(period_end, CONCAT(Y.report_year, '-01-01'))+1
            ELSE 365
        END AS total_days
    FROM Years Y
    CROSS JOIN Sales S
    WHERE report_year >= YEAR(period_start) AND report_year <= YEAR(period_end)
    ORDER BY
        S.product_id,
        Y.report_year
)
SELECT
    N.product_id,
    P.product_name,
    N.report_year,
    N.average_daily_sales*N.total_days AS total_amount
FROM NewSales N
LEFT JOIN Product P ON N.product_id = P.product_id
ORDER BY
    N.product_id,
    N.report_year
