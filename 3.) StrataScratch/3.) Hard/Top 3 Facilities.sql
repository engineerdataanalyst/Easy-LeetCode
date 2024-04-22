/* Find the top 3 facilities for each owner.
   The top 3 facilities can be identified using the highest average score for each owner name and facility address grouping.
   The output should include 4 columns: owner name, top 1 facility address, top 2 facility address, and top 3 facility address.
   Order facilities with the same score alphabetically. */

WITH owner_names AS
(
    SELECT DISTINCT owner_name
    FROM los_angeles_restaurant_health_inspections
),
facility_ranks AS
(
    SELECT
        owner_name,
        facility_address,
        DENSE_RANK() OVER(PARTITION BY owner_name ORDER BY AVG(score) DESC, facility_address) AS rank_num
    FROM los_angeles_restaurant_health_inspections
    GROUP BY
        owner_name,
        facility_address
),
top1_facility AS
(
    SELECT
        owner_name,
        facility_address AS facility_1
    FROM facility_ranks
    WHERE rank_num = 1
),
top2_facility AS
(
    SELECT
        owner_name,
        facility_address AS facility_2
    FROM facility_ranks
    WHERE rank_num = 2
),
top3_facility AS
(
    SELECT
        owner_name,
        facility_address AS facility_3
    FROM facility_ranks
    WHERE rank_num = 3
)
SELECT
    o.owner_name,
    t1.facility_1,
    t2.facility_2,
    t3.facility_3
FROM owner_names o
LEFT JOIN top1_facility t1 ON o.owner_name = t1.owner_name
LEFT JOIN top2_facility t2 ON o.owner_name = t2.owner_name
LEFT JOIN top3_facility t3 ON o.owner_name = t3.owner_name
ORDER BY owner_name;
