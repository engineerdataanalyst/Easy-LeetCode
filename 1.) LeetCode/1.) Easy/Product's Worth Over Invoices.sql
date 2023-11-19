/* Write an SQL query that will, for all products, 
   return each product name with the total amount due, paid, canceled, and refunded across all invoices.

   Return the result table ordered by product_name. */

SELECT
    P.name,
    COALESCE(SUM(I.rest), 0) AS rest,
    COALESCE(SUM(I.paid), 0) AS paid,
    COALESCE(SUM(I.canceled), 0) AS canceled,
    COALESCE(SUM(I.refunded), 0) AS refunded
FROM Product P
LEFT JOIN Invoice I ON P.product_id = I.product_id
GROUP BY P.product_id
ORDER BY P.name;
