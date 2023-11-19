/* Write an SQL query to report the customer_id and customer_name of customers who bought products "A", "B"
   but did not buy the product "C" since we want to recommend them to purchase this product.

   Return the result table ordered by customer_id. */

WITH Products AS
(
    SELECT
        customer_id,
        CONCAT(',', GROUP_CONCAT(DISTINCT product_name ORDER BY product_name), ',') AS products
    FROM Orders
    GROUP BY customer_id
)
SELECT
    C.customer_id,
    C.customer_name
FROM Customers C
LEFT JOIN Products P ON C.customer_id = P.customer_id
WHERE POSITION(',A,' IN P.products) != 0 AND
      POSITION(',B,' IN P.products) != 0 AND
      POSITION(',C,' IN P.products) = 0
ORDER BY
    C.customer_id;
