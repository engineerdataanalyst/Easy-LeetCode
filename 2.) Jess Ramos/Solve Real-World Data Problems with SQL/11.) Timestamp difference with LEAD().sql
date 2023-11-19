WITH CTE AS
(
    SELECT
        StatusMovementID,
        SubscriptionID,
        StatusID,
        MovementDate,
        LEAD(MovementDate) OVER(ORDER BY MovementDate) AS NextStatusMovementDate,
    FROM PaymentStatusLog
    WHERE SubscriptionID = 38844
)
SELECT
    *,
    NextStatusMovementDate-MovementDate AS TimeInStatus
FROM CTE;
