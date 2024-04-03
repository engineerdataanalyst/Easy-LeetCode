/* Find the top 2 highest paid City employees for each job title.
   Use totalpaybenefits column for their ranking.
   Output the job title along with the corresponding highest and second-highest paid employees. */

WITH pay_ranks AS
(
    SELECT
        jobtitle,
        employeename,
        totalpaybenefits,
        DENSE_RANK() OVER(PARTITION BY jobtitle ORDER BY totalpaybenefits DESC) AS rank_num,
        ROW_NUMBER() OVER(PARTITION BY jobtitle ORDER BY totalpaybenefits DESC) AS row_num
    FROM sf_public_salaries
),
highest_pay AS
(
    SELECT
        jobtitle,
        employeename,
        rank_num,
        row_num
    FROM pay_ranks
    WHERE rank_num = 1 
),
second_highest_pay AS
(
    SELECT
        jobtitle,
        employeename,
        rank_num,
        row_num
    FROM
    (
        SELECT
            jobtitle,
            employeename,
            CASE
                WHEN rank_num != row_num THEN 2
                ELSE rank_num
            END AS rank_num,
            row_num
        FROM pay_ranks
    ) p
    WHERE rank_num = 2 AND
          row_num = 2
)
SELECT
    h.jobtitle,
    h.employeename AS highest,
    s.employeename AS second_highest
FROM highest_pay h
LEFT JOIN second_highest_pay s ON h.jobtitle = s.jobtitle
WHERE h.employeename != s.employeename OR
      s.employeename IS NULL;
