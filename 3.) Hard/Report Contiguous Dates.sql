/* A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

   Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.
   period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

   Return the result table ordered by start_date. */

WITH RECURSIVE NewFailed AS
(
    SELECT
        F.fail_date,
        F.lag_fail_date,
        DATEDIFF(F.fail_date, F.lag_fail_date) AS fail_date_difference,
        F.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            fail_date,
            LAG(fail_date) OVER() AS lag_fail_date,
            ROW_NUMBER() OVER() AS row_num
        FROM Failed
        ORDER BY fail_date
    ) F
    WHERE F.row_num = 1

    UNION

    SELECT
        F.fail_date,
        F.lag_fail_date,
        DATEDIFF(F.fail_date, F.lag_fail_date) AS fail_date_difference,
        F.row_num,
        CASE
            WHEN DATEDIFF(F.fail_date, F.lag_fail_date) > 1 OR
                 DATEDIFF(F.fail_date, F.lag_fail_date) IS NULL THEN group_num+1
            ELSE group_num
        END AS group_num
    FROM
        NewFailed N,
        (
            SELECT
                fail_date,
                LAG(fail_date) OVER() AS lag_fail_date,
                ROW_NUMBER() OVER() AS row_num
            FROM Failed
            ORDER BY fail_date
        ) F
    WHERE F.row_num = N.row_num+1 AND
          F.row_num <= (SELECT COUNT(*) FROM Failed)
),
NewSucceeded AS
(
    SELECT
        S.success_date,
        S.lag_success_date,
        DATEDIFF(S.lag_success_date, S.success_date) AS success_date_difference,
        S.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            success_date,
            LAG(success_date) OVER() AS lag_success_date,
            ROW_NUMBER() OVER() AS row_num
        FROM Succeeded
        ORDER BY success_date
    ) S
    WHERE S.row_num = 1

    UNION

    SELECT
        S.success_date,
        S.lag_success_date,
        DATEDIFF(S.success_date, S.lag_success_date) AS success_date_difference,
        S.row_num,
        CASE
            WHEN DATEDIFF(S.success_date, S.lag_success_date) > 1 OR
                 DATEDIFF(S.success_date, S.lag_success_date) IS NULL THEN group_num+1
            ELSE group_num
        END AS group_num
    FROM
        NewSucceeded N,
        (
            SELECT
                success_date,
                LAG(success_date) OVER() AS lag_success_date,
                ROW_NUMBER() OVER() AS row_num
            FROM Succeeded
            ORDER BY success_date
        ) S
    WHERE S.row_num = N.row_num+1 AND
          S.row_num <= (SELECT COUNT(*) FROM Succeeded)
)
SELECT
    'failed' AS period_state,
    MIN(fail_date) AS start_date,
    MAX(fail_date) AS end_date
FROM NewFailed
WHERE YEAR(fail_date) = 2019
GROUP BY group_num

UNION

SELECT
    'succeeded' AS period_state,
    MIN(success_date) AS start_date,
    MAX(success_date) AS end_date
FROM NewSucceeded
WHERE YEAR(success_date) = 2019
GROUP BY group_num
ORDER BY start_date;
