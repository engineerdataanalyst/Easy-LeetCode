/* Write an SQL query that reports the product_name, year, and price
   for each sale_id in the Sales table.
   Return the resulting table in any order. */

SELECT
    P.product_name,
    S.year,
    S.price
FROM Product P
INNER JOIN Sales S ON P.product_id = S.product_id;
