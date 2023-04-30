/* Write an SQL query to find the most recent three orders of each user. 
   If a user ordered less than three orders, return all of their orders.

   Return the result table ordered by customer_name in ascending order 
   and in case of a tie by the customer_id in ascending order. 
   If there is still a tie, order them by order_date in descending order. */

WITH T AS
(
    SELECT
        C.name AS customer_name,
        C.customer_id,
        O.order_id,
        O.order_date,
        DENSE_RANK() OVER(PARTITION BY C.customer_id ORDER BY O.order_date DESC) AS row_rank
    FROM Orders O
    LEFT JOIN Customers C ON O.customer_id = C.customer_id
    ORDER BY
        C.name,
        C.customer_id,
        O.order_date DESC
)
SELECT
    customer_name,
    customer_id,
    order_id,
    order_date
FROM T
WHERE row_rank <= 3
