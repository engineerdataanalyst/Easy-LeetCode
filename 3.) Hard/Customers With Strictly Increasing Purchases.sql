/* Write an SQL query to report the IDs of the customers with the total purchases strictly increasing yearly.

   The total purchases of a customer in one year is the sum of the prices of their orders in that year.
   If for some year the customer did not make any order, we consider the total purchases 0.

   The first year to consider for each customer is the year of their first order.

   The last year to consider for each customer is the year of their last order. */

WITH RECURSIVE Years AS
(
    SELECT YEAR(MIN(order_date)) AS year
    FROM Orders

    UNION
    
    SELECT year+1 AS year
    FROM Years
    WHERE year < (SELECT YEAR(MAX(order_date)) FROM Orders)
),
Customers AS
(
    SELECT DISTINCT customer_id
    FROM Orders
),
NewOrders AS
(
    SELECT
        O1.order_id,
        C.customer_id,
        Y.year,
        O1.order_date,
        COALESCE(O1.price, 0) AS price
    FROM Customers C
    CROSS JOIN Years Y
    LEFT JOIN Orders O1 ON Y.year = YEAR(O1.order_date) AND
                           C.customer_id = O1.customer_id
    WHERE Y.year BETWEEN (SELECT YEAR(MIN(order_date))
                          FROM Orders O2
                          WHERE C.customer_id = O2.customer_id) AND
                         (SELECT YEAR(MAX(order_date))
                          FROM Orders O3
                          WHERE C.customer_id = O3.customer_id)
    ORDER BY
        C.customer_id,
        Y.year,
        O1.order_date
),
PriceSums AS
(
    SELECT
        *,
        LEAD(price_sum) OVER(PARTITION BY customer_id ORDER BY year) AS lead_price_sum,
        CASE
            WHEN LEAD(price_sum) OVER(PARTITION BY customer_id ORDER BY year) <= price_sum THEN 1
            ELSE 0
        END AS price_sum_not_increasing
    FROM
    (
        SELECT
            customer_id,
            year,
            SUM(price) AS price_sum
        FROM NewOrders
        GROUP BY
            customer_id,
            year
        ORDER BY
            customer_id,
            year
    ) N
)
SELECT customer_id
FROM PriceSums
GROUP BY customer_id
HAVING SUM(price_sum_not_increasing) = 0;
