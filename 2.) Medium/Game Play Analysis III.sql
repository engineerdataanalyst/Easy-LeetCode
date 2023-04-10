/* Write an SQL query to report for each player and date, how many games played so far by the player. 
   That is, the total number of games played by the player until that date. */

SELECT
    player_id,
    event_date,
    SUM(games_played) OVER(PARTITION BY player_id ORDER BY event_date) AS games_played_so_far
FROM Activity;
