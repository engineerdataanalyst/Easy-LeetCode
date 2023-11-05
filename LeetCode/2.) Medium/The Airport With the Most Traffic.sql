/* Write an SQL query to report the ID of the airport with the most traffic.
   The airport with the most traffic is the airport that has the largest total number of flights that either departed from or arrived at the airport. 
   If there is more than one airport with the most traffic, report them all. */

WITH Airports AS
(
    SELECT
        departure_airport AS airport_id,
        flights_count
    FROM Flights

    UNION ALL

    SELECT
        arrival_airport AS airport_id,
        flights_count
    FROM Flights
),
FlightRanks AS
(
    SELECT
        *,
        DENSE_RANK() OVER(ORDER BY total_flights DESC) AS rank_num
    FROM
    (
        SELECT
            airport_id,
            SUM(flights_count) AS total_flights
        FROM Airports
        GROUP BY airport_id
    ) A
)
SELECT airport_id
FROM FlightRanks
WHERE rank_num = 1;
