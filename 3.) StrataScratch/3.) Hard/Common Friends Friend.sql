/* Find the number of a user's friends' friend who are also the user's friend.
   Output the user id along with the count. */

WITH friend_list AS
(-- Compute the list of friends for each user
    SELECT
        user_id AS user,
        friend_id AS friend
    FROM google_friends_network
    
    UNION
    
    SELECT 
        friend_id AS user,
        user_id AS friend
    FROM google_friends_network
),
friends_friend_list AS
(-- Compute the list of each users friends' friend
    SELECT
        f1.user,
        f1.friend AS friend,
        f2.friend AS user_friend
    FROM friend_list f1
    INNER JOIN friend_list f2 ON f1.friend = f2.user
),
joined_friend_list AS
(-- Join the two CTEs above based on the common user ID
    SELECT DISTINCT
        f1.user,
        f1.friend,
        f2.user_friend
    FROM friend_list f1
    INNER JOIN friends_friend_list f2 ON f1.user = f2.user
    WHERE f1.friend = f2.user_friend
)
SELECT -- Compute the desired output
    user,
    COUNT(*) AS num_friends
FROM joined_friend_list
GROUP BY user;
