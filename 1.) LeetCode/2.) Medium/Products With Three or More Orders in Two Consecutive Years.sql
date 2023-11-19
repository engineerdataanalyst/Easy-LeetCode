-- Write an SQL query to report the IDs of all the products that were ordered three or more times in two consecutive years.

WITH RECURSIVE NewOrders AS
(
    SELECT
        O2.product_id,
        O2.num_orders,
        O2.lag_num_orders,
        O2.purchase_year,
        O2.lag_purchase_year,
        O2.purchase_year-O2.lag_purchase_year AS purchase_year_difference,
        O2.row_num,
        1 AS group_num,
        num_records
    FROM
    (
        SELECT
            product_id,
            num_orders,
            LAG(num_orders) OVER(PARTITION BY product_id ORDER BY purchase_year) AS lag_num_orders,
            purchase_year,
            COALESCE(lag_purchase_year, purchase_year) AS lag_purchase_year,
            ROW_NUMBER() OVER() AS row_num,
            num_records
        FROM
        (
            SELECT
                product_id,
                COUNT(order_id) AS num_orders,
                YEAR(purchase_date) AS purchase_year,
                LAG(YEAR(purchase_date)) OVER(PARTITION BY product_id ORDER BY YEAR(purchase_date)) AS lag_purchase_year,
                COUNT(*) OVER() AS num_records
            FROM Orders
            GROUP BY
                product_id,
                purchase_year
        ) O1
    ) O2
    WHERE row_num = 1

    UNION

    SELECT
        O2.product_id,
        O2.num_orders,
        O2.lag_num_orders,
        O2.purchase_year,
        O2.lag_purchase_year,
        O2.purchase_year-O2.lag_purchase_year AS purchase_year_difference,
        O2.row_num,
        CASE
            WHEN O2.num_orders < 3 OR
                 O2.lag_num_orders < 3 OR
                 O2.purchase_year-O2.lag_purchase_year > 1 THEN N.group_num+1
            ELSE N.group_num
        END AS group_num,
        N.num_records
    FROM
        NewOrders N,
        (
            SELECT
                product_id,
                num_orders,
                LAG(num_orders) OVER(PARTITION BY product_id ORDER BY purchase_year) AS lag_num_orders,
                purchase_year,
                COALESCE(lag_purchase_year, purchase_year) AS lag_purchase_year,
                ROW_NUMBER() OVER() AS row_num,
                num_records
            FROM
            (
                SELECT
                    product_id,
                    COUNT(order_id) AS num_orders,
                    YEAR(purchase_date) AS purchase_year,
                    LAG(YEAR(purchase_date)) OVER(PARTITION BY product_id ORDER BY YEAR(purchase_date)) AS lag_purchase_year,
                    COUNT(*) OVER() AS num_records
                FROM Orders
                GROUP BY
                    product_id,
                    purchase_year
            ) O1
        ) O2
    WHERE O2.row_num = N.row_num+1 AND
          O2.row_num <= O2.num_records
)
SELECT DISTINCT product_id
FROM NewOrders
WHERE num_orders >= 3
GROUP BY
    product_id,
    group_num
HAVING COUNT(purchase_year) >= 2;
