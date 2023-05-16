/* In a company, each employee must work a certain number of hours every month. 
   Employees work in sessions. The number of hours an employee worked can be 
   calculated from the sum of the number of minutes the employee worked in all of their sessions. 
   The number of minutes in each session is rounded up.

   For example, if the employee worked for 51 minutes and 2 seconds in a session, we consider it 52 minutes.
   Write an SQL query to report the IDs of the employees that will be deducted. 
   In other words, report the IDs of the employees that did not work the needed hours. */

WITH NewLogs AS
(
    SELECT
        employee_id,
        DATE_ADD(in_time, INTERVAL IF(SECOND(in_time) != 0, 1, 0) MINUTE) AS in_time,
        DATE_ADD(out_time, INTERVAL IF(SECOND(out_time) != 0, 1, 0) MINUTE) AS out_time
    FROM Logs
),
MinuteDifference AS
(
    SELECT
        E.employee_id,
        N.in_time,
        N.out_time,
        COALESCE(E.needed_hours*60, 0) AS needed_minutes,
        COALESCE(TIMESTAMPDIFF(MINUTE, in_time, out_time), 0) AS minute_difference
    FROM Employees E
    LEFT JOIN NewLogs N ON E.employee_id = N.employee_id
),
DeductedEmployees AS
(
    SELECT
        employee_id,
        needed_minutes,
        COALESCE(minute_difference, 0) AS minute_difference,
        SUM(COALESCE(minute_difference, 0)) AS total_difference
    FROM MinuteDifference
    GROUP BY employee_id
    HAVING total_difference < needed_minutes
)
SELECT employee_id
FROM DeductedEmployees
