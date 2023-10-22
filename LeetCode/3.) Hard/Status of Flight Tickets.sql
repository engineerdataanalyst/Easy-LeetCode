/* Passengers book tickets for flights in advance.
   If a passenger books a ticket for a flight and there are still empty seats available on the flight,
   the passenger's ticket will be confirmed.
   However, the passenger will be on a waitlist if the flight is already at full capacity.

   Write an SQL query to determine the current status of flight tickets for each passenger.
   Return the result table ordered by passenger_id in ascending order. */

WITH NewPassengers AS
(
    SELECT
        P.passenger_id,
        P.flight_id,
        P.booking_time,
        F.capacity,
        RANK() OVER(PARTITION BY flight_id ORDER BY booking_time) AS rank_num
    FROM Passengers P
    LEFT JOIN Flights F ON P.flight_id = F.flight_id
)
SELECT
    passenger_id,
    CASE
        WHEN capacity >= rank_num THEN 'Confirmed'
        ELSE 'Waitlist'
    END AS Status
FROM NewPassengers
ORDER BY passenger_id;
