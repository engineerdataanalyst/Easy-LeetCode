/* Write a query that returns every employee that has ever worked for the company.
   For each employee, calculate the greatest number of employees that worked for the company during their tenure and the first date that number was reached. 
   The termination date of an employee should not be counted as a working day.

   Your output should have the employee ID, greatest number of employees that worked for the company during the employee's tenure, and first date that number was reached. */

WITH employees AS
(
    SELECT
        u2.hire_date AS date,
        (SELECT COUNT(*)
         FROM uber_employees u1
         WHERE (u1.hire_date <= u2.hire_date) AND
               (u1.termination_date > u2.hire_date OR
                u1.termination_date IS NULL)) AS num_employees
    FROM uber_employees u2
    GROUP BY u2.hire_date
),
max_employees AS
(
    SELECT
        u.id,
        u.hire_date,
        u.termination_date,
        (SELECT MAX(e.num_employees)
         FROM employees e
         WHERE (e.date BETWEEN u.hire_date AND u.termination_date AND
                e.date != u.termination_date AND
                u.termination_date IS NOT NULL) OR
               (e.date >= u.hire_date AND
                u.termination_date IS NULL)) AS max_num_employees
    FROM uber_employees u
),
ranks AS
(
    SELECT
        m.id,
        m.hire_date,
        m.termination_date,
        m.max_num_employees,
        e.date,
        RANK() OVER(PARTITION BY m.id ORDER BY e.date) AS rank_num
    FROM max_employees m
    INNER JOIN employees e ON m.max_num_employees = e.num_employees
    WHERE (e.date BETWEEN m.hire_date AND m.termination_date AND
           m.termination_date IS NOT NULL) OR
          (e.date >= m.hire_date AND
           m.termination_date IS NULL)
)
SELECT
    id,
    max_num_employees,
    date
FROM ranks
WHERE rank_num = 1;
