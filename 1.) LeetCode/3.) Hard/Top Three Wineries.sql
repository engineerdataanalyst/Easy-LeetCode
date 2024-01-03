/* Write a solution to find the top three wineries in each country based on their total points.
   If multiple wineries have the same total points, order them by winery name in ascending order.
   If there's no second winery, output 'No Second Winery,' and if there's no third winery, output 'No Third Winery.'

   Return the result table ordered by country in ascending order. */

WITH Countries AS
(
    SELECT DISTINCT country
    FROM Wineries
),
WineryRanks AS
(
    SELECT
        country,
        winery,
        SUM(points) AS total_points,
        DENSE_RANK() OVER(PARTITION BY country ORDER BY SUM(points) DESC, winery) AS rank_num
    FROM Wineries
    GROUP BY
        country,
        winery
),
TopWineries AS
(
    SELECT
        country,
        CONCAT(winery, ' (', total_points, ')') AS top_winery
    FROM WineryRanks
    WHERE rank_num = 1
),
SecondWineries AS
(
    SELECT
        country,
        CONCAT(winery, ' (', total_points, ')') AS second_winery
    FROM WineryRanks
    WHERE rank_num = 2
),
ThirdWineries AS
(
    SELECT
        country,
        CONCAT(winery, ' (', total_points, ')') AS third_winery
    FROM WineryRanks
    WHERE rank_num = 3
)
SELECT
    C.country,
    T1.top_winery,
    COALESCE(S.second_winery, 'No second winery') AS second_winery,
    COALESCE(T2.third_winery, 'No third winery') AS third_winery
FROM Countries C
LEFT JOIN TopWineries T1 ON C.country = T1.country
LEFT JOIN SecondWineries S ON C.country = S.country
LEFT JOIN ThirdWineries T2 on C.country = T2.country
ORDER BY C.country;
