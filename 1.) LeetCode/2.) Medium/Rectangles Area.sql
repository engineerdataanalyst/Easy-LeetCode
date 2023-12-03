/* Write a solution to report all possible axis-aligned rectangles with a non-zero area that can be formed by any two points from the Points table.

   Each row in the result should contain three columns (p1, p2, area) where:

   p1 and p2 are the id's of the two points that determine the opposite corners of a rectangle.
   area is the area of the rectangle and must be non-zero.

   Return the result table ordered by area in descending order.
   If there is a tie, order them by p1 in ascending order.
   If there is still a tie, order them by p2 in ascending order. */

SELECT
    P1.id AS p1,
    P2.id AS p2,
    ABS(P1.x_value-P2.x_value)*ABS(P1.y_value-P2.y_value) AS area
FROM Points P1
CROSS JOIN Points P2 ON P1.id < P2.id AND
                        ABS(P1.x_value-P2.x_value)*ABS(P1.y_value-P2.y_value) != 0
ORDER BY
    area DESC,
    p1,
    p2;
