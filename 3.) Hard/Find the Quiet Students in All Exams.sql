/* A quiet student is the one who took at least one exam and did not score the high or the low score.

   Write an SQL query to report the students (student_id, student_name) being quiet in all exams.
   Do not return the student who has never taken any exam.

   Return the result table ordered by student_id. */

WITH NewExam AS
(
    SELECT
        E.exam_id,
        E.student_id,
        S.student_name,
        E.score,
        DENSE_RANK() OVER(PARTITION BY E.exam_id ORDER BY E.score DESC) AS high_score_rank,
        DENSE_RANK() OVER(PARTITION BY E.exam_id ORDER BY E.score) AS low_score_rank
    FROM Exam E
    LEFT JOIN Student S ON E.student_id = S.student_id
),
HighestLowestScores AS
(
    SELECT DISTINCT student_id
    FROM NewExam
    WHERE high_score_rank = 1 OR
          low_score_rank = 1
)
SELECT DISTINCT
    N.student_id,
    N.student_name
FROM NewExam N
LEFT JOIN HighestLowestScores H ON N.student_id = H.student_id
WHERE H.student_id IS NULL
ORDER BY N.student_id;
