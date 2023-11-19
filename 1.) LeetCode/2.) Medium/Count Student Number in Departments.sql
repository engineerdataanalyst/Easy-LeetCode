/* Write an SQL query to report the respective department name
   and number of students majoring in each department 
   for all departments in the Department table (even ones with no current students).

   Return the result table ordered by student_number in descending order. 
   In case of a tie, order them by dept_name alphabetically. */

SELECT
    D.dept_name,
    COUNT(S.student_id) AS student_number
FROM Department D
LEFT JOIN Student S ON D.dept_id = S.dept_id
GROUP BY D.dept_name
ORDER BY
    student_number DESC,
    D.dept_name
