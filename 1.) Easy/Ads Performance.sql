/* A company is running Ads and wants to calculate the performance of each Ad.
   Performance of the Ad is measured using Click-Through Rate (CTR) where:

   CTR = 0 if Ad total tlicksc + AD total views = 0,
         ad total clockcs/(adt total clicks + ad total views)*100 otherwise
    
   Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.

   Return the result table ordered by ctr in descending order 
   and by ad_id in ascending order in case of a tie. */

SELECT
    ad_id,
    ROUND(CASE
             WHEN
                 COUNT(CASE WHEN action = 'Clicked' THEN action ELSE NULL END)+
                 COUNT(CASE WHEN action = 'Viewed' THEN action ELSE NULL END) = 0 THEN 0
             ELSE
                 COUNT(CASE WHEN action = 'Clicked' THEN action ELSE NULL END)/
                (COUNT(CASE WHEN action = 'Clicked' THEN action ELSE NULL END)+
                 COUNT(CASE WHEN action = 'Viewed' THEN action ELSE NULL END))*100
           END, 2) AS ctr
FROM Ads
GROUP BY ad_id
ORDER BY
    ctr DESC,
    ad_id;
