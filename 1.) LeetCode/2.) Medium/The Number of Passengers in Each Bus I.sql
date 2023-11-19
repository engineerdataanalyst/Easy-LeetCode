/* Buses and passengers arrive at the LeetCode station.

   If a bus arrives at the station at time tbus and a passenger arrived at time tpassenger where tpassenger <= tbus 
   and the passenger did not catch any bus, the passenger will use that bus.

   Write a solution to report the number of users that used each bus.
   Return the result table ordered by bus_id in ascending order. */

WITH NewBuses AS
(
    SELECT *
    FROM
    (
        SELECT
            B.bus_id,
            P.passenger_id,
            B.arrival_time AS bus_arrival_time,
            P.arrival_time AS passenger_arrival_time,
            ROW_NUMBER() OVER(PARTITION BY P.passenger_id ORDER BY P.passenger_id, B.arrival_time, P.arrival_time) AS row_num
        FROM Buses B
        CROSS JOIN Passengers P ON B.arrival_time >= P.arrival_time
    ) N
    WHERE row_num = 1
)
SELECT
    B.bus_id,
    COUNT(N.passenger_id) AS passengers_cnt
FROM Buses B
LEFT JOIN NewBuses N ON B.bus_id = N.bus_id
GROUP BY B.bus_id
ORDER BY B.bus_id;
