WITH RECURSIVE NewBuses AS
(
    SELECT
        *,
        ROW_NUMBER() OVER(ORDER BY arrival_time, bus_id) AS bus_row_num
    FROM Buses
),
NewPassengers AS
(
    SELECT
        *,
        ROW_NUMBER() OVER(ORDER BY arrival_time, passenger_id) AS passenger_row_num
    FROM Passengers
),
BusIds AS
(
    SELECT
        N1.passenger_id,
        N1.arrival_time,
        N1.passenger_row_num,

        (SELECT DISTINCT FIRST_VALUE(bus_id) OVER()
         FROM NewBuses N2
         WHERE N1.arrival_time <= N2.arrival_time) AS bus_id,

        (SELECT DISTINCT FIRST_VALUE(bus_row_num) OVER()
         FROM NewBuses N2
         WHERE N1.arrival_time <= N2.arrival_time) AS bus_row_num,
        
        (SELECT DISTINCT FIRST_VALUE(capacity) OVER()
         FROM NewBuses N2
         WHERE N1.arrival_time <= N2.arrival_time) AS capacity,

        (SELECT DISTINCT FIRST_VALUE(capacity) OVER()
         FROM NewBuses N2
         WHERE N1.arrival_time <= N2.arrival_time)-1 AS seats_remaining
    FROM NewPassengers N1
    WHERE N1.passenger_row_num = 1

    UNION

    SELECT
        N1.passenger_id,
        N1.arrival_time,
        N1.passenger_row_num,

        CASE
            WHEN B.seats_remaining != 0 AND
                 N1.arrival_time <= 
                 (SELECT arrival_time
                  FROM NewBuses N2
                  WHERE B.bus_id = N2.bus_id) THEN B.bus_id
            ELSE (SELECT DISTINCT FIRST_VALUE(bus_id) OVER()
                  FROM NewBuses N2
                  WHERE N1.arrival_time <= N2.arrival_time AND
                        B.bus_row_num < N2.bus_row_num)
        END AS bus_id,

        CASE
            WHEN B.seats_remaining != 0 AND
                 N1.arrival_time <= 
                 (SELECT arrival_time
                  FROM NewBuses N2
                  WHERE B.bus_id = N2.bus_id) THEN B.bus_row_num
            ELSE (SELECT DISTINCT FIRST_VALUE(bus_row_num) OVER()
                  FROM NewBuses N2
                  WHERE N1.arrival_time <= N2.arrival_time AND
                        B.bus_row_num < N2.bus_row_num)
        END AS bus_row_num,

        CASE
            WHEN B.seats_remaining != 0 AND
                 N1.arrival_time <= 
                 (SELECT arrival_time
                  FROM NewBuses N2
                  WHERE B.bus_id = N2.bus_id) THEN B.capacity
            ELSE (SELECT DISTINCT FIRST_VALUE(capacity) OVER()
                  FROM NewBuses N2
                  WHERE N1.arrival_time <= N2.arrival_time AND
                        B.bus_row_num < N2.bus_row_num)
        END AS capacity,

        CASE
            WHEN B.seats_remaining != 0 AND
                 CASE
                    WHEN B.seats_remaining != 0 AND
                         N1.arrival_time <= 
                         (SELECT arrival_time
                          FROM NewBuses N2
                          WHERE B.bus_id = N2.bus_id) THEN B.bus_id
                    ELSE (SELECT DISTINCT FIRST_VALUE(bus_id) OVER()
                          FROM NewBuses N2
                          WHERE N1.arrival_time <= N2.arrival_time AND
                                B.bus_row_num < N2.bus_row_num)
                END = B.bus_id THEN B.seats_remaining-1
            ELSE (SELECT DISTINCT FIRST_VALUE(capacity) OVER()
                  FROM NewBuses N2
                  WHERE N1.arrival_time <= N2.arrival_time AND
                        B.bus_row_num < N2.bus_row_num)-1
        END AS seats_remaining
    FROM
        BusIds B,
        NewPassengers N1
    WHERE N1.passenger_row_num = B.passenger_row_num+1 AND
          N1.passenger_row_num <= (SELECT COUNT(*) FROM NewPassengers)
)
SELECT
    B1.bus_id,
    COUNT(B2.bus_id) AS passengers_cnt
FROM Buses B1
LEFT JOIN BusIds B2 ON B1.bus_id = B2.bus_id
GROUP BY B1.bus_id
ORDER BY B1.bus_id;
