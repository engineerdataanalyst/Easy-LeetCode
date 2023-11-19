/* A bank wants to draw a chart of the number of transactions bank visitors did in one visit to the bank and the corresponding number of visitors who have done this number of transaction in one visit.

   Write an SQL query to find how many users visited the bank and didn't do any transactions, how many visited the bank and did one transaction and so on.

   The result table will contain two columns:

   transactions_count which is the number of transactions done in one visit.
   visits_count which is the corresponding number of users who did transactions_count in one visit to the bank.
   transactions_count should take all values from 0 to max(transactions_count) done by one or more users.

  Return the result table ordered by transactions_count. */

WITH RECURSIVE TransactionsArray AS
(
    SELECT 0 AS transactions_count

    UNION

    SELECT transactions_count+1 AS transactions_count
    FROM
        TransactionsArray T1,
        (
            SELECT MAX(transactions_count) AS max_transactions_count
            FROM
            (
                SELECT COUNT(T.transaction_date) transactions_count
                FROM Visits V
                LEFT JOIN Transactions T ON V.user_id = T.user_id AND
                                            V.visit_date = T.transaction_date
                GROUP BY T.transaction_date
            ) T2
        ) T3
    WHERE T1.transactions_count < T3.max_transactions_count
),
VisitsArray AS
(
    SELECT
        transactions_count,
        COUNT(transactions_count) AS visits_count
    FROM
    (
        SELECT COUNT(T.user_id) AS transactions_count
        FROM Visits V
        LEFT JOIN Transactions T ON V.user_id = T.user_id AND
                                    V.visit_date = T.transaction_date
        GROUP BY
            V.user_id,
            V.visit_date
    ) V
    GROUP BY transactions_count
),
Unfiltered AS
(
    SELECT
        T.transactions_count,
        COALESCE(V.visits_count, 0) AS visits_count,
        SUM(COALESCE(V.visits_count, 0)) OVER(ORDER BY transactions_count DESC) AS running_sum
    FROM TransactionsArray T
    LEFT JOIN VisitsArray V ON T.transactions_count = V.transactions_count
)
SELECT
    transactions_count,
    visits_count
FROM Unfiltered
WHERE running_sum != 0
ORDER BY transactions_count;
