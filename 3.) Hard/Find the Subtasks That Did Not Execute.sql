-- Write an SQL query to report the IDs of the missing subtasks for each task_id.

WITH RECURSIVE Subtasks(subtask_id) AS
(
    SELECT 1
    
    UNION

    SELECT subtask_id+1
    FROM Subtasks
    WHERE subtask_id < (SELECT MAX(subtasks_count) FROM Tasks)
),
NewExecuted AS
(
    SELECT
        T1.task_id,
        S.subtask_id
    FROM Tasks T1
    CROSS JOIN Subtasks S
    WHERE S.subtask_id <= ALL (SELECT T2.subtasks_count
                               FROM Tasks T2
                               WHERE T1.task_id = T2.task_id)
    ORDER BY
        task_id,
        subtask_id
)
SELECT
    N.task_id,
    N.subtask_id
FROM NewExecuted N
LEFT JOIN Executed E ON N.task_id = E.task_id AND
                        N.subtask_id = E.subtask_id
WHERE E.task_id IS NULL
ORDER BY
    task_id,
    subtask_id;
