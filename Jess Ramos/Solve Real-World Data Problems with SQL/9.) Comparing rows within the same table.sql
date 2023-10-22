WITH CTE1 AS
(
    SELECT 
        date_trunc('month', orderdate) as order_month, 
        sum(revenue) as monthly_revenue
    FROM 
        subscriptions
    GROUP BY 
        date_trunc('month', orderdate)
),
CTE2 AS
(
    SELECT
        order_month AS current_month,
        LAG(order_month) OVER(ORDER BY order_month) AS previous_month,
        monthly_revenue AS current_revenue,
        LAG(monthly_revenue) OVER(ORDER BY order_month) AS previous_revenue
    FROM CTE1
)
SELECT *
FROM CTE2
WHERE current_revenue > previous_revenue AND
      DATEDIFF('month', previous_month, current_month) = 1;
