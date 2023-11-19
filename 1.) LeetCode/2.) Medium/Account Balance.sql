/* Write an SQL query to report the balance of each user after each transaction. 

   You may assume that the balance of each account before any transaction is 0 and 
   that the balance will never be below 0 at any moment.

   Return the result table in ascending order by account_id, then by day in case of a tie. */

SELECT
    account_id,
    day,
    SUM(CASE
            WHEN type = 'Deposit' THEN amount
            WHEN type = 'Withdraw' THEN -amount
        END) OVER(PARTITION BY account_id ORDER BY day) AS balance
FROM Transactions
ORDER BY
    account_id,
    day
