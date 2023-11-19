/* Write an SQL query to recommend pages to the user with user_id = 1
   using the pages that your friends liked. 
   It should not recommend pages you already liked. */

WITH FriendIds AS
(
    SELECT user2_id AS friend_ids
    FROM Friendship
    WHERE user1_id = 1

    UNION

    SELECT user1_id AS friend_ids
    FROM Friendship
    WHERE user2_id = 1
),
LikedPages AS
(
    SELECT page_id
    FROM Likes
    WHERE user_id = 1
)
SELECT DISTINCT page_id AS recommended_page
FROM Likes
WHERE user_id IN (SELECT * FROM FriendIds) AND
      page_id NOT IN (SELECT * FROM LikedPages);
