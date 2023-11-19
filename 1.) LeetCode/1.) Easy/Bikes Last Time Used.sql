/* Write an SQL query to find the last time when each bike was used.
   Return the result table ordered by the bikes that were most recently used. */

SELECT
    bike_number,
    MAX(end_time) AS end_time
FROM Bikes
GROUP BY bike_number
ORDER BY end_time DESC;
