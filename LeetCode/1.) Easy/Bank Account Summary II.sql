/* Write an SQL query to report the name and balance of users with a balance higher than 10000. 
   The balance of an account is equal to the sum of the amounts of all transactions involving that account. */

SELECT
    U.name,
    SUM(T.amount) AS balance
FROM Users U
JOIN Transactions T ON u.account = T.account
GROUP BY U.name
HAVING balance > 10000;
