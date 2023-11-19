WITH all_subscriptions AS
(
    SELECT expirationdate
    FROM SubscriptionsProduct1
    WHERE active = 1

    UNION

    SELECT expirationdate
    FROM SubscriptionsProduct2
    WHERE active = 1
)
SELECT
    date_trunc('year', expirationdate) AS exp_year, 
    COUNT(*) AS subscriptions
FROM all_subscriptions
GROUP BY date_trunc('year', expirationdate);
