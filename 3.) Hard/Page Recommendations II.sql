/* You are implementing a page recommendation system for a social media website.
   Your system will recommended a page to user_id if the page is liked by at least one friend of user_id and is not liked by user_id.

   Write an SQL query to find all the possible page recommendations for every user.
   Each recommendation should appear as a row in the result table with these columns:

   user_id: The ID of the user that your system is making the recommendation to.
   page_id: The ID of the page that will be recommended to user_id.
   friends_likes: The number of the friends of user_id that like page_id. */

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
),
LikedPages AS
(
    SELECT
        L.page_id,
        CONCAT(',', GROUP_CONCAT(DISTINCT F.user_id ORDER BY F.user_id), ',') AS liked_users
    FROM Friends F
    LEFT JOIN Likes L ON F.user_id = L.user_id
    GROUP BY page_id
)
SELECT
    F.user_id,
    L1.page_id,
    COUNT(L1.page_id) AS friends_likes
FROM Friends F
LEFT JOIN Likes L1 ON F.friend_id = L1.user_id
LEFT JOIN LikedPages L2 ON L1.page_id = L2.page_id
WHERE POSITION(CONCAT(',', F.user_id, ',') IN L2.liked_users) = 0
GROUP BY
    F.user_id,
    L1.page_id
ORDER BY
    F.user_id,
    L1.page_id;
