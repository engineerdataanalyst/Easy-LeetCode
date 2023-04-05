/* Write a SQL query for a report that provides the pairs (actor_id, director_id)
   where the actor has cooperated with the director at least three times.
   Return the result table in any order. */

SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(actor_id) >= 3 AND COUNT(director_id) >= 3;
