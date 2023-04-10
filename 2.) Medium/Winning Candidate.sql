/* Write an SQL query to report the name of the winning candidate
  (i.e., the candidate who got the largest number of votes). */

SELECT C1.name
FROM Vote V1
LEFT JOIN Candidate C1 ON V1.candidateId = C1.id
GROUP BY V1.candidateId
HAVING COUNT(V1.candidateId) = 
    (SELECT MAX(num_candidates)
     FROM
         (SELECT COUNT(V2.candidateId) AS num_candidates
          FROM Vote V2
          LEFT JOIN Candidate C2 ON V2.candidateId = C2.id
          GROUP BY V2.candidateId) t);
