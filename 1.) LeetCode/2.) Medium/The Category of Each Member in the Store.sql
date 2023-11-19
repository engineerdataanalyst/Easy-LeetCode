/* A store wants to categorize its members. There are three tiers:

   "Diamond": if the conversion rate is greater than or equal to 80.
   "Gold": if the conversion rate is greater than or equal to 50 and less than 80.
   "Silver": if the conversion rate is less than 50.
   "Bronze": if the member never visited the store.
   The conversion rate of a member is (100 * total number of purchases for the member) / total number of visits for the member.

   Write an SQL query to report the id, the name, and the category of each member. */

WITH ConversionRates AS
(
    SELECT
        M.member_id,
        M.name,
        COUNT(P.charged_amount)/COUNT(V.visit_id)*100 AS conversion_rate
    FROM Members M
    LEFT JOIN Visits V ON M.member_id = V.member_id
    LEFT JOIN Purchases P ON V.visit_id = P.visit_id
    GROUP BY M.member_id
    ORDER BY M.member_id
)
SELECT
    member_id,
    name,
    CASE
        WHEN conversion_rate >= 80 THEN 'Diamond'
        WHEN conversion_rate >= 50 AND conversion_rate < 80 THEN 'Gold'
        WHEN conversion_rate < 50 THEN 'Silver'
        WHEN conversion_rate IS NULL THEN 'Bronze'
    END AS category
FROM ConversionRates;
