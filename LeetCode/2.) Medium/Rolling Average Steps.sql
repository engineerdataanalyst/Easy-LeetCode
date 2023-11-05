/* Write a solution to calculate 3-day rolling averages of steps for each user.

   We calculate the n-day rolling average this way:

   For each day, we calculate the average of n consecutive days of step counts ending on that day if available, otherwise, n-day rolling average is not defined for it.
   Output the user_id, steps_date, and rolling average. Round the rolling average to two decimal places.

   Return the result table ordered by user_id, steps_date in ascending order. */

WITH NewSteps AS
(
    SELECT
        *,
        COALESCE(lead_steps_date-steps_date, 0) AS steps_date_difference
    FROM
    (
        SELECT
            user_id,
            steps_count,
            steps_date,
            LEAD(steps_date) OVER(PARTITION BY user_id ORDER BY steps_date) AS lead_steps_date
        FROM Steps
    ) S
),
RollingAverages AS
(
    SELECT
        user_id,
        steps_count,
        steps_date,
        ROUND(AVG(steps_count) OVER(PARTITION BY user_id ORDER BY steps_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_average,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY steps_date) AS row_num
    FROM NewSteps
    WHERE steps_date_difference IN (0, 1)
)
SELECT
    user_id,
    steps_date,
    rolling_average
FROM RollingAverages
WHERE row_num >= 3
ORDER BY
    user_id,
    steps_date;
