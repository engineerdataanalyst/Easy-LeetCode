/* The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages.
   The confirmation rate of a user that did not request any confirmation messages is 0. 
   Round the confirmation rate to two decimal places.

   Write an SQL query to find the confirmation rate of each user. */

WITH NumberOfMessages AS
(
    SELECT
        S.user_id,
        COUNT(C.action) AS num_messages
    FROM Signups S
    LEFT JOIN Confirmations C ON S.user_id = C.user_id
    GROUP BY S.user_id
    ORDER By S.user_id
)
SELECT
    S.user_id,
    COALESCE(ROUND(COUNT(CASE WHEN C.action = 'confirmed' THEN C.action ELSE NULL END)/
                  (SELECT num_messages
                   FROM NumberOfMessages N
                   WHERE N.user_id = C.user_id), 2), 0) AS confirmation_rate
FROM Signups S
LEFT JOIN Confirmations C ON S.user_id = C.user_id
GROUP BY S.user_id
ORDER BY S.user_id;
