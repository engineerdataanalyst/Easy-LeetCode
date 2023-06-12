/* Write an SQL query to show the details of the invoice with the highest price.
   If two or more invoices have the same price, return the details of the one with the smallest invoice_id. */

WITH PriceSums AS
(
    SELECT
        *,
        DENSE_RANK() OVER(ORDER BY price_sum DESC, invoice_id) AS rank_num
    FROM
    (
        SELECT
            P1.invoice_id,
            SUM(P1.quantity*P2.price) AS price_sum
        FROM Purchases P1
        LEFT JOIN Products P2 ON P1.product_id = P2.product_id
        GROUP BY P1.invoice_id
    ) P
)
SELECT
    P1.product_id,
    P1.quantity,
    P1.quantity*P2.price AS price
FROM Purchases P1
LEFT JOIN Products P2 ON P1.product_id = P2.product_id
LEFT JOIN PriceSums P3 ON P1.invoice_id = P3.invoice_id
WHERE P3.rank_num = 1;
