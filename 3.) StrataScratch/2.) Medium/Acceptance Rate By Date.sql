/* What is the overall friend acceptance rate by date?
   Your output should have the rate of acceptances by the date the request was sent. 
   Order by the earliest date to latest.

   Assume that each friend request starts by a user sending (i.e., user_id_sender) 
   a friend request to another user (i.e., user_id_receiver) that's logged in the table with action = 'sent'. 
   If the request is accepted, the table logs action = 'accepted'. If the request is not accepted, no record of action = 'accepted' is logged. */

WITH accepted_requests AS
(
    SELECT
        f1.date,
        COUNT(*) AS num_friend_requests
    FROM fb_friend_requests f1
    INNER JOIN fb_friend_requests f2 ON f1.user_id_sender = f2.user_id_sender AND
                                        f1.user_id_receiver = f2.user_id_receiver
    WHERE f1.action = 'sent' AND
          f2.action = 'accepted'
    GROUP BY f1.date
),
sent_requests AS
(
    SELECT
        date,
        COUNT(*) AS num_friend_requests
    FROM fb_friend_requests
    WHERE action = 'sent'
    GROUP BY date
)
SELECT
    a.date,
    a.num_friend_requests/s.num_friend_requests AS friend_acceptance_rate
FROM accepted_requests a
INNER JOIN sent_requests s ON a.date = s.date;
