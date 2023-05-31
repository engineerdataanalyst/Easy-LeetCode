/* Write an SQL query to find for each user whether the brand of the second item (by date) they sold is their favorite brand. 
   If a user sold less than two items, report the answer for that user as no. 
   It is guaranteed that no seller sold more than one item on a day. */

WITH RowNumbers AS
(
    SELECT
        U.user_id,
        O.seller_id,
        O.item_id,
        I.item_brand,
        U.favorite_brand,
        ROW_NUMBER() OVER(PARTITION BY O.seller_id ORDER BY O.order_date) AS row_num
    FROM Users U
    LEFT JOIN Orders O ON U.user_id = O.seller_id
    LEFT JOIN Items I ON O.item_id = I.item_id
),
FavoriteBrands AS
(
    SELECT
        seller_id,
        CASE
            WHEN item_brand = favorite_brand THEN 'yes'
            ELSE 'no'
        END AS 2nd_item_fav_brand
    FROM RowNumbers
    WHERE row_num = 2
)
SELECT
    U.user_id AS seller_id,
    COALESCE(2nd_item_fav_brand, 'no') AS 2nd_item_fav_brand
FROM Users U
LEFT JOIN FavoriteBrands F ON U.user_id = F.seller_id;
