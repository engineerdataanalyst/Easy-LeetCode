/* Write an SQL query to report the IDs of the transactions with the maximum amount on their respective day. 
   If in one day there are multiple such transactions, return all of them.
   Return the result table ordered by transaction_id in ascending order. */

SELECT transaction_id
FROM Transactions
WHERE (DATE(day), amount) IN
    (SELECT
        DATE(day),
        MAX(amount)
    FROM Transactions
    GROUP BY DATE(day))
ORDER BY transaction_id;
