WITH tenure_ranks AS
(-- Rank the hire dates of all employees from earliest to latest..
 -- Ignore employees who have been terminated.
    SELECT
        id,
        hire_date,
        MAX(hire_date) OVER() AS latest_hire_date,
        MIN(hire_date) OVER() AS earliest_hire_date,
        DENSE_RANK() OVER(ORDER BY hire_date DESC) AS shortest_tenure_rank,
        DENSE_RANK() OVER(ORDER BY hire_date) AS longest_tenure_rank
    FROM uber_employees
    WHERE termination_date IS NULL
)
SELECT
--  Find the number of employees with the longest and shortest tenure.
-- (determined by the earliest and latest hiring dates respectively)
--  Find the number of days between the earliest and latest hiring dates.
    COUNT(CASE WHEN shortest_tenure_rank = 1 THEN id END) AS shortest_tenure_count,
    COUNT(CASE WHEN longest_tenure_rank = 1 THEN id END) AS longest_tenure_count,
    DATEDIFF(latest_hire_date, earliest_hire_date) AS hire_days_diff
FROM tenure_ranks
WHERE shortest_tenure_rank = 1 OR
      longest_tenure_rank = 1
GROUP BY hire_days_diff;
