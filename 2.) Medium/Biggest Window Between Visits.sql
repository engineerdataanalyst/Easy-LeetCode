/* Assume today's date is '2021-1-1'.

   Write an SQL query that will, for each user_id, 
   find out the largest window of days between each visit and the one right after it (or today if you are considering the last visit).

   Return the result table ordered by user_id. */

WITH LeadVisitDates AS
(
    SELECT
        user_id,
        visit_date,
        COALESCE(lead_visit_date, STR_TO_DATE('2021-01-01', '%Y-%m-%d')) AS lead_visit_date,
        DATEDIFF(COALESCE(lead_visit_date, STR_TO_DATE('2021-01-01', '%Y-%m-%d')), visit_date) AS visit_date_difference
    FROM
    (
        SELECT
            user_id,
            visit_date,
            LEAD(visit_date) OVER(PARTITION BY user_id ORDER BY visit_date) AS lead_visit_date
        FROM UserVisits
    ) U
),
NewUserVisits AS
(
    SELECT
        user_id,
        visit_date,
        lead_visit_date,
        visit_date_difference,
        DENSE_RANK() OVER(PARTITION BY user_id ORDER BY visit_date_difference DESC) AS rank_num
    FROM LeadVisitDates
)
SELECT DISTINCT
    user_id,
    visit_date_difference AS biggest_window
FROM NewUserVisits
WHERE rank_num = 1;
