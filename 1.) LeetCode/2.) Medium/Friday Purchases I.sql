/* Write a solution to calculate the total spending by users on each Friday of every week in November 2023.
   Output only weeks that include at least one purchase on a Friday.

   Return the result table ordered by week of month in ascending order. */

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
ORDER BY week_of_month;
