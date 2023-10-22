-- Write an SQL query to report for every three line segments whether they can form a triangle.

SELECT
    x,
    y,
    z,
    CASE
        WHEN abs(x)+abs(y) > abs(z) AND
             abs(y)+abs(z) > abs(x) AND
             abs(z)+abs(x) > abs(y) THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle;
