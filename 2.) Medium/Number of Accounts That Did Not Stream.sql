-- Write an SQL query to report the number of accounts that bought a subscription in 2021 but did not have any stream session.

WITH SubscriptionsIn2021 AS
(
    SELECT *
    FROM Subscriptions
    WHERE YEAR(start_date) = 2021 OR
          YEAR(end_date) = 2021
),
StreamsNotIn2021 AS
(
    SELECT *
    FROM Streams
    WHERE YEAR(stream_date) != 2021
)
SELECT COUNT(*) AS accounts_count
FROM SubscriptionsIn2021 S1
INNER JOIN StreamsNotIn2021 S2 ON S1.account_id = S2.account_id;
