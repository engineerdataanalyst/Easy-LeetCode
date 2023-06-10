/* Write an SQL query to rearrange the Genders table such that the rows alternate between 'female', 'other', and 'male' in order.
   The table should be rearranged such that the IDs of each gender are sorted in ascending order.
 
   Return the result table in the mentioned order. */

WITH RECURSIVE GenderList AS
(
    SELECT
        'female' AS gender,
        1 AS rank_num
    UNION

    SELECT
        'other' AS gender,
        1 AS rank_num
    UNION

    SELECT
        'male' AS gender,
        1 AS rank_num
    UNION

    SELECT
        gender,
        rank_num+1 AS rank_num
    FROM GenderList
    WHERE rank_num+1 <= (SELECT COUNT(*)/3 FROM Genders)
),
SortedGenders AS
(
    SELECT
        *,
        DENSE_RANK() OVER(PARTITION BY gender ORDER BY user_id) AS rank_num
    FROM Genders
)
SELECT
    S.user_id,
    S.gender
FROM GenderList G
LEFT JOIN SortedGenders S ON G.gender = S.gender AND
                             G.rank_num = S.rank_num;
