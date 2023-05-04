/* Write an SQL query to find all the people 
   who viewed more than one article on the same date.
   
   Return the result table sorted by id in ascending order. */

With NewViews AS
(
    SELECT
        article_id,
        viewer_id,
        view_date
    FROM Views
    GROUP BY
        viewer_id,
        view_date
    HAVING SUM(article_id) != COUNT(article_id)*article_id
    ORDER BY viewer_id
)
SELECT DISTINCT viewer_id AS id
FROM NewViews
