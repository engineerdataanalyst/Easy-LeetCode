WITH Clicks AS
(
    SELECT
        UserID,
        COUNT(UserID) AS num_link_clicks,
    FROM FrontendEventLog
    WHERE EventID = 5
    GROUP BY UserID
)
SELECT
    num_link_clicks,
    COUNT(num_link_clicks) AS num_users
FROM Clicks
GROUP BY num_link_clicks;
