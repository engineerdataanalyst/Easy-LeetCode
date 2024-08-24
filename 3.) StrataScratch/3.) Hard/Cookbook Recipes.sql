/* You are given the table with titles of recipes from a cookbook and their page numbers. You are asked to represent how the recipes will be distributed in the book.
   Produce a table consisting of three columns: 
      left_page_number, left_title and right_title. 
      The k-th row (counting from 0), should contain the number and the title of the page with the number 2k
      2k in the first and second columns respectively, and 
      the title of the page with the number 2k+1 in the third column.
    
Each page contains at most 1 recipe. If the page does not contain a recipe, the appropriate cell should remain empty (NULL value). 
Page 0 (the internal side of the front cover) is guaranteed to be empty. */

WITH page_numbers AS
(
    SELECT
        page_number,
        ROW_NUMBER() OVER()-1 AS k
    FROM
    (
        SELECT generate_series(0, MAX(page_number), 2) AS page_number
        FROM cookbook_titles
    ) c
),
modified_cookbook_titles AS
(
    SELECT
        0 AS page_number,
        NULL AS title
    
    UNION ALL
    
    SELECT *
    FROM cookbook_titles
    WHERE MOD(page_number, 2) = 0
)
SELECT
    p.page_number AS left_page_number,
    m.title AS left_title,
    (SELECT c.title
     FROM cookbook_titles c
     WHERE c.page_number = 2*p.k+1) AS right_title
FROM page_numbers p
LEFT JOIN modified_cookbook_titles m ON p.page_number = m.page_number;
