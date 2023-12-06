/* Write a solution to find for each month and country: 
   the number of approved transactions and their total amount, the number of chargebacks, and their total amount.

   Note: In your solution, given the month and country, ignore rows with all zeros. */

WITH Months AS
(
    SELECT
        DATE_FORMAT(trans_date, '%Y-%m') AS month,
        country
    FROM Transactions
    GROUP BY
        month,
        country

    UNION

    SELECT
        DATE_FORMAT(C.trans_date, '%Y-%m') AS month,
        T.country
    FROM Chargebacks C
    LEFT JOIN Transactions T ON C.trans_id = T.id
    GROUP BY
        month,
        T.country
),
NewTransactions AS
(
    SELECT
        DATE_FORMAT(T.trans_date, '%Y-%m') AS month,
        T.country,
        COUNT(CASE WHEN T.state = 'approved' THEN T.id ELSE NULL END) AS approved_count,
        SUM(CASE WHEN T.state = 'approved' THEN T.amount ELSE 0 END) AS approved_amount
    FROM Transactions T
    LEFT JOIN Chargebacks C ON T.id = C.trans_id
    GROUP BY
        month,
        T.country
),
NewChargebacks AS
(
    SELECT
        DATE_FORMAT(C.trans_date, '%Y-%m') AS month,
        T.country,
        COUNT(*) AS chargeback_count,
        SUM(T.amount) AS chargeback_amount
    FROM Chargebacks C
    INNER JOIN Transactions T ON C.trans_id = T.id
    GROUP BY
        month,
        T.country
)
SELECT
    M.month,
    M.country,
    COALESCE(N1.approved_count, 0) AS approved_count,
    COALESCE(N1.approved_amount, 0) AS approved_amount,
    COALESCE(N2.chargeback_count, 0) AS chargeback_count,
    COALESCE(N2.chargeback_amount, 0) AS chargeback_amount
FROM Months M
LEFT JOIN NewTransactions N1 ON M.month = N1.month AND
                                M.country = N1.country
LEFT JOIN NewChargebacks N2 ON M.month = N2.month AND
                               M.country = N2.country
WHERE COALESCE(N1.approved_count, 0) != 0 OR
      COALESCE(N1.approved_amount, 0) != 0 OR
      COALESCE(N2.chargeback_count, 0) != 0 OR
      COALESCE(N2.chargeback_amount, 0) != 0
ORDER BY
    M.month,
    M.country;
