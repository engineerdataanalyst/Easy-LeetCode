/* Find the top 5 highest paid and top 5 least paid employees in 2012.
   Output the employee name along with the corresponding total pay with benefits.
   Sort records based on the total payment with benefits in ascending order. */

WITH cte AS
(
    SELECT
        employeename,
        totalpaybenefits,
        RANK() OVER(ORDER BY totalpaybenefits DESC) AS desc_rank_num,
        RANK() OVER(ORDER BY totalpaybenefits) AS asc_rank_num
    FROM sf_public_salaries
    WHERE year = 2012
)
SELECT
    employeename,
    totalpaybenefits
FROM cte
WHERE desc_rank_num <= 5 OR
      asc_rank_num <= 5
ORDER BY totalpaybenefits;
