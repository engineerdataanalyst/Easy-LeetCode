/* A player's winning streak is the number of consecutive wins uninterrupted by draws or losses.

   Write an SQL query to count the longest winning streak for each player. */

WITH RECURSIVE NewMatches AS
(
    SELECT
        M2.player_id,
        M2.match_day,
        M2.result,
        M2.lag_result,
        M2.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            player_id,
            match_day,
            result,
            COALESCE(lag_result, result) AS lag_result,
            ROW_NUMBER() OVER() AS row_num
        FROM
        (
            SELECT
                player_id,
                match_day,
                result,
                LAG(result) OVER(PARTITION BY player_id ORDER BY match_day) AS lag_result
            FROM Matches
        ) M1
    ) M2
    WHERE M2.row_num = 1

    UNION

    SELECT
        M2.player_id,
        M2.match_day,
        M2.result,
        M2.lag_result,
        M2.row_num,
        CASE
            WHEN M2.result != 'Win' OR
                 M2.lag_result != 'Win' THEN N.group_num+1
            ELSE N.group_num
        END AS group_num
    FROM
        NewMatches N,
        (
            SELECT
                player_id,
                match_day,
                result,
                COALESCE(lag_result, result) AS lag_result,
                ROW_NUMBER() OVER() AS row_num
            FROM
            (
                SELECT
                    player_id,
                    match_day,
                    result,
                    LAG(result) OVER(PARTITION BY player_id ORDER BY match_day) AS lag_result
                FROM Matches
            ) M1
        ) M2
    WHERE M2.row_num = N.row_num+1 AND
          M2.row_num <= (SELECT COUNT(*) FROM Matches)
),
PlayerIds AS
(
    SELECT DISTINCT player_id
    FROM Matches
),
WinStreaks AS
(
    SELECT
        *,
        DENSE_RANK() OVER(PARTITION BY player_id ORDER BY win_streak DESC) AS rank_num
    FROM
    (
        SELECT
            player_id,
            COUNT(*) AS win_streak
        FROM NewMatches
        WHERE result = 'Win'
        GROUP BY
            player_id,
            group_num
    ) N
)
SELECT DISTINCT
    P.player_id,
    COALESCE(W.win_streak, 0) AS longest_streak
FROM PlayerIds P
LEFT JOIN WinStreaks W ON P.player_id = W.player_id
WHERE COALESCE(rank_num, 1) = 1
ORDER BY P.player_id;
