-- Write an SQL query to report the ID of each driver and the number of times they were a passenger.

SELECT
    driver_id,
    (
        SELECT COUNT(*)
        FROM Rides R1
        WHERE R1.passenger_id = R2.driver_id
    ) AS cnt
FROM Rides R2
GROUP BY driver_id
ORDER BY driver_id;
