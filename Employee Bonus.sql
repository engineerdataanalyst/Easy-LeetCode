SELECT name, bonus
FROM Employee
LEFT JOIN Bonus ON Employee.empId = Bonus.empID
WHERE bonus < 1000 OR bonus IS NULL;
