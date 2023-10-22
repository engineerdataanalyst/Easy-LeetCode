-- Write an SQL query to report the number of cubic feet of volume the inventory occupies in each warehouse.

SELECT
    W.name AS warehouse_name,
    SUM(W.units*P.Length*P.Width*P.Height) AS volume
FROM Products P
INNER JOIN Warehouse W ON P.product_id = W.product_id
GROUP BY warehouse_name
ORDER BY warehouse_name;
