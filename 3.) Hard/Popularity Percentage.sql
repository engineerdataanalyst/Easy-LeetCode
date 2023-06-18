/* Write an SQL query to find the popularity percentage for each user on Meta/Facebook.

   The popularity percentage is defined as the total number of friends the user has divided by the total number of users on the platform,
   then converted into a percentage by multiplying by 100, rounded to 2 decimal places.

   Return the result table ordered by user1 in ascending order. */

WITH NewFriends AS
(
    SELECT
        user1 AS user,
        user2 AS friend
    FROM Friends

    UNION

    SELECT
        user2 AS user,
        user1 AS friend
    FROM Friends
)
SELECT
    user AS user1,
    ROUND(COUNT(*)/(SELECT COUNT(DISTINCT user) FROM NewFriends)*100, 2) AS percentage_popularity
FROM NewFriends
GROUP BY user
ORDER BY user;
