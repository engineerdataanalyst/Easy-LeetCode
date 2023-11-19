/* Write an SQL query to report the names of all sellers who did not make any sales in 2020.
   Return the result table ordered by seller_name in ascending order. */

WITH SellerInfo AS
(
    SELECT
        S.seller_id,
        S.seller_name,
        O.sale_date,
        SUM(CASE
                WHEN YEAR(sale_date) = 2020 THEN 1
                ELSE 0
            END) AS sale2020_indicator
    FROM Seller S
    LEFT JOIN Orders O ON S.seller_id = O.seller_id
    GROUP BY S.seller_id
    HAVING sale2020_indicator = 0
    ORDER BY S.seller_name
)
SELECT seller_name
FROM SellerInfo;
