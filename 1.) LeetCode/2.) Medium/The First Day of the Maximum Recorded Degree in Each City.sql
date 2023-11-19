/* Write an SQL query to report the day that has the maximum recorded degree in each city.
   If the maximum degree was recorded for the same city multiple times, return the earliest day among them.

   Return the result table ordered by city_id in ascending order. */

WITH NewWeather AS
(
    SELECT
        *,
        DENSE_RANK() OVER(PARTITION BY city_id ORDER BY degree DESC, day) AS rank_num
    FROM Weather
)
SELECT
    city_id,
    day,
    degree
FROM NewWeather
WHERE rank_num = 1;
