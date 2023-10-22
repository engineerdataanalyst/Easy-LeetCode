-- Write an SQL query to report all the sessions that did not get shown any ads.

WITH SessionsWithAds AS
(
    SELECT DISTINCT session_id
    FROM Playback P
    LEFT JOIN Ads A ON P.customer_id = A.customer_id
    WHERE A.timestamp BETWEEN P.start_time AND P.end_time
)
SELECT P.session_id
FROM Playback P
LEFT JOIN SessionsWithAds S ON P.session_id = S.session_id
WHERE S.session_id IS NULL
ORDER BY P.session_id;
