/* You have a very powerful program that can solve any equation of one variable in the world.
   The equation passed to the program must be formatted as follows:

   The left-hand side (LHS) should contain all the terms.
   The right-hand side (RHS) should be zero.
   Each term of the LHS should follow the format "<sign><fact>X^<pow>" where:
   <sign> is either "+" or "-".
   <fact> is the absolute value of the factor.
   <pow> is the value of the power.
   If the power is 1, do not add "^<pow>".
   For example, if power = 1 and factor = 3, the term will be "+3X".
   If the power is 0, add neither "X" nor "^<pow>".
   For example, if power = 0 and factor = -3, the term will be "-3".
   The powers in the LHS should be sorted in descending order.

   Write an SQL query to build the equation. */

WITH NewTerms AS
(
    SELECT
        power,
        factor,
        CONCAT(CASE
                   WHEN factor > 0 THEN '+'
                   ELSE '-'
               END,
               CASE
                   WHEN power = 0 THEN abs(factor)
                   WHEN power = 1 THEN CONCAT(abs(factor), 'X')
                   ELSE CONCAT(abs(factor), 'X^', power)
               END) AS term
    FROM Terms
)
SELECT CONCAT(GROUP_CONCAT(term ORDER BY power DESC SEPARATOR ''), '=0') AS equation
FROM NewTerms;
