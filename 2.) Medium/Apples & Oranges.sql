/* Write an SQL query to report the difference between
   the number of apples and oranges sold each day.
   Return the result table ordered by sale_date. */

SELECT
    sale_date,
    SUM(CASE WHEN fruit = 'apples' THEN sold_num ELSE 0 END)-
    SUM(CASE WHEN fruit = 'oranges' THEN sold_num ELSE 0 END) AS diff
FROM Sales
GROUP BY sale_date
ORDER BY sale_date;
