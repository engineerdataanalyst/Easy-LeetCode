/* Write an SQL query to swap the seat id of every two consecutive students.
   If the number of students is odd, the id of the last student is not swapped.

   Return the result table ordered by id in ascending order. */

WITH SwappedId AS
(
    SELECT
        CASE
            WHEN MOD(S2.id, 2) != 0 AND
                 S2.id = (SELECT MAX(S1.id) FROM Seat S1) THEN S2.id
            WHEN MOD(S2.id, 2) != 0 THEN (SELECT id
                                          FROM Seat S1
                                          WHERE S1.id = S2.id+1)
            WHEN MOD(S2.Id, 2) = 0 THEN (SELECT id
                                         FROM Seat S1
                                         WHERE S1.id = S2.id-1)
        END AS id
    FROM Seat S2
),
SwappedSeat AS
(
    SELECT
        S1.id,
        S2.student
    FROM SwappedId S1
    LEFT JOIN Seat S2 ON S1.id = S2.id
)
SELECT
    CASE
        WHEN MOD(S2.id, 2) != 0 AND
             S2.id = (SELECT MAX(S1.id) FROM Seat S1) THEN S2.id
        WHEN MOD(S2.id, 2) = 0 THEN (SELECT id
                                     FROM SwappedSeat S1
                                     WHERE S1.id = S2.id-1)
        WHEN MOD(S2.id, 2) != 0 THEN (SELECT id
                                      FROM SwappedSeat S1
                                      WHERE S1.id = S2.id+1)
    END AS id,
    S2.student
FROM SwappedSeat S2;
