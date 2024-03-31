/* For every year, find the worst business in the dataset.
   The worst business has the most violations during the year.
   You should output the year, business name, and number of violations. */

WITH cte1 AS
(
    SELECT
        YEAR(inspection_date) AS year,
        business_name,
        COUNT(violation_id) AS violation_count
    FROM sf_restaurant_health_violations
    GROUP BY
        year,
        business_name
),
cte2 AS
(
    SELECT
        year,
        business_name,
        violation_count,
        RANK() OVER(PARTITION BY year ORDER BY violation_count DESC) AS rank_num
    FROM cte1
)
SELECT
    year,
    business_name,
    violation_count
FROM cte2
WHERE rank_num = 1;
