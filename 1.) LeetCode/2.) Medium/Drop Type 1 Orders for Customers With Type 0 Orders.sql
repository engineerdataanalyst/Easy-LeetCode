/* Write an SQL query to report all the orders based on the following criteria:

   If a customer has at least one order of type 0, do not report any order of type 1 from that customer.
   Otherwise, report all the orders of the customer. */

WITH NewOrders AS
(
    SELECT
        order_id,
        customer_id,
        order_type,
        COUNT(CASE WHEN order_type = 0 THEN order_type ELSE NULL END) OVER(PARTITION BY customer_id) AS type0_orders
    FROM Orders
)
SELECT
    order_id,
    customer_id,
    order_type
FROM NewOrders
WHERE (type0_orders > 0 AND order_type != 1) OR
      (type0_orders = 0)
ORDER BY
    customer_id,
    order_id;
