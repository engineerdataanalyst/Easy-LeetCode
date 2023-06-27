Write an SQL query to find all customer_id who made the maximum number of transactions on consecutive days.

Return all customer_id with the maximum number of consecutive transactions.
Order the result table by customer_id in ascending order.

WITH RECURSIVE NewTransactions AS
(
    SELECT
        T.transaction_id,
        T.customer_id,
        T.transaction_date,
        T.lag_transaction_date,
        DATEDIFF(T.transaction_date, T.lag_transaction_date) AS transaction_date_difference,
        T.amount,
        T.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            transaction_id,
            customer_id,
            transaction_date,
            COALESCE(LAG(transaction_date) OVER(PARTITION BY customer_id ORDER BY transaction_date), transaction_date) AS lag_transaction_date,
            amount,
            ROW_NUMBER() OVER() AS row_num
        FROM Transactions
    ) T
    WHERE T.row_num = 1

    UNION

    SELECT
        T.transaction_id,
        T.customer_id,
        T.transaction_date,
        T.lag_transaction_date,
        DATEDIFF(T.transaction_date, T.lag_transaction_date) AS transaction_date_difference,
        T.amount,
        T.row_num,
        CASE
            WHEN DATEDIFF(T.transaction_date, T.lag_transaction_date) > 1 THEN N.group_num+1
            ELSE N.group_num
        END AS group_num
    FROM
        NewTransactions N,
        (
            SELECT
                transaction_id,
                customer_id,
                transaction_date,
                COALESCE(LAG(transaction_date) OVER(PARTITION BY customer_id ORDER BY transaction_date), transaction_date) AS lag_transaction_date,
                amount,
                ROW_NUMBER() OVER() AS row_num
            FROM Transactions
        ) T
    WHERE T.row_num = N.row_num+1 AND
          T.row_num <= (SELECT COUNT(*) FROM Transactions)
),
NumberOfTransactions AS
(
    SELECT
        *,
        MAX(num_transactions) OVER() AS max_num_transactions
    FROM
    (
        SELECT
            customer_id,
            COUNT(*) AS num_transactions
        FROM NewTransactions
        GROUP BY
            customer_id,
            group_num
    ) N
)
SELECT customer_id
FROM NumberOfTransactions
WHERE num_transactions = max_num_transactions;
