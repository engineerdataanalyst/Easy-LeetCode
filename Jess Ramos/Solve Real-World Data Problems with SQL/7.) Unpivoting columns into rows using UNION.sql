WITH all_cancelation_reasons AS
(
    SELECT
        subscriptionid,
        CancelationReason1 AS cancelationreason
    FROM Cancelations

    UNION

    SELECT
        subscriptionid,
        CancelationReason2 AS cancelationreason
    FROM Cancelations

    UNION

    SELECT
        subscriptionid,
        CancelationReason3 AS cancelationreason
    FROM Cancelations
)
SELECT 
    CAST(COUNT(CASE
                   WHEN cancelationreason = 'Expensive' THEN subscriptionid
               END) AS FLOAT)
    /COUNT(DISTINCT subscriptionid) AS percent_expensive
FROM all_cancelation_reasons;
