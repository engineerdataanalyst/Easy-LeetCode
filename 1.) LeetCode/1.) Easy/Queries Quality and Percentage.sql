/* We define query quality as:
   The average of the ratio between query rating and its position.

   We also define poor query percentage as:
   The percentage of all queries with rating less than 3.

   Write an SQL query to find each query_name, the quality and poor_query_percentage.
   Both quality and poor_query_percentage should be rounded to 2 decimal places. */

WITH Quality AS
(
    SELECT
        query_name,
        result,
        position,
        rating,
        ROUND(AVG(rating/position) OVER(PARTITION BY query_name), 2) AS quality
    FROM Queries
),
PoorQueryPercentage AS
(
    SELECT
        query_name,
        ROUND(COUNT(CASE WHEN rating < 3 THEN rating ELSE NULL END)/COUNT(*)*100, 2) AS poor_query_percentage
    FROM Quality
    GROUP BY query_name
)
SELECT DISTINCT
    Q.query_name,
    Q.quality,
    P.poor_query_percentage
FROM Quality Q
LEFT JOIN PoorQueryPercentage P ON Q.query_name = P.query_name
ORDER BY Q.quality DESC;
