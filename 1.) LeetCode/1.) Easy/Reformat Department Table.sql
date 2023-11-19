WITH RECURSIVE MonthNames AS
(
    SELECT
        1 AS month_number,
        DATE_FORMAT(CONCAT('2023-01-01'), '%b') AS month_name
    
    UNION

    SELECT
        month_number+1 AS month_number,
        DATE_FORMAT(CONCAT('2023-', month_number+1, '-01'), '%b') AS month_name
    FROM MonthNames
    WHERE month_number < 12
)
SELECT
    D.id,
    SUM(CASE WHEN M.month_name = 'Jan' THEN D.revenue ELSE NULL END) AS Jan_Revenue,
    SUM(CASE WHEN M.month_name = 'Feb' THEN D.revenue ELSE NULL END) AS Feb_Revenue,
    SUM(CASE WHEN M.month_name = 'Mar' THEN D.revenue ELSE NULL END) AS Mar_Revenue,
    SUM(CASE WHEN M.month_name = 'Apr' THEN D.revenue ELSE NULL END) AS Apr_Revenue,
    SUM(CASE WHEN M.month_name = 'May' THEN D.revenue ELSE NULL END) AS May_Revenue,
    SUM(CASE WHEN M.month_name = 'Jun' THEN D.revenue ELSE NULL END) AS Jun_Revenue,
    SUM(CASE WHEN M.month_name = 'Jul' THEN D.revenue ELSE NULL END) AS Jul_Revenue,
    SUM(CASE WHEN M.month_name = 'Aug' THEN D.revenue ELSE NULL END) AS Aug_Revenue,
    SUM(CASE WHEN M.month_name = 'Sep' THEN D.revenue ELSE NULL END) AS Sep_Revenue,
    SUM(CASE WHEN M.month_name = 'Oct' THEN D.revenue ELSE NULL END) AS Oct_Revenue,
    SUM(CASE WHEN M.month_name = 'Nov' THEN D.revenue ELSE NULL END) AS Nov_Revenue,
    SUM(CASE WHEN M.month_name = 'Dec' THEN D.revenue ELSE NULL END) AS Dec_Revenue
FROM MonthNames M
LEFT JOIN Department D ON M.month_name = D.month
WHERE D.id IS NOT NULL
GROUP BY D.id
ORDER BY D.id;
