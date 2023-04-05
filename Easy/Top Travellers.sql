/* Write an SQL query to report the distance traveled by each user.
   Return the result table ordered by travelled_distance in descending order, 
   if two or more users traveled the same distance, 
   order them by their name in ascending order. */

SELECT
    U.name,
    SUM(COALESCE(R.distance, 0)) AS travelled_distance
FROM Users U
LEFT JOIN Rides R ON U.id = R.user_id
GROUP BY U.id
ORDER BY
    travelled_distance DESC,
    name;
