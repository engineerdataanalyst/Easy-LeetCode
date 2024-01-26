/* Write a solution to find the top seller who has sold the highest number of unique items with a different brand than their favorite brand.
   If there are multiple sellers with the same highest count, return all of them.

   Return the result table ordered by seller_id in ascending order. */

WITH Sellers AS
(
    SELECT
        U.seller_id,
        COUNT(DISTINCT I.item_id) AS num_items,
        DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT I.item_id) DESC) AS rank_num
    FROM Users U
    LEFT JOIN Orders O ON U.seller_id = O.seller_id
    LEFT JOIN Items I ON O.item_id = I.item_id
    WHERE U.favorite_brand != I.item_brand
    GROUP BY U.seller_id
)
SELECT
    seller_id,
    num_items
FROM Sellers
WHERE rank_num = 1
ORDER BY seller_id;
