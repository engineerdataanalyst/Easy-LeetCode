/* Write an SQL query to find the most frequently ordered product(s) for each customer.
   The result table should have the product_id and product_name for each customer_id who ordered at least one order. */

WITH RowNumbers AS
(
    SELECT
        O.customer_id,
        O.product_id,
        P.product_name,
        ROW_NUMBER() OVER(PARTITION BY O.customer_id, O.product_id) AS row_num 
    FROM Orders O
    LEFT JOIN Products P ON O.product_id = P.product_id
)
SELECT
    R1.customer_id,
    R1.product_id,
    R1.product_name
FROM RowNumbers R1
WHERE R1.row_num = ALL (SELECT MAX(R2.row_num)
                        FROM RowNumbers R2
                        WHERE R1.customer_id = R2.customer_id
                        GROUP BY R2.customer_id);
