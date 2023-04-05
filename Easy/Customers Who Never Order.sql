-- Write an SQL query to report all customers who never order anything.

SELECT name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.customerID IS NULL;
