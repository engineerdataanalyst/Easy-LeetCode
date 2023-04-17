/* Write an SQL query to convert each date in Days 
   into a string formatted as "day_name, month_name day, year". */

SELECT CONCAT(DAYNAME(day), ", ", MONTHNAME(day), " ", DAY(day), ", ", YEAR(day)) AS day
FROM Days;
