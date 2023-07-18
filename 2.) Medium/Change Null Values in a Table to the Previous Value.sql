/* Write an SQL query to replace the null values of drink with the name of the drink of the previous row that is not null.
   It is guaranteed that the drink of the first row of the table is not null.

   Return the result table in the same order as the input. */

WITH RECURSIVE LagCoffeeShop AS
(
    SELECT
        id,
        drink,
        ROW_NUMBER() OVER() AS row_num
    FROM CoffeeShop
),
NewCoffeeShop AS
(
    SELECT
        id,
        drink,
        1 AS group_num,
        row_num
    FROM LagCoffeeShop
    WHERE row_num = 1

    UNION

    SELECT
        L.id,
        L.drink,
        CASE
            WHEN L.drink IS NULL THEN N.group_num
            ELSE N.group_num+1
        END AS group_num,
        L.row_num
    FROM LagCoffeeShop L,
         NewCoffeeShop N
    WHERE L.row_num = N.row_num+1 AND
          L.row_num <= (SELECT COUNT(*) FROM LagCoffeeShop)
)
SELECT
    id,
    FIRST_VALUE(drink) OVER(PARTITION BY group_num ORDER BY row_num) AS drink
FROM NewCoffeeShop;
