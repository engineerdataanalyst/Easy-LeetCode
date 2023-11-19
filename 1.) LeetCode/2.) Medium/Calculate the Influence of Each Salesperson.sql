/* Write an SQL query to report the sum of prices paid by the customers of each salesperson.
   If a salesperson does not have any customers, the total value should be 0. */

SELECT
    S1.salesperson_id,
    S1.name,
    COALESCE(SUM(S2.price), 0) AS total
FROM Salesperson S1
LEFT JOIN Customer C ON S1.salesperson_id = C.salesperson_id
LEFT JOIN Sales S2 ON C.customer_id = S2.customer_id
GROUP BY S1.salesperson_id;
