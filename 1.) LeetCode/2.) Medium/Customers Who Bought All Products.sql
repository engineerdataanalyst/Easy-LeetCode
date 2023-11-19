/* Write an SQL query to report the customer ids from 
   the Customer table that bought all the products in the Product table. */

SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING SUM(DISTINCT product_key) = 
    (SELECT SUM(product_key)
     FROM Product);
