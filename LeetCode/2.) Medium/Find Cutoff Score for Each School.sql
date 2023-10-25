/* Every year, each school announces a minimum score requirement that a student needs to apply to it.
   The school chooses the minimum score requirement based on the exam results of all the students:

   They want to ensure that even if every student meeting the requirement applies, the school can accept everyone.
   They also want to maximize the possible number of students that can apply.
   They must use a score that is in the Exam table.
    
   Write a solution to report the minimum score requirement for each school.
   If there are multiple score values satisfying the above conditions, choose the smallest one. 
   If the input data is not enough to determine the score, report -1. */

WITH CapacityDifference AS
(
    SELECT
        S.school_id,
        E.score,
        S.capacity,
        E.student_count,
        CASE
            WHEN S.capacity >= E.student_count THEN S.capacity-E.student_count
            ELSE NULL
        END AS capacity_difference
    FROM Exam E
    CROSS JOIN Schools S
),
CapacityRank AS
(
    SELECT DISTINCT
        school_id,
        score,
        capacity,
        student_count,
        capacity_difference,
        DENSE_RANK() OVER(PARTITION BY school_id ORDER BY capacity_difference) AS capacity_rank
    FROM CapacityDifference
    WHERE capacity_difference IS NOT NULL
)
SELECT
    S.school_id,
    MIN(COALESCE(C.score, -1)) AS score
FROM Schools S
LEFT JOIN CapacityRank C ON S.school_id = C.school_id
WHERE COALESCE(capacity_rank, 1) = 1
GROUP BY S.school_id
ORDER BY S.school_id;
