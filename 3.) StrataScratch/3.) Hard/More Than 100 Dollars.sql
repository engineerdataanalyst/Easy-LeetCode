/* The company for which you work is reviewing its 2021 monthly sales.
   For each month of 2021, calculate what percentage of restaurants have reached at least 100$ or more in monthly sales.

   Note: Please remember that if an order has a blank value for actual_delivery_time, it has been canceled and therefore does not count towards monthly sales. */

WITH restaurant_sales AS
(
    SELECT
        MONTH(d.actual_delivery_time) AS month,
        d.restaurant_id,
        SUM(o.sales_amount) AS total_sales
    FROM delivery_orders d
    INNER JOIN order_value o ON d.delivery_id = o.delivery_id
    WHERE YEAR(d.actual_delivery_time) = 2021 AND
          d.actual_delivery_time IS NOT NULL
    GROUP BY
        month,
        d.restaurant_id
)
SELECT
    month,
    COUNT(CASE WHEN total_sales >= 100 THEN restaurant_id END)/COUNT(*)*100 AS perc_over_100
FROM restaurant_sales
GROUP BY month
ORDER BY month;
