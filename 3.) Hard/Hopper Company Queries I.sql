/* Write an SQL query to report the following statistics for each month of 2020:
   The number of drivers currently with the Hopper company by the end of the month (active_drivers).
   The number of accepted rides in that month (accepted_rides).
   Return the result table ordered by month in ascending order, where month is the month's number (January is 1, February is 2, etc.). */

WITH Months AS
(
    SELECT 1 AS month
    UNION
    SELECT 2 AS month
    UNION
    SELECT 3 AS month
    UNION
    SELECT 4 AS month
    UNION
    SELECT 5 AS month
    UNION
    SELECT 6 AS month
    UNION
    SELECT 7 AS month
    UNION
    SELECT 8 AS month
    UNION
    SELECT 9 AS month
    UNION
    SELECT 10 AS month
    UNION 
    SELECT 11 AS month
    UNION 
    SELECT 12 AS month
),
-- Active Drivers
ActiveDriversBefore2020 AS
(
    SELECT
        1 AS month,
        COUNT(join_date) AS active_drivers
    FROM Drivers
    WHERE YEAR(join_date) < 2020
),
ActiveDriversDuring2020 AS
(
    SELECT
        MONTH(join_date) AS month,
        COUNT(join_date) AS active_drivers
    FROM Months M
    LEFT JOIN Drivers D ON M.month = MONTH(join_date)
    WHERE YEAR(join_date) = 2020
    GROUP BY month
),
ActiveDriversTable AS
(
    SELECT
        M.month,
        SUM(COALESCE(A1.active_drivers, 0)+COALESCE(A2.active_drivers, 0)) OVER(ORDER BY M.month) AS active_drivers
    FROM Months M
    LEFT JOIN ActiveDriversBefore2020 A1 ON M.month = A1.month
    LEFT JOIN ActiveDriversDuring2020 A2 ON M.month = A2.month
),
-- Accepted Rides
AcceptedRidesDuring2020 AS
(
    SELECT
        MONTH(R.requested_at) AS month,
        COUNT(R.requested_at) AS accepted_rides
    FROM Months M
    LEFT JOIN Rides R ON M.month = MONTH(R.requested_at)
    INNER JOIN AcceptedRides A ON R.ride_id = A.ride_id
    WHERE YEAR(R.requested_at) = 2020
    GROUP BY month
),
AcceptedRidesTable AS
(
    SELECT
        M.month,
        COALESCE(A.accepted_rides, 0) AS accepted_rides
    FROM Months M
    LEFT JOIN AcceptedRidesDuring2020 A ON M.month = A.month
)
SELECT
    A1.month,
    A1.active_drivers,
    A2.accepted_rides
FROM ActiveDriversTable A1
LEFT JOIN AcceptedRidesTable A2 ON A1.month = A2.month;
