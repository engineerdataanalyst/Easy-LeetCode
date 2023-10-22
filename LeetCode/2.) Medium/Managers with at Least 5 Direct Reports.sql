-- Write an SQL query to report the managers with at least five direct reports.

SELECT E1.name
FROM Employee E1
LEFT JOIN Employee E2 ON E1.id = E2.managerId
WHERE E2.managerId IS NOT NULL
GROUP BY E1.id
HAVING COUNT(E1.id) >= 5;
