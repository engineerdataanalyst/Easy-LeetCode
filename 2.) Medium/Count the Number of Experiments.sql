/* Write an SQL query to report the number of experiments done on each of the three platforms for each of the three given experiments.
   Notice that all the pairs of (platform, experiment) should be included in the output including the pairs with zero experiments. */

WITH Platforms AS
(
    SELECT 'Android' AS platform
    UNION
    SELECT 'IOS' AS platform
    UNION
    SELECT 'Web' AS platform
),
ExperimentNames AS
(
    SELECT 'Reading' AS experiment_name
    UNION
    SELECT 'Sports' AS experiment_name
    UNION
    SELECT 'Programming' AS experiment_name
)
SELECT
    P.platform,
    E1.experiment_name,
    COUNT(E2.experiment_id) AS num_experiments
FROM Platforms P
CROSS JOIN ExperimentNames E1
LEFT JOIN Experiments E2 ON P.platform = E2.platform AND
                            E1.experiment_name = E2.experiment_name
GROUP BY
    P.platform,
    E1.experiment_name
ORDER BY
    P.platform,
    E1.experiment_name;
