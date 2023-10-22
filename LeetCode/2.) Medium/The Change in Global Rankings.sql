/* The global ranking of a national team is its rank after sorting all the teams by their points in descending order.
   If two teams have the same points, we break the tie by sorting them by their name in lexicographical order.

   The points of each national team should be updated based on its corresponding points_change value.

   Write an SQL query to calculate the change in the global rankings after updating each team's points. */

WITH OldTeamPoints AS
(
    SELECT
        team_id,
        name,
        points AS old_points,
        DENSE_RANK() OVER(ORDER BY points DESC, name) AS old_rank
    FROM TeamPoints
),
NewTeamPoints AS
(
    SELECT
        O.team_id,
        O.name,
        O.old_points,
        O.old_points+P.points_change AS new_points,
        P.points_change,
        DENSE_RANK() OVER(ORDER BY O.old_points+P.points_change DESC, O.name) AS new_rank
    FROM OldTeamPoints O
    LEFT JOIN PointsChange P ON O.team_id = P.team_id
)
SELECT
    O.team_id,
    O.name,
    CAST(O.old_rank AS DECIMAL)-CAST(N.new_rank AS DECIMAL) AS rank_diff
FROM OldTeamPoints O
LEFT JOIN NewTeamPoints N ON O.team_id = N.team_id
ORDER BY O.team_id;
