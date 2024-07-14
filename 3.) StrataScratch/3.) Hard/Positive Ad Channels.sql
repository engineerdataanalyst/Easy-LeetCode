/* Find the advertising channel with the smallest maximum yearly spending
   that still brings in more than 1500 customers each year. */

WITH agg_table AS
(
    SELECT
        advertising_channel,
        year,
        SUM(customers_acquired) AS total_customers_acquired,
        SUM(money_spent) AS total_money_spent
    FROM uber_advertising
    GROUP BY
        advertising_channel,
        year
),
agg_table_ranks AS
(
    SELECT
        advertising_channel,
        RANK() OVER(ORDER BY MAX(total_money_spent)) AS rank_num
    FROM agg_table
    GROUP BY advertising_channel
    HAVING MIN(total_customers_acquired) > 1500
)
SELECT advertising_channel
FROM agg_table_ranks
WHERE rank_num = 1;
