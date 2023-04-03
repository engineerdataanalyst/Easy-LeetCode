/* If the customer's preferred delivery date is the same as the order date, 
   then the order is called immediate; otherwise, it is called scheduled.
   Write an SQL query to find the percentage of immediate orders in the table, 
   rounded to 2 decimal places. */

SELECT
    ROUND(COUNT(CASE
                    WHEN order_date = customer_pref_delivery_date
                    THEN customer_pref_delivery_date
                ELSE NULL END)/COUNT(order_date)*100, 2) AS immediate_percentage
FROM Delivery;
