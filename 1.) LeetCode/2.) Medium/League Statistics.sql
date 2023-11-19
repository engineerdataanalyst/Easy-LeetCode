/* Write an SQL query to report the statistics of the league. 

   The statistics should be built using the played matches where 
   the winning team gets three points and 
   the losing team gets no points. 

   If a match ends with a draw, both teams get one point.

   Each row of the result table should contain:
   team_name - The name of the team in the Teams table.
   matches_played - The number of matches played as either a home or away team.
   points - The total points the team has so far.
   goal_for - The total number of goals scored by the team across all matches.
   goal_against - The total number of goals scored by opponent teams against this team across all matches.
   goal_diff - The result of goal_for - goal_against.

   Return the result table ordered by points in descending order. 
   If two or more teams have the same points, order them by goal_diff in descending order. 
   If there is still a tie, order them by team_name in lexicographical order. */

WITH HomeTeam AS
(
    SELECT
        T.team_id,
        T.team_name,
        COUNT(T.team_id)-CASE
                             WHEN M.away_team_goals IS NOT NULL THEN 0
                             ELSE 1
                         END AS matches_played,
        SUM(CASE
                WHEN M.home_team_goals > M.away_team_goals THEN 3
                WHEN M.home_team_goals < M.away_team_goals OR
                     M.home_team_goals IS NULL THEN 0
                ELSE 1
            END) AS points,
        SUM(COALESCE(home_team_goals, 0)) AS goal_for,
        SUM(COALESCE(away_team_goals, 0)) AS goal_against,
        SUM(COALESCE(home_team_goals, 0))-SUM(COALESCE(away_team_goals, 0)) AS goal_diff
    FROM Teams T
    LEFT JOIN Matches M ON T.team_id = M.home_team_id
    GROUP BY T.team_id
),
AwayTeam AS
(
    SELECT
        T.team_id,
        T.team_name,
        COUNT(T.team_id)-CASE
                             WHEN M.home_team_goals IS NOT NULL THEN 0
                             ELSE 1
                         END AS matches_played,
        SUM(CASE
                WHEN M.away_team_goals > M.home_team_goals THEN 3
                WHEN M.away_team_goals < M.home_team_goals OR
                     M.away_team_goals IS NULL THEN 0
                ELSE 1
            END) AS points,
        SUM(COALESCE(away_team_goals, 0)) AS goal_for,
        SUM(COALESCE(home_team_goals, 0)) AS goal_against,
        SUM(COALESCE(away_team_goals, 0))-SUM(COALESCE(home_team_goals, 0)) AS goal_diff
    FROM Teams T
    LEFT JOIN Matches M ON T.team_id = M.away_team_id
    GROUP BY T.team_id
)
SELECT
    H.team_name,
    H.matches_played+A.matches_played AS matches_played,
    H.points+A.points AS points,
    H.goal_for+A.goal_for AS goal_for,
    H.goal_against+A.goal_against AS goal_against,
    H.goal_diff+A.goal_diff AS goal_diff
FROM HomeTeam H
LEFT JOIN AwayTeam A ON H.team_id = A.team_id
ORDER BY
    points DESC,
    goal_diff DESC,
    team_name;
