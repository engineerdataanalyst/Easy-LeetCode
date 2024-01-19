-- Write a solution to calculate the average number of items per order, rounded to 2 decimal places.

SELECT ROUND(SUM(item_count*order_occurrences)/SUM(order_occurrences), 2) AS average_items_per_order
FROM Orders;
