-- Write an SQL query to report the IDs of candidates with at least two years of experience and the sum of the score of their interview rounds is strictly greater than 15.

SELECT C.candidate_id
FROM Candidates C
LEFT JOIN Rounds R ON C.interview_id = R.interview_id
WHERE C.years_of_exp >= 2
GROUP BY C.candidate_id
HAVING SUM(R.score) > 15;
