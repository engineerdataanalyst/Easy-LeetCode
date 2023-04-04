/* Write an SQL query to find the customer_number for the customer
   who has placed the largest number of orders.
   The test cases are generated so that exactly one customer
   will have placed more orders than any other customer. */

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
