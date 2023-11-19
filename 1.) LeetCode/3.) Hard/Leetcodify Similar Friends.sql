/* Write an SQL query to report the similar friends of Leetcodify users.

   A user x and user y are similar friends if:
   Users x and y are friends, and
   Users x and y listened to the same three or more different songs on the same day.

   Note that you must return the similar pairs of friends the same way they were represented in the input (i.e., always user1_id < user2_id). */

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
)
SELECT DISTINCT
    F.user_id AS user1_id,
    F.friend_id AS user2_id
FROM Friends F
LEFT JOIN Listens L1 ON F.user_id = L1.user_id
LEFT JOIN Listens L2 ON F.friend_id = L2.user_id
WHERE F.user_id < F.friend_id AND
      L1.song_id = L2.song_id AND
      L1.day = L2.day
GROUP BY
    F.user_id,
    F.friend_id,
    L1.day
HAVING COUNT(DISTINCT L1.song_id) >= 3;
