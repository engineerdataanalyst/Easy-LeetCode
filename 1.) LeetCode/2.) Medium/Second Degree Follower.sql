/* A second-degree follower is a user who:
   follows at least one user, and
   is followed by at least one user.

   Write an SQL query to report the second-degree users and the number of their followers.
   Return the result table ordered by follower in alphabetical order. */

SELECT
    followee AS follower,
    COUNT(followee) AS num
FROM Follow
WHERE followee IN 
    (SELECT follower
     FROM Follow)
GROUP BY followee
ORDER BY followee;
