/* Write an SQL query to report each person's name followed by the first letter of their profession enclosed in parentheses.

   Return the result table ordered by person_id in descending order. */

SELECT
    person_id,
    CONCAT(name, '(', LEFT(profession, 1), ')') AS name
FROM Person
ORDER BY person_id DESC;
