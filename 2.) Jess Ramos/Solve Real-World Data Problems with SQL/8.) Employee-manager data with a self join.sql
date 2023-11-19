SELECT
    E.employeeid,
    E.name AS employee_name,
    M.name AS manager_name,
    COALESCE(M.email, E.email) AS contact_email
FROM Employees E
LEFT JOIN Employees M ON E.managerid = M.employeeid
WHERE E.department = 'Sales';
