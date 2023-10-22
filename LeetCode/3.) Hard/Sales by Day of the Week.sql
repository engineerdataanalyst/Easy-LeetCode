/* You are the business owner and would like to obtain a sales report for category items and the day of the week.

   Write an SQL query to report how many units in each category have been ordered on each day of the week.
   Return the result table ordered by category. */

SELECT
    I.item_category AS Category,
    SUM(CASE
            WHEN WEEKDAY(O.order_date) = 0 THEN O.quantity
            ELSE 0
        END) AS Monday,
    SUM(CASE
            WHEN WEEKDAY(O.order_date) = 1 THEN O.quantity
            ELSE 0
        END) AS Tuesday,
    SUM(CASE
            WHEN WEEKDAY(O.order_date) = 2 THEN O.quantity
            ELSE 0
        END) AS Wednesday,
    SUM(CASE
            WHEN WEEKDAY(O.order_date) = 3 THEN O.quantity
            ELSE 0
        END) AS Thursday,
    SUM(CASE
            WHEN WEEKDAY(O.order_date) = 4 THEN O.quantity
            ELSE 0
        END) AS Friday,
    SUM(CASE
            WHEN WEEKDAY(O.order_date) = 5 THEN O.quantity
            ELSE 0
        END) AS Saturday,
    SUM(CASE
            WHEN WEEKDAY(O.order_date) = 6 THEN O.quantity
            ELSE 0
        END) AS Sunday
FROM Items I
LEFT JOIN Orders O ON I.item_id = O.item_id
GROUP BY I.item_category
ORDER BY I.item_category;
