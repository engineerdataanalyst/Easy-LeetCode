/* Write an SQL query that reports the rank of each student in their department as a percentage, 
   where the rank as a percentage is computed using the following formula: 
  (student_rank_in_the_department - 1) * 100 / (the_number_of_students_in_the_department - 1).
   The percentage should be rounded to 2 decimal places. 

   Student_rank_in_the_department is determined by descending mark, such that the student with the highest mark is rank 1. 
   If two students get the same mark, they also get the same rank. */

WITH StudentRanks AS
(
    SELECT
        student_id,
        department_id,
        mark,
        RANK() OVER(PARTITION BY department_id ORDER BY mark DESC) AS rank_num
    FROM Students
),
NumberOfStudents AS
(
    SELECT
        student_id,
        department_id,
        mark,
        COUNT(*) OVER(PARTITION BY department_id) AS num_students
    FROM Students
)
SELECT
    S.student_id,
    S.department_id,
    COALESCE(ROUND((S.rank_num-1)*100/(N.num_students-1), 2), 0) AS percentage
FROM StudentRanks S
LEFT JOIN NumberOfStudents N ON S.student_id = N.student_id;
