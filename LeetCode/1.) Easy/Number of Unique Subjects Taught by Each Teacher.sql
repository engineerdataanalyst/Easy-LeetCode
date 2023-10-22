-- Write an SQL query to report the number of unique subjects each teacher teaches in the university.

SELECT
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;
