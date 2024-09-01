/* You have a table of in-app purchases by user.
   Users that make their first in-app purchase are placed in a marketing campaign where they see call-to-actions for more in-app purchases.
   Find the number of users that made additional in-app purchases due to the success of the marketing campaign.

  The marketing campaign doesn't start until one day after the initial in-app purchase
  so users that only made one or multiple purchases on the first day do not count, 
  nor do we count users that over time purchase only the products they purchased on the first day. */


WITH first_products AS
(-- Compute the first product IDs and first purchase date for each user
    SELECT
        user_id, 
        product_id,
        FIRST_VALUE(product_id) OVER(PARTITION BY user_id ORDER BY created_at) AS first_product_id,
        created_at AS purchase_date,
        FIRST_VALUE(created_at) OVER(PARTITION BY user_id ORDER BY created_at) AS first_purchase_date
    FROM marketing_campaign
),
agg_table AS
(-- Aggregate the previous CTE and filter down to users that brought distinct products
    SELECT user_id
    FROM first_products
    WHERE product_id != first_product_id AND
          purchase_date != first_purchase_date
    GROUP BY user_id
    HAVING COUNT(product_id) = COUNT(DISTINCT product_id)
)
SELECT COUNT(*) AS num_users
FROM agg_table;
