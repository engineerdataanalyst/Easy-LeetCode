/* If the customer's preferred delivery date is the same as the order date, then the order is called immediate, otherwise, it is scheduled.

   Write an SQL query to find the percentage of immediate orders on each unique order_date, rounded to 2 decimal places. 
   Return the result table ordered by order_date in ascending order. */

SELECT
    order_date,
    ROUND(COUNT(CASE
                    WHEN order_date = customer_pref_delivery_date THEN order_date
                    ELSE NULL
                END)/COUNT(*)*100, 2) as immediate_percentage
FROM Delivery
GROUP BY order_date
ORDER BY order_date;
