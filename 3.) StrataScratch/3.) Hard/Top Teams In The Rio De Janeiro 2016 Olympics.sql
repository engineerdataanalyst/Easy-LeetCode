/* Find the top 3 medal-winning teams by counting the total number of medals for each event in the Rio De Janeiro 2016 olympics.
   In case there is a tie, order the countries by name in ascending order.
   Output the event name along with the top 3 teams as the 'gold team', 'silver team', and 'bronze team',
   with the team name and the total medals under each column in format "{team} with {number of medals} medals". 
   Replace NULLs with "No Team" string. */

WITH event_list AS
(
    SELECT DISTINCT event
    FROM olympics_athletes_events
    WHERE year = 2016 AND
          medal IS NOT NULL
),
medal_ranks AS
(
    SELECT
        event,
        team,
        COUNT(*) AS num_medals,
        RANK() OVER(PARTITION BY event ORDER BY COUNT(*) DESC, team) AS rank_num
    FROM olympics_athletes_events
    WHERE year = 2016 AND
          medal IS NOT NULL
    GROUP BY
        event,
        medal
),
most_medal_teams AS
(
    SELECT
        event,
        CONCAT(team, ' with ', num_medals, ' medals') AS most_medal_team
    FROM medal_ranks
    WHERE rank_num = 1
),
second_most_medal_teams AS
(
    SELECT
        event,
        CONCAT(team, ' with ', num_medals, ' medals') AS second_most_medal_team
    FROM medal_ranks
    WHERE rank_num = 2
),
third_most_medal_teams AS
(
    SELECT
        event,
        CONCAT(team, ' with ', num_medals, ' medals') AS third_most_medal_team
    FROM medal_ranks
    WHERE rank_num = 3
)
SELECT
    e.event,
    COALESCE(m.most_medal_team, 'No Team') AS most_medal_team,
    COALESCE(s.second_most_medal_team, 'No Team') AS second_most_medal_team,
    COALESCE(t.third_most_medal_team, 'No Team') AS third_most_medal_team
FROM event_list e
LEFT JOIN most_medal_teams m ON e.event = m.event
LEFT JOIN second_most_medal_teams s ON e.event = s.event
LEFT JOIN third_most_medal_teams t ON e.event = t.event
ORDER BY e.event;
