/* Write an SQL query to find for each month and country, 
   the number of transactions and their total amount, 
   the number of approved transactions and their total amount. */

SELECT
    CONCAT(YEAR(trans_date), "-", 
           CASE WHEN MONTH(trans_date) < 10 THEN "0" ELSE "" END, 
           MONTH(trans_date)) AS month,
    country,
    COUNT(trans_date) AS trans_count,
    COUNT(CASE WHEN state = 'approved' THEN state ELSE NULL END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY
    month,
    country
