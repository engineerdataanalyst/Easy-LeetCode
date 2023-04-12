/* Leetcode Bank (LCB) helps its coders in making virtual payments. 
   Our bank records all transactions in the table Transaction, 
   we want to find out the current balance of all users and 
   check whether they have breached their credit limit (If their current credit is less than 0).

   Write an SQL query to report:
   user_id,
   user_name,
   credit, current balance after performing transactions, and
   credit_limit_breached, check credit_limit ("Yes" or "No") */

WITH T1 AS
(
    SELECT
        user_id,
        user_name,
        SUM(credit) AS total_credits
    FROM Users
    GROUP BY user_id
),
T2 AS
(
    SELECT
        U.user_id,
        U.user_name,
        SUM(COALESCE(T.amount, 0)) AS total_paid_by
    FROM Users U
    LEFT JOIN Transactions T ON U.user_id = T.paid_by
    GROUP BY U.user_id
),
T3 AS
(
    SELECT
        U.user_id,
        U.user_name,
        SUM(COALESCE(T.amount, 0)) AS total_paid_to
    FROM Users U
    LEFT JOIN Transactions T ON U.user_id = T.paid_to
    GROUP BY U.user_id
)
SELECT
    T1.user_id,
    T1.user_name,
    total_credits-total_paid_by+total_paid_to AS credit,
    CASE
        WHEN total_credits-total_paid_by+total_paid_to < 0 THEN 'Yes'
        ELSE 'No'
    END AS credit_limit_breached
FROM
    T1
LEFT JOIN
    T2 ON T1.user_id = T2.user_id
LEFT JOIN
    T3 ON T1.user_id = T3.user_id;
