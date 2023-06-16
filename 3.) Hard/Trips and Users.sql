/* The cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by the total number of requests with unbanned users on that day.

   Write a SQL query to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03".
   Round Cancellation Rate to two decimal points. */

SELECT
    T.request_at AS Day,
    ROUND(COUNT(CASE
                    WHEN T.status IN('cancelled_by_client', 'cancelled_by_driver') THEN T.status
                    ELSE NULL
                END)/COUNT(*), 2) AS 'Cancellation Rate'
FROM Trips T
LEFT JOIN Users U1 ON T.client_id = U1.users_id
LEFT JOIN Users U2 ON T.driver_id = U2.users_id
WHERE T.request_at BETWEEN '2013-10-01' AND '2013-10-03' AND
      U1.banned = 'No' AND
      U2.banned = 'No'
GROUP BY T.request_at
ORDER BY T.request_at;
