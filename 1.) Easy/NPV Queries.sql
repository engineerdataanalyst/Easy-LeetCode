-- Write an SQL query to find the npv of each query of the Queries table.

SELECT
    Q.id,
    Q.year,
    COALESCE(N.npv, 0) AS npv
FROM Queries Q
LEFT JOIN NPV N ON Q.id = N.id AND Q.year = N.year
GROUP BY
    Q.id,
    Q.year;
