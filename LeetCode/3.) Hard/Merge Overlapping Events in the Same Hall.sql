/* Write an SQL query to merge all the overlapping events that are held in the same hall.
   Two events overlap if they have at least one day in common. */

WITH RECURSIVE LagHallEvents AS
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
    ) H
),
NewHallEvents AS
(
    SELECT
        hall_id,
        start_day,
        end_day,
        lag_end_day,
        max_lag_end_day,
        row_num,
        1 AS group_num
    FROM LagHallEvents    
    WHERE row_num = 1

    UNION

    SELECT
        L.hall_id,
        L.start_day,
        L.end_day,
        L.lag_end_day,
        L.max_lag_end_day,
        L.row_num,
        CASE
            WHEN L.start_day <= L.max_lag_end_day THEN N.group_num
            ELSE N.group_num+1
        END AS group_num
    FROM
        NewHallEvents N,
        LagHallEvents L
    WHERE L.row_num = N.row_num+1 AND
          L.row_num <= (SELECT COUNT(*) FROM HallEvents)
)
SELECT
    hall_id,
    MIN(start_day) AS start_day,
    MAX(end_day) AS end_day
FROM NewHallEvents
GROUP BY
    hall_id,
    group_num;
