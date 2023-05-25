/* Write an SQL query to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:

   have the same tiv_2015 value as one or more other policyholders, and
   are not located in the same city like any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
   
   Round tiv_2016 to two decimal places. */

WITH NumberOfTiv_2015s AS
(
    SELECT
        tiv_2015,
        COUNT(tiv_2015) AS num_tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
),
NewInsurance AS
(    
    SELECT
        pid,
        tiv_2015,
        tiv_2016,
        lat,
        lon,
        ROW_NUMBER() OVER(PARTITION BY lat, lon) AS row_num
    FROM Insurance
)
SELECT
    ROUND(SUM(CASE
                  WHEN (SELECT N1.num_tiv_2015
                        FROM NumberOfTiv_2015s N1
                        WHERE N1.tiv_2015 = N2.tiv_2015) >= 2 AND
                       (SELECT COUNT(N1.row_num)
                        FROM NewInsurance N1
                        WHERE N1.lat = N2.lat AND
                              N1.lon = N2.lon) = 1 THEN N2.tiv_2016
                  ELSE 0
              END), 2) AS tiv_2016
FROM NewInsurance N2;
