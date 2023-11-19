/* Write an SQL query to find all the pairs of users with the maximum number of common followers.

   In other words, if the maximum number of common followers between any two users is maxCommon,
   then you have to return all pairs of users that have maxCommon common followers.

   The result table should contain the pairs user1_id and user2_id where user1_id < user2_id. */

WITH NumberOfFollowers AS
(
    SELECT
        *,
        DENSE_RANK() OVER(ORDER BY num_followers DESC) AS rank_num
    FROM
    (
        SELECT
            R1.user_id AS user1_id,
            R2.user_id AS user2_id,
            COUNT(R1.follower_id) AS num_followers
        FROM Relations R1
        CROSS JOIN Relations R2
        WHERE R1.user_id < R2.user_id AND
              R1.follower_id = R2.follower_id
        GROUP BY
            R1.user_id,
            R2.user_id
    ) R
)
SELECT
    user1_id,
    user2_id
FROM NumberOfFollowers
WHERE rank_num = 1;
