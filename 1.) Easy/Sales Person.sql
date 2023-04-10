/* Write an SQL query to report the names of all the salespersons
   who did not have any orders related to the company with the name "RED". */
   
SELECT name
FROM SalesPerson
WHERE sales_id NOT IN
    (SELECT sales_id
     FROM Orders O
     LEFT JOIN Company C ON O.com_id = C.com_id
     WHERE C.name = 'RED');
