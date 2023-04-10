/* Write an SQL query to find the type of weather 
   in each country for November 2019.

   The type of weather is:

   Cold if the average weather_state is less than or equal 15,
   Hot if the average weather_state is greater than or equal to 25, and
   Warm otherwise. */

SELECT
   C.country_name,
   CASE
       WHEN AVG(W.weather_state) <= 15 THEN 'Cold'
       WHEN AVG(W.weather_state) >= 25 THEN 'Hot'
       ELSE 'Warm'
   END AS weather_type
FROM Countries C
LEFT JOIN Weather W ON C.country_id = W.country_id
WHERE MONTH(day) = 11 AND YEAR(day) = 2019
GROUP BY C.country_id
ORDER BY country_name;
