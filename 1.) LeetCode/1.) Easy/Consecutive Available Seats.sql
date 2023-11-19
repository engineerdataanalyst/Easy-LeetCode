/* Write an SQL query to report all the consecutive available seats in the cinema.
   Return the result table ordered by seat_id in ascending order.
   The test cases are generated so that more than two seats are consecutively available. */

WITH RECURSIVE NewCinemaWithoutCount AS
(
    SELECT
        C.seat_id,
        C.lag_seat_id,
        C.seat_id-C.lag_seat_id AS seat_id_difference,
        C.free,
        C.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            seat_id,
            COALESCE(LAG(seat_id) OVER(ORDER BY seat_id), seat_id) AS lag_seat_id,
            free,
            ROW_NUMBER() OVER() AS row_num
        FROM Cinema
        WHERE free = 1
    ) C
    WHERE C.row_num = 1

    UNION

    SELECT
        C.seat_id,
        C.lag_seat_id,
        C.seat_id-C.lag_seat_id,
        C.free,
        C.row_num,
        CASE
            WHEN C.seat_id-C.lag_seat_id > 1 THEN N.group_num+1
            ELSE N.group_num
        END AS group_num
    FROM
        NewCinemaWithoutCount N,
        (
            SELECT
                seat_id,
                COALESCE(LAG(seat_id) OVER(), seat_id) AS lag_seat_id,
                free,
                ROW_NUMBER() OVER() AS row_num
            FROM Cinema
            WHERE free = 1
        ) C
    WHERE C.row_num = N.row_num+1 AND
          C.row_num <= (SELECT COUNT(*) FROM Cinema)
),
NewCinema AS
(
    SELECT
        seat_id,
        lag_seat_id,
        seat_id_difference,
        free,
        row_num,
        group_num,
        COUNT(*) OVER(PARTITION BY group_num) AS num_seats
    FROM NewCinemaWithoutCount
)
SELECT seat_id
FROM NewCinema
WHERE num_seats > 1
ORDER BY seat_id;
