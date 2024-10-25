/* An event is logged in the events table with a timestamp each time a new rider attempts a signup (with an event name 'attempted_su') 
   or successfully signs up (with an event name of 'su_success').

   For each city and date, determine the percentage of successful signups in the first 7 days of 2022 that completed a trip within 168 hours of the signup date.
   HINT: driver id column corresponds to rider id column */

SELECT
    s.city_id,
    DATE(s.timestamp) AS signup_date,
    COUNT(DISTINCT CASE WHEN TIMESTAMPDIFF(SECOND, s.timestamp, t.actual_time_of_arrival)/3600 <= 168 THEN s.rider_id END)/
    COUNT(DISTINCT s.rider_id)*100 AS percentage
FROM signup_events s
LEFT JOIN trip_details t ON s.rider_id = t.driver_id
WHERE s.event_name = 'su_success' AND 
      COALESCE(t.status, 'completed') = 'completed' AND
      DATE(s.timestamp) <= '2022-01-07'
GROUP BY
    s.city_id,
    signup_date;
