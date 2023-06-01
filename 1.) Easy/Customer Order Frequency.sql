/* Write an SQL query to report the customer_id and customer_name of customers
   who have spent at least $100 in each month of June and July 2020. */

WITH MoneySpentInJune AS
(
    SELECT
        O.customer_id,
        C.name,
        SUM(O.quantity*P.price) AS money_spent_in_june
    FROM Orders O
    LEFT JOIN Customers C ON O.customer_id = C.customer_id
    LEFT JOIN Product P ON O.product_id = P.product_id
    WHERE MONTH(order_date) = 6 AND
          YEAR(order_date) = 2020
    GROUP BY
        O.customer_id,
        MONTH(order_date)
),
MoneySpentInJuly AS
(
    SELECT
        O.customer_id,
        C.name,
        SUM(O.quantity*P.price) AS money_spent_in_july
    FROM Orders O
    LEFT JOIN Customers C ON O.customer_id = C.customer_id
    LEFT JOIN Product P ON O.product_id = P.product_id
    WHERE MONTH(order_date) = 7 AND
          YEAR(order_date) = 2020
    GROUP BY
        O.customer_id,
        MONTH(order_date)
)
SELECT
    M1.customer_id,
    M1.name
FROM MoneySpentInJune M1
LEFT JOIN MoneySpentInJuly M2 ON M1.customer_id = M2.customer_id
WHERE COALESCE(money_spent_in_june, 0) >= 100 AND
      COALESCE(money_spent_in_july, 0) >= 100;
