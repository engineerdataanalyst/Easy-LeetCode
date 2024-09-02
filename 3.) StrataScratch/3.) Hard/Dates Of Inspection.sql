/* Find the latest inspection date for the most sanitary restaurant(s).
   Assume the most sanitary restaurant is the one with the highest number of points received in any inspection (not just the last one).
   Only businesses with 'restaurant' in the name should be considered in your analysis.
   Output the corresponding facility name, inspection score, latest inspection date, previous inspection date, and the difference between the latest and previous inspection dates.
   And order the records based on the latest inspection date in ascending order. */

WITH rank_table AS
(-- Compute the following rankings:
 -- 1.) The rank of all the inspection scores in descending order.
 -- 2.) The rank of the inspection dates per facility in descending order.
    SELECT
        facility_name,
        score,
        activity_date AS inspection_date,
        DENSE_RANK() OVER(ORDER BY score DESC) AS score_rank_num,
        DENSE_RANK() OVER(PARTITION BY facility_name ORDER BY activity_date DESC) AS date_rank_num
    FROM los_angeles_restaurant_health_inspections
    WHERE LOWER(facility_name) LIKE '%restaurant%'
),
most_sanitary_restaurants AS
(-- Compute the most sanitary restaurant in terms of the highest overall inspection score.
    SELECT DISTINCT facility_name
    FROM rank_table
    WHERE score_rank_num = 1
),
latest_inspection_dates AS
(-- Compute the latest inspection dates per facility.
    SELECT
        facility_name,
        score,
        inspection_date AS latest_inspection_date
    FROM rank_table
    WHERE score_rank_num = 1 AND
          date_rank_num = 1
),
previous_inspection_dates AS
(-- Compute the previous inspection dates per facility.
    SELECT
        facility_name,
        score,
        inspection_date AS previous_inspection_date
    FROM rank_table
    WHERE score_rank_num = 1 AND
          date_rank_num = 2
)
SELECT 
-- Join the previous three CTEs based on the common facility_name column.
-- Sort the output in ascending order by latest inspection date.
    m.facility_name,
    l.score,
    l.latest_inspection_date,
    p.previous_inspection_date,
    DATEDIFF(l.latest_inspection_date, p.previous_inspection_date) AS inspection_date_difference
FROM most_sanitary_restaurants m
LEFT JOIN latest_inspection_dates l ON m.facility_name = l.facility_name
LEFT JOIN previous_inspection_dates p ON m.facility_name = p.facility_name
ORDER BY latest_inspection_date;
