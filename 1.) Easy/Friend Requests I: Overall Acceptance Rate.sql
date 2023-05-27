/* Write an SQL query to find the overall acceptance rate of requests, which is the number of acceptance divided by the number of requests. 
   Return the answer rounded to 2 decimals places.

   Note that:

   The accepted requests are not necessarily from the table friend_request. 
   In this case, Count the total accepted requests (no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate.

   It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once.
   In this case, the ‘duplicated’ requests or acceptances are only counted once.

   If there are no requests at all, you should return 0.00 as the accept_rate. */

WITH NumberOfRequestAccepted (num_request_accepted) AS
(
    SELECT COUNT(*)
    FROM
    (
        SELECT
            requester_id,
            accepter_id
        FROM RequestAccepted
        GROUP BY
            requester_id,
            accepter_id
    ) R
),
NumberOfFriendRequest (num_friend_request) AS
(
    SELECT COUNT(*)
    FROM
    (
        SELECT
            sender_id,
            send_to_id
        FROM FriendRequest
        GROUP BY
            sender_id,
            send_to_id
    ) F
)
SELECT COALESCE(ROUND(num_request_accepted/num_friend_request, 2), 0) as accept_rate
FROM NumberOfRequestAccepted, NumberOfFriendRequest;
