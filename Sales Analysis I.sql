/* Write an SQL query that reports the best seller by total sales price,
   If there is a tie, report them all.
   Return the result table in any order. */

SELECT seller_id
FROM Sales
GROUP BY seller_id
HAVING SUM(price) =
    (SELECT MAX(price_sum)
     FROM
        (SELECT SUM(price) AS price_sum
         FROM Sales
         GROUP BY seller_id) t)
