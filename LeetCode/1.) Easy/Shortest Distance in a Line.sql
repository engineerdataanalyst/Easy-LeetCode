-- Write an SQL query to report the shortest distance between any two points from the Point table.

SELECT MIN(ABS(P1.x-P2.x)) AS shortest
FROM Point P1
CROSS JOIN Point P2
WHERE P1.x != P2.x;
