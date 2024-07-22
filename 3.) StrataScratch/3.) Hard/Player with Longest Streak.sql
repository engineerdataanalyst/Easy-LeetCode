/* You are given a table of tennis players and their matches that they could either win (W) or lose (L).
   Find the longest streak of wins.
   A streak is a set of consecutive won matches of one player.
   The streak ends once a player loses their next match. 
   
   Output the ID of the player or players and the length of the streak. */

WITH row_num_table AS 
(
    SELECT
        player_id,
        match_date,
        match_result,
        (ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_date))-
        (ROW_NUMBER() OVER(PARTITION BY player_id, match_result ORDER BY match_date)) AS group_num
    FROM players_results
),
agg_table AS
(
    SELECT
        player_id,
        group_num,
        COUNT(*) AS streak,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS rank_num
    FROM row_num_table
    WHERE match_result = 'W'
    GROUP BY
        player_id,
        group_num
)
SELECT
    player_id,
    streak
FROM agg_table
WHERE rank_num = 1;
