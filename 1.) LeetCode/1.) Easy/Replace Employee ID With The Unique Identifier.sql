/* Write an SQL query to show the unique ID of each user.
   If a user does not have a unique ID replace just show null. */

SELECT
    E2.unique_id,
    E1.name
FROM Employees E1
LEFT JOIN EmployeeUNI E2 ON E1.id = E2.id;
