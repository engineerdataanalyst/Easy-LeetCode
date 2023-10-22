-- Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

WITH RankNumbers AS
(
    SELECT
        product_id,
        year AS first_year,
        quantity,
        price,
        DENSE_RANK() OVER(PARTITION BY product_id ORDER BY year) AS rank_num
    FROM Sales
)
SELECT
    product_id,
    first_year,
    quantity,
    price
FROM RankNumbers
WHERE rank_num = 1;
