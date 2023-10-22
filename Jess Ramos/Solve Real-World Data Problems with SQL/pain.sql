WITH MonthlyRevenue AS
(
    SELECT
        P.ProductName,
        MONTH(S.OrderDate) AS OrderMonth,
        SUM(S.Revenue) AS TotalRevenue
    FROM Subscriptions S
    LEFT JOIN Products P ON S.ProductID = P.ProductId
    WHERE YEAR(S.OrderDate) = 2022
    GROUP BY
        P.ProductName,
        OrderMonth
)
SELECT
    ProductName,
    MIN(TotalRevenue) AS MIN_REV,
    MAX(TotalRevenue) AS MAX_REV,
    AVG(TotalRevenue) AS AVG_REV,
    STDDEV(TotalRevenue) AS STD_DEV_REV
FROM MonthlyRevenue
GROUP BY ProductName
