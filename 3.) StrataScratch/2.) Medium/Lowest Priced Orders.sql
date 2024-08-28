/* Find the lowest order cost of each customer.
   Output the customer id along with the first name and the lowest order price. */

WITH order_cost_ranks AS
(
    SELECT DISTINCT
        c.id,
        c.first_name,
        o.total_order_cost,
        RANK() OVER(PARTITION BY c.id ORDER BY o.total_order_cost) AS rank_num
    FROM customers c
    INNER JOIN orders o ON c.id = o.cust_id
)
SELECT
    id,
    first_name,
    total_order_cost AS lowest_order_cost
FROM order_cost_ranks
WHERE rank_num = 1;
