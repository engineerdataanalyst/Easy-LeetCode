/* Write an SQL query to report the names of all the salespersons
   who did not have any orders related to the company with the name "RED". */
   
WITH ComList AS
(
    SELECT
        S.sales_id,
        S.name,
        COALESCE(CONCAT(' ', GROUP_CONCAT(DISTINCT C.name SEPARATOR ' '), ' '), 'N/A') AS com_list
    FROM SalesPerson S
    LEFT JOIN Orders O ON S.sales_id = O.sales_id
    LEFT JOIN Company C ON O.com_id = C.com_id
    GROUP BY S.sales_id
)
SELECT name
FROM ComList
WHERE REGEXP_INSTR(com_list, ' RED ') = 0;
