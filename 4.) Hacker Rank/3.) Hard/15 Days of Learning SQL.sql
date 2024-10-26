/* Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

   Write a query to print total number of unique hackers who made at least submission each day (starting on the first day of the contest), 
   and find the hacker_id and name of the hacker who made maximum number of submissions each day. 

   If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. 
   The query should print this information for each day of the contest, sorted by the date. */

WITH HackerList AS
(-- Create a list of hackers per submission date that meet criteria.
    SELECT
        submission_date,
        hacker_id
    FROM Submissions
    WHERE submission_date = '2016-03-01'
    
    UNION ALL
    
    SELECT
        S.submission_date,
        S.hacker_id
    FROM Submissions S
    INNER JOIN HackerList H ON S.submission_date = DATEADD(day, 1, H.submission_date) AND
                               S.hacker_id = H.hacker_id
    WHERE H.submission_date <= '2016-03-15'
),
HackerListAgg AS
(-- Calculate the number of distinct hackers per submission date that meet the criteria.
    SELECT
        submission_date,
        COUNT(DISTINCT hacker_id) AS num_hackers
    FROM HackerList
    GROUP BY submission_date
),
SubmissionList AS
(-- Rank the hackers with the most number of submissions per submission date.
 -- Hackers with the smallest ID win the tiebreaker for number of submissions.
    SELECT
        S.submission_date,
        H.hacker_id,
        H.name,
        COUNT(*) AS num_hackers,
        RANK() OVER(PARTITION BY S.submission_date ORDER BY COUNT(*) DESC, H.hacker_id) AS rank_num
    FROM Submissions S
    INNER JOIN Hackers H ON S.hacker_id = H.hacker_id
    GROUP BY
        S.submission_date,
        H.hacker_id,
        H.name
)
SELECT
-- Join the two tables on the common submission date column.
-- Filter out the result set to ranking numbers equal to one.
    H.submission_date,
    H.num_hackers,
    S.hacker_id,
    S.name
FROM HackerListAgg H
INNER JOIN SubmissionList S ON H.submission_date = S.submission_date
WHERE S.rank_num = 1;
