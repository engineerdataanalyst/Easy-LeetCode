/* Write an SQL query that reports the spending of each user.
   Return the resulting table ordered by spending in descending order.
   In case of a tie, order them by user_id in ascending order. */

SELECT
    S.user_id,
    SUM(S.quantity*P.price) AS spending
FROM Sales S
LEFT JOIN Product P ON S.product_id = P.product_id
GROUP BY S.user_id
ORDER BY
    spending DESC,
    user_id;
