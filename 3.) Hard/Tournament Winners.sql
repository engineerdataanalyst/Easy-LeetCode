/* The winner in each group is the player who scored the maximum total points within the group. 
   In the case of a tie, the lowest player_id wins.

   Write an SQL query to find the winner in each group. */

WITH FirstPlayerScores AS
(
    SELECT
        P.player_id,
        P.group_id,
        COALESCE(SUM(M.first_score), 0) AS total_score
    FROM Players P
    LEFT JOIN Matches M ON P.player_id = M.first_player
    GROUP BY
        P.player_id,
        P.group_id
),
SecondPlayerScores AS
(
    SELECT
        P.player_id,
        P.group_id,
        COALESCE(SUM(M.second_score), 0) AS total_score
    FROM Players P
    LEFT JOIN Matches M ON P.player_id = M.second_player
    GROUP BY
        P.player_id,
        P.group_id
),
TotalPlayerScores AS
(
    SELECT
        *,
        DENSE_RANK() OVER(PARTITION BY group_id ORDER BY total_score DESC, player_id) AS rank_num
    FROM
    (
        SELECT
            F.player_id,
            F.group_id,
            F.total_score+S.total_score AS total_score
        FROM FirstPlayerScores F
        LEFT JOIN SecondPlayerScores S ON F.player_id = S.player_id
    ) T
)
SELECT
    group_id,
    player_id
FROM TotalPlayerScores
WHERE rank_num = 1;
