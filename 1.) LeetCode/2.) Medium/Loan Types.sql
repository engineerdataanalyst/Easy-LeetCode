/* Write a solution to find all distinct user_id's that have at least one Refinance loan type and at least one Mortgage loan type.
   Return the result table ordered by user_id in ascending order. */

SELECT user_id
FROM Loans
GROUP BY user_id
HAVING POSITION('Refinance' IN GROUP_CONCAT(loan_type)) != 0 AND
       POSITION('Mortgage' IN GROUP_CONCAT(loan_type)) != 0
ORDER BY user_id;
