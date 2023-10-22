/* Write an SQL query to find the number of times each student attended each exam.
   Return the result table ordered by student_id and subject_name. */

SELECT
    S1.student_id,
    S1.student_name,
    S2.subject_name,
    COUNT(E.subject_name) AS attended_exams
FROM Students S1
CROSS JOIN Subjects S2
LEFT JOIN Examinations E ON S1.student_id = E.student_id AND
                            S2.subject_name = E.subject_name
GROUP BY
    S1.student_id,
    S2.subject_name
ORDER BY
    S1.student_id,
    S2.subject_name;
