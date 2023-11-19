/* Write an SQL query to find the prices of all products on 2019-08-16.
   Assume the price of all products before any change is 10. */

WITH ProductIds AS
(
    SELECT DISTINCT
        product_id,
        NULL AS price
    FROM Products
),
RankNumbers AS
(
    SELECT
        product_id,
        new_price,
        change_date,
        DENSE_RANK() OVER(PARTITION BY product_id ORDER BY change_date DESC) AS rank_num
    FROM Products
    WHERE change_date <= '2019-08-16'
)
SELECT
    P.product_id,
    COALESCE(R.new_price, 10) AS price
FROM ProductIds P
LEFT JOIN RankNumbers R ON P.product_id = R.product_id
WHERE R.rank_num = 1 OR R.rank_num IS NULL;
