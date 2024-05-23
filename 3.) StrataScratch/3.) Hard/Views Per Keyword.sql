/* Create a report showing how many views each keyword has.
   Output the keyword and the total views, and order records with highest view count first. */

WITH joined_table AS
(
    SELECT p.post_keywords
    FROM facebook_posts p
    INNER JOIN facebook_post_views v ON p.post_id = v.post_id
),
pivoted_keywords AS
(
    SELECT
        SUM(CASE WHEN POSITION('basketball' IN post_keywords) != 0 THEN 1 ELSE 0 END) AS basketball,
        SUM(CASE WHEN POSITION('lakers' IN post_keywords) != 0 THEN 1 ELSE 0 END) AS lakers,
        SUM(CASE WHEN POSITION('nba' IN post_keywords) != 0 THEN 1 ELSE 0 END) AS nba,
        SUM(CASE WHEN POSITION('lebron_james' IN post_keywords) != 0 THEN 1 ELSE 0 END) AS lebron_james,
        SUM(CASE WHEN POSITION('asparagus' IN post_keywords) != 0 THEN 1 ELSE 0 END) AS asparagus,
        SUM(CASE WHEN POSITION('food' IN post_keywords) != 0 THEN 1 ELSE 0 END) AS food,
        SUM(CASE WHEN POSITION('spaghetti' IN post_keywords) != 0 THEN 1 ELSE 0 END) AS spaghetti,
        SUM(CASE WHEN POSITION('spam' IN post_keywords) != 0 THEN 1 ELSE 0 END) AS spam
    FROM joined_table
)
SELECT 'basketball' AS keyword, basketball AS total_views FROM pivoted_keywords
UNION ALL
SELECT 'lakers' AS keyword, lakers AS total_views FROM pivoted_keywords
UNION ALL
SELECT 'nba' AS keyword, nba AS total_views FROM pivoted_keywords
UNION ALL
SELECT 'lebron_james' AS keyword, lebron_james AS total_views FROM pivoted_keywords
UNION ALL
SELECT 'asparagus' AS keyword, asparagus AS total_views FROM pivoted_keywords
UNION ALL
SELECT 'food' AS keyword, food AS total_views FROM pivoted_keywords
UNION ALL
SELECT 'spaghetti' AS keyword, spaghetti AS total_views FROM pivoted_keywords
UNION ALL
SELECT 'spam' AS keyword, spam AS total_views FROM pivoted_keywords
ORDER BY total_views DESC;
