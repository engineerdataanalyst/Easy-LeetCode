/* A company wants to hire new employees. The budget of the company for the salaries is $70000. 
   The company's criteria for hiring are:

   Keep hiring the senior with the smallest salary until you cannot hire any more seniors.
   Use the remaining budget to hire the junior with the smallest salary.
   Keep hiring the junior with the smallest salary until you cannot hire any more juniors.

   Write an SQL query to find the ids of seniors and juniors hired under the mentioned criteria. */

WITH NewCandidates AS
(
    SELECT
        *,
        SUM(salary) OVER(PARTITION BY experience ORDER BY salary) AS salary_sum
    FROM Candidates
),
HiredSeniors AS
(
    SELECT
        *,
        70000-salary_sum AS salary_difference
    FROM NewCandidates
    WHERE experience = 'Senior' AND
          salary_sum < 70000
),
MinSalaryDifference AS
(
    SELECT CASE
               WHEN COUNT(*) = 0 THEN 70000
               ELSE MIN(salary_difference)
           END AS min_salary_difference
    FROM HiredSeniors
),
HiredJuniors AS
(
    SELECT
        *,
        (SELECT * FROM MinSalaryDifference)-salary_sum AS salary_difference
    FROM NewCandidates
    WHERE experience = 'Junior' AND
          salary_sum < (SELECT * FROM MinSalaryDifference)
)
SELECT employee_id
FROM HiredSeniors

UNION

SELECT employee_id
FROM HiredJuniors
ORDER BY employee_id;
