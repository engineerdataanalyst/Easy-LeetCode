/* Write an SQL query to recommend friends to Leetcodify users. 

   We recommend user x to user y if:
   Users x and y are not friends, and
   Users x and y listened to the same three or more different songs on the same day.
  
   Note that friend recommendations are unidirectional,
   meaning if user x and user y should be recommended to each other,
   the result table should have both user x recommended to user y and user y recommended to user x.

   Also, note that the result table should not contain duplicates (i.e., user y should not be recommended to user x multiple times.). */

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
),
Unfiltered AS
(
    SELECT
        L1.user_id AS user_id,
        L2.user_id AS recommended_id
    FROM Listens L1
    CROSS JOIN Listens L2
    WHERE L1.user_id != L2.user_id AND
          L1.song_id = L2.song_id AND
          L1.day = L2.day
    GROUP BY
        L1.user_id,
        L2.user_id,
        L1.day
    HAVING COUNT(DISTINCT L1.song_id) >= 3
    ORDER BY
        L1.user_id,
        L2.user_id
)
SELECT DISTINCT
    U.user_id,
    U.recommended_id
FROM Unfiltered U
LEFT JOIN Friends F ON U.user_id = F.user_id AND
                       U.recommended_id = F.friend_id
WHERE F.user_id IS NULL OR
      F.friend_id IS NULL;
