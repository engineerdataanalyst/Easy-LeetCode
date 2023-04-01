/* Write an SQL query that reports the products 
   that were only sold in the first quarter of 2019.
   That is, between 2019-01-01 and 2019-03-31 inclusive.
   Return the result table in any order. */

SELECT
    P.product_id,
    P.product_name
FROM Product P
LEFT JOIN Sales S ON P.product_id = S.product_id
GROUP BY product_id
HAVING MIN(sale_date) BETWEEN '2019-01-01' AND '2019-03-31' AND
       MAX(sale_date) BETWEEN '2019-01-01' AND '2019-03-31';
