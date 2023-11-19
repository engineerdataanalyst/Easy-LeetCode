/* Write an SQL query to reports for every date within at most 90 days from today,
   the number of users that logged in for the first time on that date. 
   Assume today is 2019-06-30. */

WITH T AS
(
    SELECT MIN(activity_date) AS login_date
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id
    HAVING login_date BETWEEN DATE_ADD('2019-06-30', INTERVAL -90 DAY) AND '2019-06-30'
)
SELECT
    login_date,
    COUNT(login_date) AS user_count
FROM T
GROUP BY login_date;
