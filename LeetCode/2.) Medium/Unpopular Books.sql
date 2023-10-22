/* Write an SQL query that reports the books that have sold less than 10 copies in the last year, 
   excluding books that have been available for less than one month from today.
   Assume today is 2019-06-23. */

SELECT
    B.book_id,
    B.name
FROM Books B
LEFT JOIN Orders O ON B.book_id = O.book_id
WHERE B.available_from < DATE_ADD('2019-06-23', INTERVAL -1 MONTH)
GROUP BY B.book_id
HAVING SUM(CASE
               WHEN O.dispatch_date >= DATE_ADD('2019-06-23', INTERVAL -1 YEAR) THEN COALESCE(O.quantity, 0)
               ELSE 0
           END) < 10;
