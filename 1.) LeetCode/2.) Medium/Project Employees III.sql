/* Write an SQL query that reports the most experienced employees in each project. 
   In case of a tie, report all employees with the maximum number of experience years. */

SELECT
    P1.project_id,
    E1.employee_id
FROM Project P1
LEFT JOIN Employee E1 ON P1.employee_id = E1.employee_id
WHERE (P1.project_id, E1.experience_years) IN
    (SELECT
         P2.project_id,
         MAX(E2.experience_years)
     FROM Project P2
     LEFT JOIN Employee E2 ON P2.employee_id = E2.employee_id
     GROUP BY P2.project_id);
