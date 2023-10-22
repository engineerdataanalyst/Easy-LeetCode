/* You would like to compute the scores of all teams after all matches. Points are awarded as follows:
   A team receives three points if they win a match (i.e., Scored more goals than the opponent team).
   A team receives one point if they draw a match (i.e., Scored the same number of goals as the opponent team).
   A team receives no points if they lose a match (i.e., Scored fewer goals than the opponent team).
  
   Write an SQL query that selects the team_id, team_name and num_points 
   of each team in the tournament after all described matches.
  
   Return the result table ordered by num_points in decreasing order. 
   In case of a tie, order the records by team_id in increasing order. */

WITH HostTeam AS
(
    SELECT
        T.team_id,
        T.team_name,
        SUM(CASE
                WHEN M.host_goals > M.guest_goals THEN 3
                WHEN M.host_goals = M.guest_goals THEN 1
                ELSE 0
            END) AS num_points
    FROM Teams T
    LEFT JOIN Matches M ON T.team_id = M.host_team
    GROUP BY T.team_id
),
GuestTeam AS
(
    SELECT
        T.team_id,
        T.team_name,
        SUM(CASE
                WHEN M.guest_goals > M.host_goals THEN 3
                WHEN M.guest_goals = M.host_goals THEN 1
                ELSE 0
            END) AS num_points
    FROM Teams T
    LEFT JOIN Matches M ON T.team_id = M.guest_team
    GROUP BY T.team_id
)
SELECT
    H.team_id,
    H.team_name,
    H.num_points+G.num_points AS num_points
FROM HostTeam H
LEFT JOIN GuestTeam G ON H.team_id = G.team_id
ORDER BY
    num_points DESC,
    team_id;
