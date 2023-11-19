/* Write an SQL query to find for each user, 
   the join date and the number of orders they made as a buyer in 2019. */

SELECT
    COALESCE(U.user_id, O.buyer_id) AS buyer_id,
    U.join_date,
    COUNT(CASE WHEN YEAR(order_date) = 2019 THEN user_id ELSE NULL END) AS orders_in_2019
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.buyer_id
GROUP BY U.user_id
ORDER BY U.user_id;
