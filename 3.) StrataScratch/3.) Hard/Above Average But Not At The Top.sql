/* Find all people who earned more than the average in 2013 for their designation but were not amongst the top 5 earners for their job title.
   Use the totalpay column to calculate total earned and output the employee name(s) as the result. */
 
WITH top5_earners AS
(
    SELECT
        employeename,
        totalpay,
        AVG(totalpay) OVER(PARTITION BY jobtitle) AS avg_2013_totalpay,
        DENSE_RANK() OVER(PARTITION BY jobtitle ORDER BY totalpay DESC) AS rank_num
    FROM sf_public_salaries
    WHERE year = 2013
)
SELECT employeename
FROM top5_earners
WHERE totalpay > avg_2013_totalpay AND
      rank_num > 5;
