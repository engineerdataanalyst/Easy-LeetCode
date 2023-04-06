-- Write an SQL query to report the first login date for each player.

SELECT 
    player_id, 
    MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;
