-- Write a solution to report all the projects that have the most employees.

WITH NumberOfEmployees AS
(
    SELECT
        project_id,
        COUNT(*) AS num_employees,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS rank_num
    FROM Project
    GROUP BY project_id
)
SELECT project_id
FROM NumberOfEmployees
WHERE rank_num = 1;
