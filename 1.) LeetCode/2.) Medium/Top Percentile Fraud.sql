/* The Leetcode Insurance Corp has developed an ML-driven predictive model to detect the likelihood of fraudulent claims.
   Consequently, they allocate their most seasoned claim adjusters to address the top 5% of claims flagged by this model.

   Write a solution to find the top 5 percentile of claims from each state.

   Return the result table ordered by state in ascending order, fraud_score in descending order, and policy_id in ascending order. */

WITH Percentiles AS
(
    SELECT
        policy_id,
        state,
        fraud_score,
        ROUND(PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY fraud_score DESC) OVER(PARTITION BY state), 3) AS fifth_percentile
    FROM Fraud
)
SELECT
    policy_id,
    state,
    fraud_score
FROM Percentiles
WHERE fraud_score >= fifth_percentile
ORDER BY
    state,
    fraud_score DESC,
    policy_id;
