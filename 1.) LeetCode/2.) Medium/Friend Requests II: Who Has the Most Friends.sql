/* Write an SQL query to find the people who have the most friends and the most friends number.
   The test cases are generated so that only one person has the most friends. */

WITH Friends AS
(
    SELECT
        requester_id AS user_id,
        accepter_id AS friend_id
    FROM RequestAccepted

    UNION

    SELECT
        accepter_id AS user_id,
        requester_id AS friend_id
    FROM RequestAccepted
    ORDER BY
        user_id,
        friend_id
),
NumberOfFriends AS
(
    SELECT
        user_id AS id,
        COUNT(*) AS num
    FROM Friends
    GROUP BY user_id
)
SELECT
    id,
    num
FROM NumberOfFriends
WHERE num = (SELECT MAX(num) FROM NumberOFFriends);
