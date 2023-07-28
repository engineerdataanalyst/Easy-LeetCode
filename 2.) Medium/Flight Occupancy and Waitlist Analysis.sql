/* Passengers book tickets for flights in advance. If a passenger books a ticket for a flight and there are still empty seats available on the flight, the passenger ticket will be confirmed.
   However, the passenger will be on a waitlist if the flight is already at full capacity.

   Write an SQL query to report the number of passengers who successfully booked a flight (got a seat) and the number of passengers who are on the waitlist for each flight.

   Return the result table ordered by flight_id in ascending order. */

SELECT
    F.flight_id,
    CASE
        WHEN COUNT(P.flight_id) > F.capacity THEN F.capacity
        ELSE COUNT(P.flight_id)
    END AS booked_cnt,
    CASE
        WHEN COUNT(P.flight_id) > F.capacity THEN COUNT(P.flight_id)-F.capacity
        ELSE 0
    END AS waitlist_cnt
FROM Flights F
LEFT JOIN Passengers P ON F.flight_id = P.flight_id
GROUP BY F.flight_id
ORDER BY F.flight_id;
