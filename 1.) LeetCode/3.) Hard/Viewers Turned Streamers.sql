/* Write a solution to find the number of streaming sessions for users whose first session was as a viewer.
   Return the result table ordered by count of streaming sessions, user_id in descending order. */

WITH FirstViewerUsers AS
(
    SELECT user_id
    FROM
    (
        SELECT
            user_id,
            session_type,
            ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY session_start) AS rank_num
        FROM Sessions
    ) S
    WHERE session_type = 'Viewer' AND
          rank_num = 1
)
SELECT
    F.user_id,
    COUNT(CASE WHEN S.session_type = 'Streamer' THEN F.user_id ELSE NULL END) AS sessions_count
FROM FirstViewerUsers F
INNER JOIN Sessions S ON F.user_id = S.user_id
GROUP BY F.user_id
HAVING sessions_count > 0
ORDER BY
    sessions_count DESC,
    F.user_id DESC;
