/* A friendship between a pair of friends x and y is strong if x and y have at least three common friends.

   Write an SQL query to find all the strong friendships.
   Note that the result table should not contain duplicates with user1_id < user2_id. */

WITH Friends AS
(
    SELECT
        user1_id AS user_id,
        user2_id AS friend_id
    FROM Friendship

    UNION

    SELECT
        user2_id AS user_id,
        user1_id AS friend_id
    FROM Friendship
    ORDER BY
        user_id,
        friend_id
)
SELECT
    F1.user_id AS user1_id,
    F2.user_id AS user2_id,
    COUNT(*) AS common_friend
FROM Friends F1
CROSS JOIN Friends F2
INNER JOIN Friendship F3 ON F1.user_id = F3.user1_id AND
                            F2.user_id = F3.user2_id
WHERE F1.user_id < F2.user_id AND
      F1.friend_id = F2.friend_id
GROUP BY
    F1.user_id,
    F2.user_id
HAVING common_friend >= 3
ORDER BY
    F1.user_id,
    F2.user_id;
