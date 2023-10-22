/* Write an SQL query that reports the buyers who have bought S8 but not iPhone. 
   Note that S8 and iPhone are products present in the Product table. */

WITH ProductsPurchased AS
(
    SELECT
        S.buyer_id,
        CONCAT(',', GROUP_CONCAT(P.product_id), ',') AS products_purchased
    FROM Sales S
    LEFT JOIN Product P ON S.product_id = P.product_id
    GROUP BY S.buyer_id
),
S8 AS
(
    SELECT CONCAT(',', CONVERT(product_id, CHAR), ',') AS product_id
    FROM Product
    WHERE product_name = 'S8'
),
iPhone AS
(
    SELECT CONCAT(',', CONVERT(product_id, CHAR), ',') AS product_id
    FROM Product
    WHERE product_name = 'iPhone'
)
SELECT buyer_id
FROM ProductsPurchased
WHERE POSITION((SELECT product_id FROM S8) IN products_purchased) != 0 AND
      POSITION((SELECT product_id FROM iPhone) IN products_purchased) = 0
