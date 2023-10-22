/* Write an SQL query to report the name and the mail of all interview candidates.
   A user is an interview candidate if at least one of these two conditions is true:

 - The user won any medal in three or more consecutive contests.
 - The user won the gold medal in three or more different contests (not necessarily consecutive). */

WITH StackedContests AS
(    
    SELECT
        contest_id,
        gold_medal AS user_id,
        'gold' AS medal
    FROM Contests
    
    UNION ALL

    SELECT
        contest_id,
        silver_medal AS user_id,
        'silver' AS medal
    FROM Contests
    
    UNION ALL

    SELECT
        contest_id,
        bronze_medal AS user_id,
        'bronze' AS medal
    FROM Contests
    ORDER BY
        user_id,
        contest_id
),
NewContests AS
(
    SELECT
        S.contest_id,
        CAST(S.total_rank_num AS DOUBLE)-CAST(S.user_rank_num AS DOUBLE) AS group_num,
        S.user_id,
        S.medal,
        U.name,
        U.mail
    FROM
    (
        SELECT
            contest_id,
            DENSE_RANK() OVER(ORDER BY contest_id) AS total_rank_num,
            DENSE_RANK() OVER(PARTITION BY user_id ORDER BY contest_id) AS user_rank_num,
            user_id,
            medal
        FROM StackedContests
    ) S
    LEFT JOIN Users U ON S.user_id = U.user_id
)
SELECT DISTINCT
    name,
    mail
FROM NewContests
GROUP BY
    user_id,
    group_num
HAVING COUNT(user_id) >= 3

UNION

SELECT
    name,
    mail
FROM NewContests
GROUP BY user_id
HAVING COUNT(CASE WHEN medal = 'gold' THEN user_id ELSE NULL END) >= 3;
