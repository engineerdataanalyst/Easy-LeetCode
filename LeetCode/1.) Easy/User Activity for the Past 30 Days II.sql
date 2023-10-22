/* Write an SQL query to find the average number of sessions per user for a period of 30 days ending 2019-07-27 inclusively, rounded to 2 decimal places.
   The sessions we want to count for a user are those with at least one activity in that time period. */

WITH NumberOfSessions AS
(
    SELECT
        user_id,
        COUNT(DISTINCT session_id) AS num_sessions
    FROM Activity
    WHERE DATEDIFF('2019-07-27', activity_date) < 30
    GROUP BY user_id
)
SELECT COALESCE(ROUND(AVG(num_sessions), 2), 0) AS average_sessions_per_user
FROM NumberOfSessions;
