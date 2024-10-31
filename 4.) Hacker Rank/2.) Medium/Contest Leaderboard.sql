/* You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!

   The total score of a hacker is the sum of their maximum scores for all of the challenges.
   Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score.
   If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. Exclude all hackers with a total score of  from your result. */

WITH MaxScores AS
(-- Find the maximum score for each hacker per challenge
    SELECT
        H.hacker_id,
        H.name,
        MAX(S.score) AS max_score
    FROM Hackers H
    INNER JOIN Submissions S ON H.hacker_id = S.hacker_id
    GROUP BY
        H.hacker_id,
        H.name,
        S.challenge_id
)
SELECT
-- Calculate the sum of all maximum challenge scores for each hacker
    hacker_id,
    name,
    SUM(max_score) AS total_score
FROM MaxScores
GROUP BY
    hacker_id,
    name
HAVING SUM(max_score) != 0
ORDER BY
    SUM(max_score) DESC,
    hacker_id;
