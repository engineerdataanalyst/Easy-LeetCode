/* Write a solution to find the employees who are allocated to projects with a workload 
   that exceeds the average workload of all employees for their respective teams

   Return the result table ordered by employee_id, project_id in ascending order. */

WITH Workloads AS
(
    SELECT
        E.employee_id,
        P.project_id,
        E.name AS employee_name,
        P.workload AS project_workload,
        AVG(P.workload) OVER(PARTITION BY E.team) AS average_team_workload
    FROM Employees E
    LEFT JOIN Project P ON E.employee_id = P.employee_id
)
SELECT
    employee_id,
    project_id,
    employee_name,
    project_workload
FROM Workloads
WHERE project_workload > average_team_workload
ORDER BY
    employee_id,
    project_id;
