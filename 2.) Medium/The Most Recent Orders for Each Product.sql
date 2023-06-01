/* Write an SQL query to find the most recent order(s) of each product.

   Return the result table ordered by product_name in ascending order and in case of a tie by the product_id in ascending order.
   If there still a tie, order them by order_id in ascending order. */

WITH NewOrders AS
(
    SELECT
        O.order_id,
        O.order_date,
        O.customer_id,
        O.product_id,
        P.product_name,
        DENSE_RANK() OVER(PARTITION BY product_id ORDER BY order_date DESC) AS rank_num
    FROM Orders O
    LEFT JOIN Products P ON O.product_id = P.product_id
)
SELECT
    product_name,
    product_id,
    order_id,
    order_date
FROM NewOrders
WHERE rank_num = 1
ORDER BY
    product_name,
    product_id,
    order_id;
