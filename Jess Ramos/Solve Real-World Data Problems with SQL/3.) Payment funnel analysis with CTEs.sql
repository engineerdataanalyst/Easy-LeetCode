WITH MaxStatus AS
(
    SELECT
  	SubscriptionID,
  	MAX(StatusID) AS maxstatus
    FROM PaymentStatusLog
    GROUP BY SubscriptionID
)
SELECT
    CASE 
        WHEN M.maxstatus = 1 THEN 'PaymentWidgetOpened'
	WHEN M.maxstatus = 2 THEN 'PaymentEntered'
	WHEN M.maxstatus = 3 AND currentstatus = 0 THEN 'User Error with Payment Submission'
	WHEN M.maxstatus = 3 AND currentstatus != 0 THEN 'Payment Submitted'
	WHEN M.maxstatus = 4 AND currentstatus = 0 THEN 'Payment Processing Error with Vendor'
	WHEN M.maxstatus = 4 AND currentstatus != 0 THEN 'Payment Success'
	WHEN M.maxstatus = 5 THEN 'Complete'
	WHEN M.maxstatus IS NULL THEN 'User did not start payment process'
    END AS paymentfunnelstage,
    COUNT(*) AS subscriptions
FROM Subscriptions S
LEFT JOIN MaxStatus M ON M.SubscriptionID = S.subscriptionID
GROUP BY paymentfunnelstage;
