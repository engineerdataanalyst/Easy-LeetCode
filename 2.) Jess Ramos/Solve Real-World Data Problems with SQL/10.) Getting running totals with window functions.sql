WITH CTE AS
(
    SELECT
        S.SalesEmployeeID,
        S.SaleDate,
        S.SaleAmount,
        SUM(S.SaleAmount) OVER(PARTITION BY S.SalesEmployeeID ORDER BY S.SaleDate) AS running_total,
        E.Quota 
    FROM Sales S
    LEFT JOIN Employees E ON S.SalesEmployeeID = E.EmployeeID
    ORDER BY S.SalesEmployeeID
)
SELECT
    SalesEmployeeId,
    SaleDate,
    SaleAmount,
    running_total,
    CAST(running_total AS FLOAT)/Quota AS percent_quota
FROM CTE;
