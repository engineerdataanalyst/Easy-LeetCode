/* Write an SQL query to report the percentage of working drivers (working_percentage) for each month of 2020 where:
   percentage = (# of drivers that accepted at least one ride during the month)/(# of available drivers during the month)*100

   Note that if the number of available drivers during a month is zero, we consider the working_percentage to be 0.

   Return the result table ordered by month in ascending order, where month is the month's number (January is 1, February is 2, etc.). 
   Round working_percentage to the nearest 2 decimal places. */

WITH RECURSIVE Months AS
(
    SELECT 1 AS month

    UNION

    SELECT month+1 AS month
    FROM Months
    WHERE month < 12
),
-- Accepted Rides
NewAcceptedRides AS
(
    SELECT
        A.ride_id,
        A.driver_id,
        MONTH(R.requested_at) AS month,
        R.requested_at
    FROM AcceptedRides A
    INNER JOIN Rides R ON A.ride_id = R.ride_id
    ORDER BY
        month,
        R.requested_at
),
NumberOfAcceptedRides AS
(
    SELECT
        M.month,
        COUNT(DISTINCT CASE
                           WHEN YEAR(N.requested_at) = 2020 THEN N.driver_id
                           ELSE NULL
                       END) AS num_accepted_rides
    FROM Months M
    LEFT JOIN NewAcceptedRides N ON M.month = MONTH(N.requested_at)
    GROUP BY M.month
),
-- Active Drivers
NumberOfActiveDriversUnioned AS
(
    SELECT
        1 AS month,
        COUNT(CASE
                  WHEN YEAR(join_date) < 2020 THEN driver_id
                  ELSE NULL
              END) AS num_active_drivers
    FROM Drivers

    UNION ALL

    SELECT
        M.month,
        COUNT(CASE
                  WHEN YEAR(D.join_date) = 2020 THEN D.driver_id
                  ELSE NULL
              END) AS num_active_drivers
    FROM Months M
    LEFT JOIN Drivers D ON M.month = MONTH(D.join_date)
    GROUP BY M.month
),
NumberOfActiveDriversSummed AS
(
    SELECT
        month,
        SUM(num_active_drivers) AS num_active_drivers
    FROM NumberOfActiveDriversUnioned
    GROUP BY month
),
NumberOfActiveDrivers AS
(
    SELECT
        month,
        SUM(num_active_drivers) OVER(ORDER BY month) AS num_active_drivers
    FROM NumberOfActiveDriversSummed
)
SELECT
    N1.month,
    COALESCE(ROUND(N1.num_accepted_rides/N2.num_active_drivers*100, 2), 0) AS working_percentage
FROM NumberOfAcceptedRides N1
LEFT JOIN NumberOfActiveDrivers N2 ON N1.month = N2.month;
