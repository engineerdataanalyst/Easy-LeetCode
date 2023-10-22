/* Write an SQL query that reports all the possible matches of the league.
   Note that every two teams play two matches with each other, with one team being the home_team once and the other time being the away_team. */

SELECT
    T1.team_name AS home_team,
    T2.team_name AS away_team
FROM Teams T1
CROSS JOIN Teams T2
WHERE T1.team_name != T2.team_name;
