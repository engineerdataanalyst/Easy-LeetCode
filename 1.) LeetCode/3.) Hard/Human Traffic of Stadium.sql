/* Write an SQL query to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

   Return the result table ordered by visit_date in ascending order. */

WITH RECURSIVE NewStadium AS
(
    SELECT
        S.id,
        S.visit_date,
        S.people,
        S.lag_people,
        S.row_num,
        1 AS group_num
    FROM
    (
        SELECT
            id,
            visit_date,
            people,
            COALESCE(LAG(people) OVER(ORDER BY id), people) AS lag_people,
            ROW_NUMBER() OVER() AS row_num
        FROM Stadium
    ) S
    WHERE S.row_num = 1

    UNION

    SELECT
        S.id,
        S.visit_date,
        S.people,
        S.lag_people,
        S.row_num,
        CASE
            WHEN S.people < 100 OR
                 S.lag_people < 100 THEN N.group_num+1
            ELSE N.group_num
        END AS group_num
    FROM
        NewStadium N,
        (
            SELECT
                id,
                visit_date,
                people,
                COALESCE(LAG(people) OVER(ORDER BY id), people) AS lag_people,
                ROW_NUMBER() OVER() AS row_num
            FROM Stadium
        ) S
    WHERE S.row_num = N.row_num+1 AND
          S.row_num <= (SELECT COUNT(*) FROM Stadium)
),
NumGroups AS
(
    SELECT
        *,
        COUNT(*) OVER(PARTITION BY group_num) AS num_groups
    FROM NewStadium
)
SELECT
    id,
    visit_date,
    people
FROM NumGroups
WHERE people >= 100 AND
      num_groups >= 3
ORDER BY visit_date;
