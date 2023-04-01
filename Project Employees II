/* Write an SQL query that reports all
   the projects that have the most employees.
   Return the result table in any order. */

SELECT project_id
FROM Project
GROUP BY project_id
HAVING COUNT(employee_id) = 
    (SELECT MAX(num_rows)
     FROM
        (SELECT COUNT(*) AS num_rows
         FROM Project
         GROUP BY project_id) t);
