/* Write a query to find the Market Share at the Product Brand level for each Territory, for Time Period Q4-2021.
   Market Share is the number of Products of a certain Product Brand brand sold in a territory, divided by the total number of Products sold in this Territory.
   Output the ID of the Territory, name of the Product Brand and the corresponding Market Share in percentages.
   Only include these Product Brands that had at least one sale in a given territory. */

WITH prod_brands_sold AS
(
    SELECT
        m.territory_id,
        d.prod_brand,
        COUNT(*) AS num_prod_brands_sold
    FROM fct_customer_sales f
    INNER JOIN map_customer_territory m ON f.cust_id = m.cust_id
    INNER JOIN dim_product d ON f.prod_sku_id = d.prod_sku_id
    WHERE QUARTER(order_date) = 4 AND
          YEAR(order_date) = 2021
    GROUP BY
        m.territory_id,
        d.prod_brand
),
prod_brands_sold_per_territory AS
(
    SELECT
        m.territory_id,
        COUNT(*) AS num_prod_brands_sold
    FROM fct_customer_sales f
    INNER JOIN map_customer_territory m ON f.cust_id = m.cust_id
    WHERE QUARTER(order_date) = 4 AND
          YEAR(order_date) = 2021
    GROUP BY m.territory_id
)
SELECT
    p1.territory_id,
    p1.prod_brand,
    p1.num_prod_brands_sold/p2.num_prod_brands_sold*100 AS market_share
FROM prod_brands_sold p1
INNER JOIN prod_brands_sold_per_territory p2 ON p1.territory_id = p2.territory_id
ORDER BY
    p1.territory_id,
    market_share DESC;
