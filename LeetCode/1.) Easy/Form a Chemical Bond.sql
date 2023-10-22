/* Two elements can form a bond if one of them is 'Metal' and the other is 'Nonmetal'.
   Write an SQL query to find all the pairs of elements that can form a bond. */

SELECT
    E1.symbol AS metal,
    E2.symbol AS nonmetal
FROM Elements E1
CROSS JOIN Elements E2
WHERE E1.type = 'Metal' AND
      E2.type = 'Nonmetal';
