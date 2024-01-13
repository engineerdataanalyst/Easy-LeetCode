/* Write a solution to calculate the total spending by users on each Friday of every week in November 2023.
   If there are no purchases on a particular Friday of a week, it will be considered as 0.

   Return the result table ordered by week of month in ascending order. */

WITH Weeks AS
(
    SELECT
        1 AS week_of_month,
        STR_TO_DATE(CONCAT(2023, '-', 11, '-', 3), '%Y-%m-%d') AS purchase_date

    UNION ALL

    SELECT
        2 AS week_of_month,
        STR_TO_DATE(CONCAT(2023, '-', 11, '-', 10), '%Y-%m-%d') AS purchase_date

    UNION ALL

    SELECT
        3 AS week_of_month,
        STR_TO_DATE(CONCAT(2023, '-', 11, '-', 17), '%Y-%m-%d') AS purchase_date

    UNION ALL

    SELECT
        4 AS week_of_month,
        STR_TO_DATE(CONCAT(2023, '-', 11, '-', 24), '%Y-%m-%d') AS purchase_date
),
Purchases AS
(
    SELECT
        FLOOR((DAYOFMONTH(purchase_date)-1)/7)+1 AS week_of_month,
        purchase_date,
        SUM(amount_spend) AS total_amount
    FROM Purchases
    WHERE WEEKDAY(purchase_date) = 4 AND
          MONTH(purchase_date) = 11 AND
          YEAR(purchase_date) = 2023
    GROUP BY
        week_of_month,
        purchase_date
)
SELECT
    W.week_of_month,
    W.purchase_date,
    COALESCE(P.total_amount, 0) AS total_amount
FROM Weeks W
LEFT JOIN Purchases P ON W.week_of_month = P.week_of_month
ORDER BY week_of_month;
