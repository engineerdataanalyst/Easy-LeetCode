/* Write a solution to find the peak calling hour for each city.
   If multiple hours have the same number of calls, all of those hours will be recognized as peak hours for that specific city.

   Return the result table ordered by peak calling hour and city in descending order. */

WITH CallRanks AS
(
    SELECT
        city,
        HOUR(call_time) AS peak_calling_hour,
        COUNT(HOUR(call_time)) AS number_of_calls,
        DENSE_RANK() OVER(PARTITION BY city ORDER BY COUNT(HOUR(call_time)) DESC) AS rank_num
    FROM Calls
    GROUP BY
        city,
        peak_calling_hour
)
SELECT
    city,
    peak_calling_hour,
    number_of_calls
FROM CallRanks
WHERE rank_num = 1
ORDER BY
    peak_calling_hour DESC,
    city DESC;
