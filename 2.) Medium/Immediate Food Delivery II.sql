/* If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

   The first order of a customer is the order with the earliest order date that the customer made. 
   It is guaranteed that a customer has precisely one first order.

   Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places. */
 
WITH FirstOrderDates AS
(
    SELECT DISTINCT
        delivery_id,
        customer_id,
        first_order_date,
        customer_pref_delivery_date,
        CASE
            WHEN first_order_date = customer_pref_delivery_date THEN 'immediate'
            ELSE 'scheduled'
        END order_type
    FROM
    (
        SELECT
            delivery_id,
            customer_id,
            order_date AS first_order_date,
            customer_pref_delivery_date,
            DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS rank_num
        FROM Delivery
    ) D
    WHERE rank_num = 1
)
SELECT ROUND(COUNT(CASE
                       WHEN order_type = 'immediate' THEN order_type
                       ELSE NULL
                   END)/COUNT(*)*100, 2) AS immediate_percentage
FROM FirstOrderDates;
