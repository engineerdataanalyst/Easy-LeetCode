/* Write a solution that reports for each user the product id on which the user spent the most money.
   In case the same user spent the most money on two or more products, report all of them. */

WITH MoneyTable AS
(
    SELECT
        S.user_id,
        S.product_id,
        SUM(S.quantity*P.price) AS money_spent,
        DENSE_RANK() OVER(PARTITION BY S.user_id ORDER BY SUM(S.quantity*P.price) DESC) AS rank_num
    FROM Sales S
    LEFT JOIN Product P ON S.product_id = P.product_id
    GROUP BY
        S.user_id,
        P.product_id
)
SELECT
    user_id,
    product_id
FROM MoneyTable
WHERE rank_num = 1
ORDER BY
    user_id,
    product_id;
