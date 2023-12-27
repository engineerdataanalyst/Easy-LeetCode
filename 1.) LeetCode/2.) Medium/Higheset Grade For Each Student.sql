/* Write a solution to find the highest grade with its corresponding course for each student.
   In case of a tie, you should find the course with the smallest course_id.

   Return the result table ordered by student_id in ascending order. */

WITH MaxGrades AS
(
    SELECT
        student_id,
        course_id,
        grade,
        DENSE_RANK() OVER(PARTITION BY student_id ORDER BY grade DESC, course_id) AS rank_num
    FROM Enrollments
)
SELECT
    student_id,
    course_id,
    grade
FROM MaxGrades
WHERE rank_num = 1
ORDER BY student_id;
