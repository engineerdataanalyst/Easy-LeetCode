/* Write a solution to find the third transaction
  (if they have at least three transactions) of every user, 
   where the spending on the preceding two transactions is lower than the spending on the third transaction

   Return the result table by user_id in ascending order. */

WITH UserIds AS
(
    SELECT DISTINCT user_id
    FROM Transactions
),
NewTransactions AS
(
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS row_num
    FROM Transactions
),
FirstTransactionSpends AS
(
    SELECT
        user_id,
        spend AS first_transaction_spend
    FROM NewTransactions
    WHERE row_num = 1
),
SecondTransactionSpends AS
(
    SELECT
        user_id,
        spend AS second_transaction_spend
    FROM NewTransactions
    WHERE row_num = 2
),
ThirdTransactionSpends AS
(
    SELECT
        user_id,
        spend AS third_transaction_spend,
        transaction_date AS third_transaction_date
    FROM NewTransactions
    WHERE row_num = 3
)
SELECT
    U.user_id,
    T.third_transaction_spend,
    T.third_transaction_date
FROM UserIds U
LEFT JOIN FirstTransactionSpends F ON U.user_id = F.user_id
LEFT JOIN SecondTransactionSpends S ON U.user_id = S.user_id
LEFT JOIN ThirdTransactionSpends T ON U.user_id = T.user_id
WHERE F.first_transaction_spend < T.third_transaction_spend AND
      S.second_transaction_spend < T.third_transaction_spend
ORDER BY user_id;
