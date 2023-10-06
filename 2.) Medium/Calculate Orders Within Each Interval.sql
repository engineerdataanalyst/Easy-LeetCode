/* Write a query to calculate total orders within each interval.
  Each interval is defined as a combination of 6 minutes.

  Minutes 1 to 6 fall within interval 1, while minutes 7 to 12 belong to interval 2, and so forth.
  Return the result table ordered by interval_no in ascending order. */

WITH Intervals AS
(
    SELECT
        *,
        CEIL(minute/6) AS interval_no
    FROM Orders
)
SELECT
    interval_no,
    SUM(order_count) AS total_orders
FROM Intervals
GROUP BY interval_no
ORDER BY interval_no;
