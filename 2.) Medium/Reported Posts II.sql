/* Write an SQL query to find the average daily percentage of posts 
   that got removed after being reported as spam, 
   rounded to 2 decimal places. */

WITH ReportedSpams AS
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
TotalSpams AS
(
    SELECT
        action_date,
        COUNT(DISTINCT post_id) AS total_spams
    FROM ReportedSpams
    GROUP BY action_date
),
RemovedSpams AS
(
    SELECT
        action_date,
        COUNT(DISTINCT post_id) AS removed_spams
    FROM ReportedSpams
    WHERE post_id IN
    (
        SELECT post_id
        FROM Removals
    )
    GROUP BY action_date
),
RemovedSpamRatio AS
(
    SELECT
        T.action_date,
        COALESCE(R.removed_spams, 0) AS removed_spams,
        COALESCE(T.total_spams, 0) AS total_spams,
        COALESCE(R.removed_spams/T.total_spams*100, 0) AS removed_spam_ratio
    FROM TotalSpams T
    LEFT JOIN RemovedSpams R ON T.action_date = R.action_date
)
SELECT ROUND(AVG(removed_spam_ratio), 2) AS average_daily_percent
FROM RemovedSpamRatio;
