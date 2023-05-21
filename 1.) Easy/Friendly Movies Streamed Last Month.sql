-- Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.

SELECT DISTINCT C.title
FROM Content C
LEFT JOIN TVProgram T ON C.content_id = T.content_id
WHERE C.Kids_content = 'Y' AND
      C.content_type = 'Movies' AND
      MONTH(program_date) = 6 AND 
      YEAR(program_date) = 2020;
