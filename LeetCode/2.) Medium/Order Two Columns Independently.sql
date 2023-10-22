/* Write an SQL query to independently:
   order first_col in ascending order.
   order second_col in descending order. */

WITH FirstCol AS
(
    SELECT
        ROW_NUMBER() OVER(ORDER BY first_col) AS row_num,
        first_col
    FROM Data
),
SecondCol AS
(
    SELECT
        ROW_NUMBER() OVER(ORDER BY second_col DESC) AS row_num,
        second_col
    FROM Data
)
SELECT
    F.first_col,
    S.second_col
FROM FirstCol F
LEFT JOIN SecondCol S ON F.row_num = S.row_num;
