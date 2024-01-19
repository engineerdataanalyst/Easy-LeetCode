/* Write a solution to find cities where the average home prices exceed the national average home price.
   Return the result table sorted by city in ascending order. */

SELECT city
FROM Listings
GROUP BY city
HAVING AVG(price) > (SELECT AVG(price) FROM Listings)
ORDER BY city;
