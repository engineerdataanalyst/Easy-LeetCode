SELECT
    CustomerID,
    COUNT(ProductID) AS num_products,
    SUM(NumberofUsers) AS total_users,
    CASE
        WHEN SUM(NumberofUsers) >= 5000 OR COUNT(ProductID) = 1 THEN 1
        ELSE 0
    END AS upsell_opportunity
FROM Subscriptions
GROUP BY CustomerID;
