/* A single number is a number that appeared only once in the MyNumbers table.
   Write an SQL query to report the largest single number. 
   If there is no single number, report null. */
   
WITH T AS
(
    SELECT 
        CASE 
            WHEN num/SUM(num) != 1 THEN NULL
            ELSE num
        END AS num
     FROM MyNumbers
     GROUP BY num
)
SELECT MAX(num) AS num
FROM T;
