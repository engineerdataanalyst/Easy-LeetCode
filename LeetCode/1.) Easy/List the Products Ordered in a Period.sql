SELECT
    P.product_name,
    SUM(O.unit) AS unit
FROM Products P
LEFT JOIN Orders O ON P.product_id = O.product_id
WHERE MONTH(O.order_date) = 2 AND YEAR(O.order_date) = 2020
GROUP BY P.product_id
HAVING unit >= 100;
