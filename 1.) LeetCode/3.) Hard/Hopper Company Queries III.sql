/* Write an SQL query to compute the average_ride_distance and average_ride_duration of every 3-month window starting from January - March 2020 to October - December 2020.
   Round average_ride_distance and average_ride_duration to the nearest two decimal places.

   The average_ride_distance is calculated by summing up the total ride_distance values from the three months and dividing it by 3.
   The average_ride_duration is calculated in a similar way.

   Return the result table ordered by month in ascending order, where month is the starting month's number (January is 1, February is 2, etc.). */

WITH RECURSIVE Months AS
(
    SELECT 1 AS month

    UNION

    SELECT month+1 AS month
    FROM Months
    WHERE month < 12
),
NewAcceptedRides AS
(
    SELECT
        MONTH(R.requested_at) AS month,
        SUM(A.ride_distance) AS ride_distance,
        SUM(A.ride_duration) AS ride_duration
    FROM AcceptedRides A
    INNER JOIN Rides R ON A.ride_id = R.ride_id
    WHERE YEAR(R.requested_at) = 2020
    GROUP BY month
    ORDER BY
        month,
        R.requested_at
),
MovingAverages AS
(
    SELECT
        M.month,
        ROUND(AVG(COALESCE(N.ride_distance, 0)) OVER(ORDER BY M.month ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING), 2) AS average_ride_distance,
        ROUND(AVG(COALESCE(N.ride_duration, 0)) OVER(ORDER BY M.month ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING), 2) AS average_ride_duration
    FROM Months M
    LEFT JOIN NewAcceptedRides N ON M.month = N.month
)
SELECT *
FROM MovingAverages
WHERE month <= 10;
