-- Write an SQL query to find the total number of users and the total amount spent using the mobile only, the desktop only, and both mobile and desktop together for each date.

WITH RECURSIVE PlatformArray AS
(
    SELECT
        (SELECT MIN(spend_date) FROM Spending) AS spend_date,
        'desktop' AS platform,
        1 AS row_num

    UNION 

    SELECT
        (SELECT MIN(spend_date) FROM Spending) AS spend_date,
        'mobile' AS platform,
        1 AS row_num

    UNION

    SELECT
        (SELECT MIN(spend_date) FROM Spending) AS spend_date,
        'both' AS platform,
        1 AS row_num

    UNION

    SELECT
        S2.spend_date,
        P.platform,
        S2.row_num
    FROM
        PlatformArray P,
        (
            SELECT
                *,
                ROW_NUMBER() OVER() AS row_num
            FROM
            (
                SELECT DISTINCT spend_date
                FROM Spending
                ORDER BY spend_date
            ) S1
        ) S2
    WHERE S2.row_num = P.row_num+1 AND
          S2.row_num <= (SELECT COUNT(DISTINCT spend_date) FROM Spending)
),
GroupConcat AS
(
    SELECT
        user_id,
        spend_date,
        GROUP_CONCAT(platform ORDER BY platform) AS platform_list,
        SUM(amount) AS amount
    FROM Spending
    GROUP BY
        user_id,
        spend_date
),
Platforms AS
(
    SELECT
        user_id,
        spend_date,
        platform_list,
        CASE
            WHEN POSITION('desktop' IN platform_list) != 0 AND
                 POSITION('mobile' IN platform_list) = 0 THEN 'desktop'
            WHEN POSITION('desktop' IN platform_list) = 0 AND
                 POSITION('mobile' IN platform_list) != 0 THEN 'mobile'
            WHEN POSITION('desktop' IN platform_list) != 0 AND
                 POSITION('mobile' IN platform_list) != 0 THEN 'both'
        END AS platform,
        amount
    FROM GroupConcat
),
NewSpending AS
(
    SELECT
        P2.user_id,
        P1.spend_date,
        P1.platform,
        COALESCE(P2.amount, 0) AS amount
    FROM PlatformArray P1
    LEFT JOIN Platforms P2 ON P1.spend_date = P2.spend_date AND
                              P1.platform = P2.platform
)
SELECT
    spend_date,
    platform,
    SUM(amount) AS total_amount,
    COUNT(user_id) AS total_users
FROM NewSpending
GROUP BY
    spend_date,
    platform;
