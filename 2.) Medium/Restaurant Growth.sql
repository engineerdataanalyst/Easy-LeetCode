/* You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
   
   Write an SQL query to compute the moving average of how much the customer paid in a seven days window 
   (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
   
   Return result table ordered by visited_on in ascending order. */

WITH Sums AS
(
    SELECT
        customer_id,
        name,
        visited_on,
        SUM(amount) AS total_amount
    FROM Customer
    GROUP BY visited_on
    ORDER BY visited_on
),
Averages AS
(
    SELECT
        visited_on,
        SUM(total_amount)
            OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
        ROUND(AVG(total_amount)
              OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount
    FROM Sums
),
FirstDate AS
(
    SELECT visited_on AS first_date
    FROM Sums
    LIMIT 1
),
DateAdd AS
(
    SELECT DATE_ADD(first_date, INTERVAL 6 DAY) AS date_add
    FROM FirstDAte
)
SELECT *
FROM Averages
WHERE visited_on >= (SELECT * FROM DateAdd);
