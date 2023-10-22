/* Write an SQL query to find how many times each artist appeared on the Spotify ranking list.

   Return the result table with the artist's name and the corresponding number of occurrences ordered by occurrence count in descending order.
   If the occurrences are equal, then it’s ordered by the artist’s name in ascending order. */

SELECT
    artist,
    COUNT(artist) AS occurrences
FROM Spotify
GROUP BY artist
ORDER BY
    occurrences DESC,
    artist;
