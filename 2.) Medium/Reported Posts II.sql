/* Write an SQL query to find the average daily percentage of posts 
   that got removed after being reported as spam, 
   rounded to 2 decimal places. */

WITH ReportedPosts AS
(
    SELECT
        user_id,
        post_id,
        action_date,
        action,
        extra
    FROM Actions A
    WHERE action = 'report' AND extra = 'spam'
),
RemovedSpams AS
(
    SELECT
        post_id,
        action_date,
        COUNT(post_id) AS removed_spams
    FROM ReportedPosts
    WHERE post_id IN
    (
        SELECT post_id
        FROM Removals
    )
    GROUP BY action_date
),
TotalSpams AS
(
    SELECT
        R1.post_id,
        R1.action_date,
        R2.removed_spams,
        COUNT(R1.action_date) AS total_spams
    FROM ReportedPosts R1
    LEFT JOIN RemovedSpams R2 ON R1.post_id = R2.post_id
    GROUP BY action_date
),
RemovedSpamRatio AS
(
    SELECT
        action_date,
        removed_spams/total_spams*100 AS removed_spam_ratio
    FROM TotalSpams
)
SELECT ROUND(AVG(removed_spam_ratio), 2) AS average_daily_percent
FROM RemovedSpamRatio;
