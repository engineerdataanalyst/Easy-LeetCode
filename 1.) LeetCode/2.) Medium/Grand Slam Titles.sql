/* Write an SQL query to report the number of grand slam tournaments won by each player.
   Do not include the players who did not win any tournament. */

WITH Wimbledon AS
(
    SELECT
        P.player_id,
        P.player_name,
        COUNT(C.Wimbledon) AS grand_slams_count
    FROM Players P
    LEFT JOIN Championships C ON P.player_id = C.Wimbledon
    GROUP BY P.player_id
),
Fr_open AS
(
    SELECT
        P.player_id,
        P.player_name,
        COUNT(C.Fr_open) AS grand_slams_count
    FROM Players P
    LEFT JOIN Championships C ON P.player_id = C.Fr_open
    GROUP BY P.player_id
),
US_open AS
(
    SELECT
        P.player_id,
        P.player_name,
        COUNT(C.US_open) AS grand_slams_count
    FROM Players P
    LEFT JOIN Championships C ON P.player_id = C.US_open
    GROUP BY P.player_id
),
Au_open AS
(
    SELECT
        P.player_id,
        P.player_name,
        COUNT(C.Au_open) AS grand_slams_count
    FROM Players P
    LEFT JOIN Championships C ON P.player_id = C.Au_open
    GROUP BY P.player_id
)
SELECT
    W.player_id,
    W.player_name,
    W.grand_slams_count+F.grand_slams_count+U.grand_slams_count+A.grand_slams_count AS grand_slams_count
FROM Wimbledon W
LEFT JOIN Fr_open F ON W.player_id = F.player_id
LEFT JOIN US_open U ON W.player_id = U.player_id
LEFT JOIN Au_open A ON W.player_id = A.player_id
WHERE W.grand_slams_count+F.grand_slams_count+U.grand_slams_count+A.grand_slams_count > 0
ORDER BY W.player_id;
