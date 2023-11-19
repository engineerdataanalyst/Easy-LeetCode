/* The answer rate for a question is
   the number of times a user answered the question
   divided by the number of times a user showed the question.

   Write an SQL query to report the question that has the highest answer rate. 
   If multiple questions have the same maximum answer rate,
   report the question with the smallest question_id. */

WITH T1 AS
(
    SELECT
        question_id,
        COUNT(COALESCE(answer_id, NULL))/
       (COUNT(COALESCE(answer_id, action))-COUNT(COALESCE(answer_id, NULL))) AS answer_rate
    FROM SurveyLog
    GROUP BY question_id
),
T2 AS
(
    SELECT
        COUNT(COALESCE(answer_id, NULL))/
       (COUNT(COALESCE(answer_id, action))-COUNT(COALESCE(answer_id, NULL))) AS answer_rate
    FROM SurveyLog
    GROUP BY question_id
)
SELECT
    question_id AS survey_log
FROM T1
GROUP BY question_id
HAVING MAX(answer_rate) = 
    (SELECT MAX(answer_rate)
     FROM T2)
ORDER BY question_id
LIMIT 1;
