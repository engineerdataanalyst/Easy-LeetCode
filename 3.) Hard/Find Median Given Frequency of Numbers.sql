/* Write an SQL query to report the median of all the numbers in the database after decompressing the Numbers table.
   Round the median to one decimal point. */

WITH RECURSIVE UnpackedNumbers AS
(
    SELECT
        num,
        frequency,
        1 AS counter
    FROM Numbers

    UNION

    SELECT
        num,
        frequency,
        counter+1
    FROM UnpackedNumbers
    WHERE counter < frequency
),
RowNumbers AS
(
    SELECT
        num,
        ROW_NUMBER() OVER() AS row_num
    FROM UnpackedNumbers
    ORDER BY num
),
MaxRowNumber(num) AS
(
    SELECT MAX(row_num)
    FROM RowNumbers
),
MedianInfo AS
(
    SELECT
        R.num,
        R.row_num,
        CASE
            WHEN MOD(M.num, 2) = 0 THEN M.num/2
            ELSE ROUND(M.num/2)
        END AS low,
        CASE
            WHEN MOD(M.num, 2) = 0 THEN M.num/2+1
            ELSE ROUND(M.num/2)
        END AS high
    FROM
        RowNumbers R,
        MaxRowNumber M
)
SELECT ROUND(AVG(num), 1) AS median
FROM MedianInfo
WHERE row_num IN (low, high);
