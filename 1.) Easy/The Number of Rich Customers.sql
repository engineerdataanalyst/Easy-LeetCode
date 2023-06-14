-- Write an SQL query to report the number of customers who had at least one bill with an amount strictly greater than 500.

SELECT COUNT(DISTINCT customer_id) AS rich_count
FROM Store
WHERE amount > 500;
