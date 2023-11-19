/* Write a solution to find the IDs of the users that requested a confirmation message twice within a 24-hour window.
  Two messages exactly 24 hours apart are considered to be within the window. 
  The action does not affect the answer, only the request time.

  Return the result table in any order. */

WITH ElapsedSeconds AS
(
    SELECT
        *,
        TIMESTAMPDIFF(SECOND, lag_time_stamp, time_stamp) AS elapsed_seconds
    FROM
    (
        SELECT
            user_id,
            time_stamp,
            LAG(time_stamp) OVER(PARTITION BY user_id ORDER BY time_stamp) AS lag_time_stamp
        FROM Confirmations
    ) C
)
SELECT DISTINCT user_id
FROM ElapsedSeconds
WHERE elapsed_seconds IS NOT NULL AND
      elapsed_seconds <= 24*3600;
