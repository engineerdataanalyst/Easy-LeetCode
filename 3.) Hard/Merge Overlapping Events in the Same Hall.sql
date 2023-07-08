/* Write an SQL query to merge all the overlapping events that are held in the same hall.
   Two events overlap if they have at least one day in common. */

WITH RECURSIVE NewHallEvents AS
(
    SELECT
        H2.hall_id,
        H2.start_day,
        H2.end_day,
        H2.lag_end_day,
        H2.max_lag_end_day,
        H2.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            hall_id,
            start_day,
            end_day,
            lag_end_day,
            MAX(lag_end_day) OVER(PARTITION BY hall_id ORDER BY start_day) AS max_lag_end_day,
            row_num
        FROM
        (
            SELECT
                hall_id,
                start_day,
                end_day,
                COALESCE(LAG(end_day) OVER(PARTITION BY hall_id ORDER BY start_day), start_day) AS lag_end_day,
                ROW_NUMBER() OVER() AS row_num
            FROM HallEvents
        ) H1
    ) H2
    WHERE row_num = 1

    UNION

    SELECT
        H2.hall_id,
        H2.start_day,
        H2.end_day,
        H2.lag_end_day,
        H2.max_lag_end_day,
        H2.row_num,
        CASE
            WHEN H2.start_day <= H2.max_lag_end_day THEN N.group_num
            ELSE N.group_num+1
        END AS group_num
    FROM
        NewHallEvents N,
        (
            SELECT
                hall_id,
                start_day,
                end_day,
                lag_end_day,
                MAX(lag_end_day) OVER(PARTITION BY hall_id ORDER BY start_day) AS max_lag_end_day,
                row_num
            FROM
            (
                SELECT
                    hall_id,
                    start_day,
                    end_day,
                    COALESCE(LAG(end_day) OVER(PARTITION BY hall_id ORDER BY start_day), start_day) AS lag_end_day,
                    ROW_NUMBER() OVER() AS row_num
                FROM HallEvents
            ) H1
        ) H2
    WHERE H2.row_num = N.row_num+1 AND
          H2.row_num <= (SELECT COUNT(*) FROM HallEvents)
)
SELECT
    hall_id,
    MIN(start_day) AS start_day,
    MAX(end_day) AS end_day
FROM NewHallEvents
GROUP BY
    hall_id,
    group_num;
