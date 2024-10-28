/* Find the top 3 wineries in each country based on the average points earned.
  
   In case there is a tie, order the wineries by winery name in ascending order.
   Output the country along with the best, second best, and third best wineries. 
  
   If there is no second winery (NULL value) output 'No second winery' and if there is no third winery output 'No third winery'.
   For outputting wineries format them like this: "winery (avg_points)". */

WITH rank_nums AS
(-- Compute a list of the first three rank numbers.
 -- This list will be used for the joins in the upcoming CTEs.
    SELECT 1 AS rank_num
    UNION ALL
    SELECT 2 AS rank_num
    UNION ALL
    SELECT 3 AS rank_num
),
winery_ranks AS
(-- Rank the wineries by the largest average points per country.
 -- Wineries that come first alphabetically win the tiebreakers for average points.
    SELECT
        country,
        winery,
        ROUND(AVG(points)) AS avg_points,
        DENSE_RANK() OVER(PARTITION BY country ORDER BY AVG(points) DESC, winery) AS rank_num
    FROM winemag_p1
    GROUP BY
        country,
        winery
)
SELECT
-- Calculate the top three wineries by average points.
-- Left Join the two CTEs on the common rank number and country.
    w1.country,
    CONCAT(w1.winery, ' (', w1.avg_points, ')') AS top_winery,
    COALESCE(CONCAT(w2.winery, ' (', w2.avg_points, ')'), 'No second winery') AS second_winery,
    COALESCE(CONCAT(w3.winery, ' (', w3.avg_points, ')'), 'No third winery') AS third_winery
FROM rank_nums r
LEFT JOIN winery_ranks w1 ON r.rank_num = w1.rank_num
LEFT JOIN winery_ranks w2 ON w2.rank_num = w1.rank_num+1 AND
                             w2.country = w1.country
LEFT JOIN winery_ranks w3 ON w3.rank_num = w2.rank_num+1 AND
                             w3.country = w2.country
WHERE r.rank_num = 1;
