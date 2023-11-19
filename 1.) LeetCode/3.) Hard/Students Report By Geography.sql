/* A school has students from Asia, Europe, and America.

   Write an SQL query to pivot the continent column in the Student table so that each name is sorted alphabetically and displayed underneath its corresponding continent.
   The output headers should be America, Asia, and Europe, respectively.

   The test cases are generated so that the student number from America is not less than either Asia or Europe. */

WITH America AS
(
    SELECT
        ROW_NUMBER() OVER() AS row_num,
        name
    FROM Student
    WHERE continent = 'America'
    ORDER BY name
),
Asia AS
(
    SELECT
        ROW_NUMBER() OVER() AS row_num,
        name
    FROM Student
    WHERE continent = 'Asia'
    ORDER BY name
),
Europe AS
(
    SELECT
        ROW_NUMBER() OVER() AS row_num,
        name
    FROM Student
    WHERE continent = 'Europe'
    ORDER BY name
)
SELECT
    A1.name AS America,
    A2.name AS Asia,
    E.name AS Europe
FROM America A1
LEFT JOIN Asia A2 ON A1.row_num = A2.row_num
LEFT JOIN Europe E ON A1.row_num = E.row_num;
