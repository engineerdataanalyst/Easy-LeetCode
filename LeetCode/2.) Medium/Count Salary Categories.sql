/* Write an SQL query to report the number of bank accounts of each salary category.
   The salary categories are:

   "Low Salary": All the salaries strictly less than $20000.
   "Average Salary": All the salaries in the inclusive range [$20000, $50000].
   "High Salary": All the salaries strictly greater than $50000.
   
   The result table must contain all three categories.
   If there are no accounts in a category, then report 0. */

WITH AccountCategory AS
(
    SELECT 'Low Salary' AS category
    UNION
    SELECT 'Average Salary' AS category
    UNION
    SELECT 'High Salary' AS category
),
NewAccounts AS
(
    SELECT
        account_id,
        income,
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income >= 20000 AND income <= 50000 THEN 'Average Salary'
            WHEN income > 50000 THEN 'High Salary'
        END AS category
    FROM Accounts
)
SELECT 
    A.category,
    COUNT(N.account_id) AS accounts_count
FROM AccountCategory A
LEFT JOIN NewAccounts N ON A.category = N.category
GROUP BY A.category
ORDER BY accounts_count DESC;
