/* Find the cheapest and the most expensive variety in each region.
   Output the region along with the corresponding most expensive and the cheapest variety.
   Be aware that there are 2 region columns, the price from that row applies to both of them. */
 
WITH wine_varieties AS
(
    SELECT
        region_1 AS region,
        variety,
        price
    FROM winemag_p1
    
    UNION
    
    SELECT
        region_2 AS region,
        variety,
        price
    FROM winemag_p1
),
cheapest_varieties AS
(
    SELECT
        region,
        cheapest_variety
    FROM
    (
        SELECT
            region,
            variety AS cheapest_variety,
            RANK() OVER(PARTITION BY region ORDER BY price) AS rank_num
        FROM wine_varieties
        WHERE region IS NOT NULL AND
              price IS NOT NULL
    ) r
    WHERE rank_num = 1
),
expensivest_varieties AS
(
    SELECT
        region,
        expensivest_variety
    FROM
    (
        SELECT
            region,
            variety AS expensivest_variety,
            RANK() OVER(PARTITION BY region ORDER BY price DESC) AS rank_num
        FROM wine_varieties
        WHERE region IS NOT NULL AND
              price IS NOT NULL
    ) r
    WHERE rank_num = 1
)
SELECT
    c.region,
    c.cheapest_variety,
    e.expensivest_variety
FROM cheapest_varieties c
INNER JOIN expensivest_varieties e ON c.region = e.region;
