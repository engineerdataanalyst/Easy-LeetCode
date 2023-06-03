/* Write an SQL query to find the start and end number of continuous ranges in the table Logs.
   Return the result table ordered by start_id. */

WITH RECURSIVE NewLogs AS
(
    SELECT
        L.log_id,
        L.lag_log_id,
        L.log_id-L.lag_log_id AS log_id_difference,
        L.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            log_id,
            COALESCE(LAG(log_id) OVER(), log_id) AS lag_log_id,
            ROW_NUMBER() OVER() AS row_num
        FROM Logs
        ORDER BY log_id
    ) L
    WHERE L.row_num = 1

    UNION

    SELECT
        L.log_id,
        L.lag_log_id,
        L.log_id-L.lag_log_id AS log_id_difference,
        L.row_num,
        CASE
            WHEN L.log_id-L.lag_log_id > 1 THEN N.group_num+1
            ELSE N.group_num
        END AS group_num
    FROM
        NewLogs N,
        (
            SELECT
                log_id,
                COALESCE(LAG(log_id) OVER(), log_id) AS lag_log_id,
                ROW_NUMBER() OVER() AS row_num
            FROM Logs
            ORDER BY log_id
        ) L
    WHERE L.row_num = N.row_num+1 AND
          L.row_num <= (SELECT COUNT(*) FROM Logs)
)
SELECT
    MIN(log_id) AS start_id,
    MAX(log_id) AS end_id
FROM NewLogs
GROUP BY group_num
ORDER BY start_id;
