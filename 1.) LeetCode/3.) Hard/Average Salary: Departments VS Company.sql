/* Write an SQL query to report the comparison result (higher/lower/same) 
   of the average salary of employees in a department to the company's average salary. */

WITH Averages AS
(
    SELECT
        CONCAT(YEAR(S.pay_date), '-', 
               CASE WHEN MONTH(S.pay_date) < 10 THEN '0' ELSE '' END, MONTH(S.pay_date)) AS pay_month,
        E.department_id,
        S.amount,
        AVG(S.amount) OVER(PARTITION BY MONTH(S.pay_date)) AS average_company_salary,
        AVG(S.amount) OVER(PARTITION BY MONTH(S.pay_date), E.department_id) AS average_department_salary
    FROM Salary S
    LEFT JOIN Employee E ON S.employee_id = E.employee_id
)
SELECT DISTINCT
    pay_month,
    department_id,
    CASE
        WHEN average_department_salary > average_company_salary THEN 'higher'
        WHEN average_department_salary < average_company_salary THEN 'lower'
        ELSE 'same'
    END AS comparison
FROM Averages
ORDER BY
    department_id,
    pay_month
