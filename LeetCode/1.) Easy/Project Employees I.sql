/* Write an SQL query that reports 
   the average experience years of all the employees
   for each project, rounded to 2 digits. */

SELECT
    P.project_id,
    ROUND(AVG(E.experience_years), 2) AS average_years
FROM Project P
LEFT JOIN Employee E ON P.employee_id = E.employee_id
GROUP BY P.project_id;
