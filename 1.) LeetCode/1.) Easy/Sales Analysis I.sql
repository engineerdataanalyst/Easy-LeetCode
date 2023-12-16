/* Write an SQL query that reports 
   the best seller by total sales price, 
   If there is a tie, report them all. */

WITH TotalSalesPrices AS
(
    SELECT
        seller_id,
        SUM(price) AS total_sales_prices,
        DENSE_RANK() OVER(ORDER BY SUM(price) DESC) AS rank_num
    FROM Sales
    GROUP BY seller_id
)
SELECT seller_id
FROM TotalSalesPrices
WHERE rank_num = 1
ORDER BY seller_id;
