/* Write an SQL query to find the number of occurrences of the words 'bull' and 'bear' as a standalone word, (number of files)
   disregarding any instances where it appears as part of another word (e.g. 'bullet' and 'bears' will not be considered). */

SELECT
    'bull' AS word,
    SUM(CASE WHEN REGEXP_INSTR(content, ' bull ') != 0 THEN 1 ELSE 0 END) AS count
FROM Files

UNION

SELECT
    'bear' AS word,
    SUM(CASE WHEN REGEXP_INSTR(content, ' bear ') != 0 THEN 1 ELSE 0 END) AS count
FROM Files;
