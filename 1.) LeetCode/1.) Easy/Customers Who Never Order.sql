-- Write an SQL query to report all customers who never order anything.

SELECT name AS Customers
FROM Customers C
LEFT JOIN Orders O ON C.id = O.customerId
WHERE O.customerID IS NULL;
