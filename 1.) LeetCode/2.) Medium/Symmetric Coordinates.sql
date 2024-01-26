/* Two coordindates (X1, Y1) and (X2, Y2) are said to be symmetric coordintes if X1 == Y2 and X2 == Y1.
   Write a solution that outputs, among all these symmetric coordintes, only those unique coordinates that satisfy the condition X1 <= Y1.
   Return the result table ordered by X and Y (respectively) in ascending order. */

WITH NewCoordinates AS
(
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY X, Y) AS row_num,
        COUNT(*) OVER(PARTITION BY X, Y) AS num_coordinates
    FROM Coordinates
)
SELECT DISTINCT
    N1.X,
    N1.Y
FROM NewCoordinates N1
CROSS JOIN NewCoordinates N2 ON N1.X = N2.Y AND
                                N1.Y = N2.X
WHERE N1.X <= N1.Y AND
      N1.row_num <= N2.row_num AND
     (N1.num_coordinates != 1 OR
      N1.X != N1.Y)
ORDER BY
    N1.X,
    N1.Y;
