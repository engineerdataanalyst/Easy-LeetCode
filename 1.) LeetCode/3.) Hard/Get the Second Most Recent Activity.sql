/* Write an SQL query to show the second most recent activity of each user.

   If the user only has one activity, return that one.
   A user cannot perform more than one activity at the same time. */

WITH NewUserActivity AS
(
    SELECT
        *,
        MAX(rank_num) OVER(PARTITION BY username) AS max_rank_num
    FROM
    (
        SELECT
            *,
            DENSE_RANK() OVER(PARTITION BY username ORDER BY startDate DESC) AS rank_num
        FROM UserActivity
    ) U
    WHERE rank_num <= 2
)
SELECT
    username,
    activity,
    startDate,
    endDate
FROM NewUserActivity
WHERE rank_num = max_rank_num;
