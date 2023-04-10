/* Write a SQL query to find
   the IDs of the users who visited without making any transactions 
   and the number of times they made these types of visits. */

SELECT 
    V.customer_id,
    COUNT(V.customer_id) AS count_no_trans
FROM Transactions T
FULL JOIN Visits V ON T.visit_id = V.visit_id
WHERE V.visit_id IS NOT NULL AND T.transaction_id IS NULL
GROUP BY V.customer_id
ORDER BY count_no_trans DESC;
