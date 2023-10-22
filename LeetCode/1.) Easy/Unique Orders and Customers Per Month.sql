-- Write an SQL query to find the number of unique orders and the number of unique customers with invoices > $20 for each different month.

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(CASE WHEN invoice > 20 THEN order_date ELSE NULL END) AS order_count,
    COUNT(DISTINCT CASE WHEN invoice > 20 THEN customer_id ELSE NULL END) AS customer_count
FROM Orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
HAVING customer_count > 0;
