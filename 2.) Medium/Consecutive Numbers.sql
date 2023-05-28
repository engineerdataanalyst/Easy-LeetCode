-- Write an SQL query to find all numbers that appear at least three times consecutively.

WITH LeadId1 AS
(
    SELECT
        id,
        num,
        LEAD(id) OVER(PARTITION BY num ORDER BY id) AS lead_id1
    FROM Logs
),
LeadId2 AS
(
    SELECT
        id,
        num,
        lead_id1,
        LEAD(lead_id1) OVER(PARTITION BY num ORDER BY id) AS lead_id2
    FROM LeadId1
),
NewLogs AS
(
    SELECT
        id,
        num,
        lead_id1,
        lead_id2,
        lead_id2-id AS id_difference
    FROM LeadId2
)
SELECT num AS ConsecutiveNums
FROM NewLogs
WHERE id_difference = 2
GROUP BY num;
