/* Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. 
   In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, 
   then divide that number by the total number of players. */

WITH FirstLogInDates AS
(
    SELECT
        player_id,
        MIN(event_date) AS first_login_date
    FROM Activity
    GROUP BY player_id
),
NewActivity AS
(
    SELECT
        player_id,
        device_id,
        event_date,
        games_played,
        DENSE_RANK() OVER(PARTITION BY player_id ORDER BY event_date) AS rank_num
    FROM Activity
)
SELECT ROUND(COUNT(CASE
                       WHEN N.event_date = DATE_ADD((SELECT F.first_login_date
                                                     FROM FirstLogInDates F
                                                     WHERE F.player_id = N.player_id), 
                                                     INTERVAL 1 DAY) THEN N.player_id
                       ELSE NULL
                   END)/(SELECT COUNT(*) FROM FirstLogInDates), 2) AS fraction
FROM NewActivity N
WHERE rank_num = 2;
