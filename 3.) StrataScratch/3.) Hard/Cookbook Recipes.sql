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
