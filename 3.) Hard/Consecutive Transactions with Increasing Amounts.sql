/* Write an SQL query to find the customers who have made consecutive transactions with increasing amount for at least three consecutive days. 
   Include the customer_id, start date of the consecutive transactions period and the end date of the consecutive transactions period.
   There can be multiple consecutive transactions by a customer.

   Return the result table ordered by customer_id in ascending order. */

WITH RECURSIVE NewTransactions AS
(
    SELECT
        T2.transaction_id,
        T2.customer_id,
        T2.lag_customer_id,
        T2.transaction_date,
        T2.lag_transaction_date,
        DATEDIFF(T2.transaction_date, T2.lag_transaction_date) AS transaction_date_difference,
        T2.amount,
        T2.lag_amount,
        T2.amount-T2.lag_amount AS amount_difference,
        T2.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            transaction_id,
            customer_id,
            COALESCE(LAG(customer_id) OVER(), customer_id) AS lag_customer_id,
            transaction_date,
            lag_transaction_date,
            amount,
            lag_amount,
            row_num
        FROM
        (
            SELECT
                transaction_id,
                customer_id,
                transaction_date,
                COALESCE(LAG(transaction_date) OVER(PARTITION BY customer_id ORDER BY transaction_date), transaction_date) AS lag_transaction_date,
                amount,
                LAG(amount) OVER(PARTITION BY customer_id ORDER BY transaction_date) AS lag_amount,
                ROW_NUMBER() OVER() AS row_num
            FROM Transactions
        ) T1
    ) T2
    WHERE T2.row_num = 1

    UNION

    SELECT
        T2.transaction_id,
        T2.customer_id,
        T2.lag_customer_id,
        T2.transaction_date,
        T2.lag_transaction_date,
        DATEDIFF(T2.transaction_date, T2.lag_transaction_date) AS transaction_date_difference,
        T2.amount,
        T2.lag_amount,
        T2.amount-T2.lag_amount AS amount_difference,
        T2.row_num,
        CASE
            WHEN 
                 T2.customer_id != T2.lag_customer_id OR
                 DATEDIFF(T2.transaction_date, T2.lag_transaction_date) > 1 OR
                 T2.amount-T2.lag_amount <= 0 THEN group_num+1
            ELSE group_num
        END AS group_num
    FROM
        NewTransactions N,
        (
            SELECT
                transaction_id,
                customer_id,
                COALESCE(LAG(customer_id) OVER(), customer_id) AS lag_customer_id,
                transaction_date,
                lag_transaction_date,
                amount,
                lag_amount,
                row_num
            FROM
            (
                SELECT
                    transaction_id,
                    customer_id,
                    transaction_date,
                    COALESCE(LAG(transaction_date) OVER(PARTITION BY customer_id ORDER BY transaction_date), transaction_date) AS lag_transaction_date,
                    amount,
                    LAG(amount) OVER(PARTITION BY customer_id ORDER BY transaction_date) AS lag_amount,
                    ROW_NUMBER() OVER() AS row_num
                FROM Transactions
            ) T1
        ) T2
    WHERE T2.row_num = N.row_num+1 AND
          T2.row_num <= (SELECT COUNT(*) FROM Transactions)
)
SELECT
    customer_id,
    MIN(transaction_date) AS consecutive_start,
    MAX(transaction_date) AS consecutive_end
FROM NewTransactions
GROUP BY
    customer_id,
    group_num
HAVING COUNT(group_num) >= 3;
