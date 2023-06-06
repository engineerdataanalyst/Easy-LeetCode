/* Write an SQL query to report the IDs of the users that made any two purchases at most 7 days apart.
   Return the result table ordered by user_id. */

WITH NewPurchases AS
(
    SELECT
        *,
        DATEDIFF(lead_purchase_date, purchase_date) AS purchase_window,
        COUNT(*) OVER(PARTITION BY user_id) AS num_purchases
    FROM
    (
        SELECT DISTINCT
            user_id,
            purchase_date,
            LEAD(purchase_date) OVER(PARTITION BY user_id ORDER BY purchase_date) AS lead_purchase_date
        FROM Purchases
    ) P
)
SELECT DISTINCT user_id
FROM NewPurchases
WHERE  purchase_window IS NOT NULL AND
      (purchase_window <= 7 OR
       num_purchases = 1);
