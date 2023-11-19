/* A company wants to hire new employees. 
   The budget of the company for the salaries is $70000. 
   The company's criteria for hiring are:

   Hiring the largest number of seniors.
   After hiring the maximum number of seniors, use the remaining budget to hire the largest number of juniors.

   Write an SQL query to find the number of seniors and juniors hired under the mentioned criteria. */

WITH SalarySums AS
(
    SELECT
        employee_id,
        experience,
        SUM(salary) OVER(PARTITION BY experience ORDER BY salary) AS salary_sum
    FROM Candidates
),
SeniorsToHire AS
(
    SELECT *
    FROM SalarySums
    WHERE experience = 'Senior' AND
          salary_sum <= 70000
),
JuniorsToHire AS
(
    SELECT *
    FROM SalarySums
    WHERE experience = 'Junior' AND 
          salary_sum <= 70000-COALESCE((SELECT MAX(salary_sum) FROM SeniorsToHire), 0)
)
SELECT
    COALESCE(experience, 'Senior') AS experience,
    COUNT(*) AS accepted_candidates
FROM SeniorsToHire

UNION

SELECT
    COALESCE(experience, 'Junior') AS experience,
    COUNT(*) AS accepted_candidates
FROM JuniorsToHire;
