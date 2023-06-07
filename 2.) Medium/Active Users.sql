/* Active users are those who logged in to their accounts for five or more consecutive days.

   Write an SQL query to find the id and the name of active users.
   Return the result table ordered by id. */

WITH RECURSIVE NewLogins AS
(
    SELECT
        L.id,
        L.lead_id,
        L.login_date,
        L.lead_login_date,
        DATEDIFF(L.lead_login_date, L.login_date) AS login_date_difference,
        L.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            id,
            LEAD(id) OVER(PARTITION BY id ORDER BY login_date) AS lead_id,
            login_date,
            LEAD(login_date) OVER(PARTITION BY id ORDER BY login_date) AS lead_login_date,
            ROW_NUMBER() OVER(ORDER BY id, login_date) AS row_num
        FROM Logins
    ) L
    WHERE L.row_num = 1

    UNION

    SELECT
        L.id,
        L.lead_id,
        L.login_date,
        L.lead_login_date,
        DATEDIFF(L.lead_login_date, L.login_date) AS login_date_difference,
        L.row_num,
        CASE
            WHEN L.id != L.lead_id OR
                 DATEDIFF(L.lead_login_date, L.login_date) > 1 THEN N.group_num+1
            ELSE N.group_num
        END AS group_num
    FROM
        NewLogins N,
        (
            SELECT
                id,
                LEAD(id) OVER(PARTITION BY id ORDER BY login_date) AS lead_id,
                login_date,
                LEAD(login_date) OVER(PARTITION BY id ORDER BY login_date) AS lead_login_date,
                ROW_NUMBER() OVER(ORDER BY id, login_date) AS row_num
            FROM Logins
        ) L
    WHERE L.row_num = N.row_num+1 AND
          L.row_num <= (SELECT COUNT(*) FROM Logins)
),
GroupedLogins AS
(
    SELECT
        *,
        COUNT(group_num) OVER(PARTITION BY id, group_num) AS num_groups
    FROM NewLogins
    WHERE lead_login_date IS NOT NULL AND
         (login_date_difference IS NULL OR
          login_date_difference = 1)
    ORDER BY
        id,
        login_date
)
SELECT
    G.id,
    A.name
FROM GroupedLogins G
LEFT JOIN Accounts A ON G.id = A.id
WHERE num_groups >= 4
GROUP BY G.id
ORDER BY G.id;
