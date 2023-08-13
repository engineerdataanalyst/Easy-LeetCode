WITH RECURSIVE IncomeSums AS
(
    SELECT
        account_id,
        COALESCE(LAG(account_id) OVER(), account_id) AS lag_account_id,
        month,
        COALESCE(LAG(month) OVER(PARTITION BY account_id ORDER BY month), month) AS lag_month,
        total_amount,
        max_income,
        total_exceeds_max,
        COALESCE(LAG(total_exceeds_max) OVER(PARTITION BY account_id ORDER BY month), total_exceeds_max) AS lag_total_exceeds_max,
        ROW_NUMBER() OVER() AS row_num
    FROM
    (
        SELECT
            T.account_id,
            MONTH(T.day) AS month,
            SUM(T.amount) AS total_amount,
            A.max_income,
            SUM(T.amount) > A.max_income AS total_exceeds_max
        FROM Transactions T
        LEFT JOIN Accounts A ON T.account_id = A.account_id
        WHERE T.type = 'Creditor'
        GROUP BY
            T.account_id,
            month
        ORDER BY
            T.account_id,
            month
    ) I
),
MonthGroups AS
(
    SELECT
        I.account_id,
        I.lag_account_id,
        I.month,
        I.lag_month,
        I.total_amount,
        I.max_income,
        I.total_exceeds_max,
        I.lag_total_exceeds_max,
        I.row_num,
        1 AS group_num
    FROM IncomeSums I
    WHERE I.row_num = 1
    
    UNION
    
    SELECT
        I.account_id,
        I.lag_account_id,
        I.month,
        I.lag_month,
        I.total_amount,
        I.max_income,
        I.total_exceeds_max,
        I.lag_total_exceeds_max,
        I.row_num,
        CASE
            WHEN I.account_id = I.lag_account_id AND
                 I.month-I.lag_month IN (0, 1) AND
                 I.total_exceeds_max = 1 AND
                 I.lag_total_exceeds_max = 1 THEN M.group_num
            ELSE M.group_num+1
        END AS group_num
    FROM
        MonthGroups M,
        IncomeSums I
    WHERE I.row_num = M.row_num+1 AND
          I.row_num <= (SELECT COUNT(*) FROM IncomeSums)
)
SELECT DISTINCT account_id
FROM MonthGroups
GROUP BY group_num
HAVING COUNT(*) >= 2;
