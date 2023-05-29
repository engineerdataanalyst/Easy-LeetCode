-- Write an SQL query to evaluate the boolean expressions in Expressions table.

WITH NewExpressions AS
(
    SELECT
        V1.name AS left_operand,
        E.operator,
        V2.name AS right_operand,
        CASE
            WHEN E.operator = '>' THEN V1.value > V2.value
            WHEN E.operator = '=' THEN V1.value = V2.value
            WHEN E.operator = '<' THEN V1.value < V2.value
        END AS value
    FROM Expressions E
    LEFT JOIN Variables V1 ON E.left_operand = V1.name
    LEFT JOIN Variables V2 ON E.right_operand = V2.name
)
SELECT
    left_operand,
    operator,
    right_operand,
    CASE
        WHEN value = 1 THEN 'true'
        ELSE 'false'
    END AS value
FROM NewExpressions;
