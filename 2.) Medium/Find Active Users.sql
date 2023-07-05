/* Write an SQL query that'll identify active users.
   An active user is a user that has made a second purchase within 7 days of any other of their purchases.

   For example, if the ending date is May 31, 2023. So any date between May 31, 2023, and June 7, 2023 (inclusive) would be considered "within 7 days" of May 31, 2023. */

WITH NewUsers AS
(
    SELECT
        user_id,
        item,
        created_at,
        lag_created_at,
        DATEDIFF(created_at, lag_created_at) AS created_at_difference
    FROM
    (
        SELECT
            user_id,
            item,
            created_at,
            LAG(created_at) OVER(PARTITION BY user_id ORDER BY created_at) AS lag_created_at,
            amount
        FROM Users
    ) U
)
SELECT DISTINCT user_id
FROM NewUsers
WHERE created_at_difference BETWEEN 0 AND 7
ORDER BY user_id;
