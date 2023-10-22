/* The election is conducted in a city where everyone can vote for one or more candidates or choose not to vote.
   Each person has 1 vote so if they vote for multiple candidates, their vote gets equally split across them.
   For example, if a person votes for 2 candidates, these candidates receive an equivalent of 0.5 votes each.

   Write an SQL query to find candidate who got the most votes and won the election.
   Output the name of the candidate or If multiple candidates have an equal number of votes, display the names of all of them.

   Return the result table ordered by candidate in ascending order. */

WITH TotalVotes AS
(
    SELECT
        voter,
        COUNT(*) AS total_votes
    FROM Votes
    WHERE candidate IS NOT NULL
    GROUP BY voter
),
CandidateVotes AS
(
    SELECT
        *,
        DENSE_RANK() OVER(ORDER BY vote_value DESC) AS rank_num
    FROM
    (
        SELECT
            V.candidate,
            SUM(1/T.total_votes) AS vote_value
        FROM Votes V
        LEFT JOIN TotalVotes T ON V.voter = T.voter
        WHERE V.candidate IS NOT NULL
        GROUP BY V.candidate
    ) V
)
SELECT candidate
FROM CandidateVotes
WHERE rank_num = 1
ORDER BY candidate;
