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
