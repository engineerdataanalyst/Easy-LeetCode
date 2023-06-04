/* The install date of a player is the first login day of that player.

   We define day one retention of some date x to be the number of players whose install date is x and they logged back in on the day right after x, 
   divided by the number of players whose install date is x, rounded to 2 decimal places.

   Write an SQL query to report for each install date, the number of players that installed the game on that day, and the day one retention. */

WITH InstallDates AS
(
    SELECT
        player_id,
        MIN(event_date) AS install_date
    FROM Activity
    GROUP BY player_id
),
NewActivity AS
(
    SELECT
        A.player_id,
        A.event_date,
        I.install_date,
        DATEDIFF(A.event_date, I.install_date) AS event_date_difference
    FROM Activity A
    LEFT JOIN InstallDates I ON A.player_id = I.player_id
),
NumInstalls AS
(
    SELECT
        install_date,
        COUNT(install_date) AS num_installs
    FROM InstallDates
    GROUP BY install_date
),
NumLogBacksUnjoined AS
(
    SELECT
        install_date,
        COUNT(*) AS num_log_backs
    FROM NewActivity
    WHERE event_date_difference = 1
    GROUP BY install_date
),
NumLogBacks AS
(
    SELECT
        N1.install_date,
        COALESCE(N2.num_log_backs, 0) AS num_log_backs
    FROM NumInstalls N1
    LEFT JOIN NumLogBacksUnjoined N2 ON N1.install_date = N2.install_date
)
SELECT
    N1.install_date AS install_dt,
    N1.num_installs AS installs,
    ROUND(N2.num_log_backs/N1.num_installs, 2) AS Day1_retention
FROM NumInstalls N1
LEFT JOIN NumLogBacks N2 ON N1.install_date = N2.install_date;
