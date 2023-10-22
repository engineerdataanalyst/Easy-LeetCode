/* The average activity for a particular event_type is 
   the average occurences across all companies that have this event.

   An active business is a business that has
   more than one event_type such that their occurences 
   is strictly greater than the average activity for that event.

   Write an SQL query to find all active businesses. */

WITH Averages AS
(
    SELECT
        event_type,
        AVG(occurences) AS average_activity
    FROM Events
    GROUP BY event_type
)
SELECT business_id
FROM Events E
WHERE occurences >
    ANY
    (
        SELECT average_activity
        FROM Averages A
        WHERE A.event_type = E.event_type
    )
GROUP BY business_id
HAVING COUNT(business_id) > 1;
