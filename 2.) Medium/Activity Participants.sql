/* Write an SQL query to find the names of all the activities with neither the maximum nor the minimum number of participants.

   Each activity in the Activities table is performed by any person in the table Friends. */

WITH NewFriends AS
(
    SELECT
        *,
        COUNT(*) OVER(PARTITION BY activity) AS num_activities
    FROM Friends
)
SELECT DISTINCT activity
FROM NewFriends
WHERE num_activities NOT IN
    ((SELECT MIN(num_activities) FROM NewFriends), 
     (SELECT MAX(num_activities) FROM NewFriends));
