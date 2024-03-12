/* Find the most profitable location.
   Write a query that calculates the average signup duration and average transaction amount for each location,
   and then compare these two measures together by taking the ratio of the average transaction amount and average duration for each location.

   Your output should include the location, average duration, average transaction amount, and ratio. Sort your results from highest ratio to lowest. */

WITH signup_durations AS
(
    SELECT DISTINCT
        location,
        signup_stop_date,
        signup_start_date
    FROM signups
),
avg_transaction_amounts AS
(
    SELECT
        s.location,
        AVG(t.amt) AS avg_transaction_amount
    FROM transactions t
    LEFT JOIN signups s ON t.signup_id = s.signup_id
    GROUP BY s.location
)
SELECT
    s.location,
    AVG(DATEDIFF(signup_stop_date, signup_start_date)) AS avg_signup_duration,
    avg_transaction_amount,
    avg_transaction_amount/AVG(DATEDIFF(signup_stop_date, signup_start_date)) AS ratio
FROM signup_durations s
LEFT JOIN avg_transaction_amounts a ON s.location = a.location
GROUP BY s.location
ORDER BY ratio DESC;
