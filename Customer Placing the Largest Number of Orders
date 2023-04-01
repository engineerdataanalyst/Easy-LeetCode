SELECT customer_number
FROM Orders
GROUP BY customer_number
HAVING COUNT(order_number) = 
    (SELECT MAX(num_orders)
     FROM
         (SELECT
             customer_number,
             COUNT(order_number) AS num_orders
         FROM Orders
         GROUP BY customer_number) t);
