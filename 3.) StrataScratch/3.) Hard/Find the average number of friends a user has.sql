-- Find the average number of friends a user has.

WITH user_friends_list AS
(
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
num_user_friends AS
(
    SELECT
        user,
        COUNT(*) AS num_friends
    FROM user_friends_list
    GROUP BY user
)
SELECT AVG(num_friends) AS avg_num_friends
FROM num_user_friends;
