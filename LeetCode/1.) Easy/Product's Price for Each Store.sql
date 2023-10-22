-- Write an SQL query to find the price of each product in each store.

SELECT
    product_id,
    SUM(CASE WHEN store = 'store1' THEN price ELSE NULL END) AS store1,
    SUM(CASE WHEN store = 'store2' THEN price ELSE NULL END) AS store2,
    SUM(CASE WHEN store = 'store3' THEN price ELSE NULL END) AS store3
FROM Products
GROUP BY product_id;
