/* You want to know how long a user visits your application.
   You decided to create bins of "[0-5>", "[5-10>", "[10-15>", and "15 minutes or more"
   and count the number of sessions on it.

   Write an SQL query to report the (bin, total). */

WITH T1 AS
(
    SELECT '[0-5>' AS bin
    UNION
    SELECT '[5-10>' AS bin
    UNION
    SELECT '[10-15>' AS bin
    UNION
    SELECT '15 or more' AS bin
),
T2 AS
(
    SELECT
        session_id,
        duration,
        CASE
            WHEN 0 <= duration/60 AND duration/60 < 5 THEN '[0-5>'
            WHEN 5 <= duration/60 AND duration/60 < 10 THEN '[5-10>'
            WHEN 10 <= duration/60 AND duration/60 < 15 THEN '[10-15>'
            ELSE '15 or more'
        END AS bin
    FROM Sessions
)
SELECT
    T1.bin,
    COUNT(T2.duration) AS total
FROM T1
LEFT JOIN T2 ON T1.bin = T2.bin
GROUP BY T1.bin;
