/* Write an SQL query to rank the scores.
   The ranking should be calculated according to the following rules:
   
   1.) The scores should be ranked from the highest to the lowest.
   2.) If there is a tie between two scores, both should have the same ranking.
   3.) After a tie, the next ranking number should be the next consecutive integer value. 
       In other words, there should be no holes between ranks. */

SELECT
    score,
    DENSE_RANK() OVER(ORDER BY score DESC) AS rank
FROM Scores;
