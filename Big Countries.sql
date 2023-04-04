/* Write an SQL query to report the name, population, and area of the big countries.
   A country is big if:
   - it has an area of at least three million or
   - it has a population of at least twenty-five million */

SELECT name, population, area
FROM world
WHERE area >= 3000000 OR population >= 25000000;
