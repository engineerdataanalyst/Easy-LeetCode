/* Write a solution to calculate the distance traveled by each user.
   If there is a user who hasn't completed any rides, then their distance should be considered as 0. 
   Output the user_id, name and total traveled distance.

   Return the result table ordered by user_id in ascending order. */

SELECT
    U.user_id,
    U.name,
    SUM(COALESCE(R.distance, 0)) AS 'traveled distance'
FROM Users U
LEFT JOIN Rides R ON U.user_id = R.user_id
GROUP BY U.user_id
ORDER BY U.user_id;
