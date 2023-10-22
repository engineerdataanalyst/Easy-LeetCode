/* Leetcode has collected some posts from its social media website and is interested in finding the topics of each post.
   Each topic can be expressed by one or more keywords.
   If a keyword of a certain topic exists in the content of a post (case insensitive) then the post has this topic.

   Write an SQL query to find the topics of each post according to the following rules:

   If the post does not have keywords from any topic, its topic should be "Ambiguous!".
   If the post has at least one keyword of any topic, its topic should be a string of the IDs of its topics sorted in ascending order and separated by commas ','.
   The string should not contain duplicate IDs. */

WITH CrossJoin AS
(
    SELECT
        *,
        CASE
            WHEN REGEXP_INSTR(LOWER(P.content), CONCAT('^', LOWER(K.word), '[^a-z]')) != 0 OR
                 REGEXP_INSTR(LOWER(P.content), CONCAT('[^a-z]', LOWER(K.word), '[^a-z]')) != 0 OR
                 REGEXP_INSTR(LOWER(P.content), CONCAT('[^a-z]', LOWER(K.word), '$')) != 0 THEN 1
            ELSE 0
        END AS word_in_content
    FROM Keywords K
    CROSS JOIN Posts P
),
GroupConcat AS
(
    SELECT
        post_id,
        GROUP_CONCAT(DISTINCT topic_id ORDER BY topic_id) AS topic
    FROM CrossJoin
    WHERE word_in_content = 1
    GROUP BY post_id
),
PostIds AS
(
    SELECT post_id
    FROM Posts
)
SELECT
    P.post_id,
    COALESCE(G.topic, 'Ambiguous!') AS topic
FROM PostIds P
LEFT JOIN GroupConcat G ON P.post_id = G.post_id
ORDER BY P.post_id;
