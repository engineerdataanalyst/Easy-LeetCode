/* Write an SQL query to:

   Find the name of the user who has rated the greatest number of movies. 
   In case of a tie, return the lexicographically smaller user name.

   Find the movie name with the highest average rating in February 2020. 
   In case of a tie, return the lexicographically smaller movie name. */

WITH NewMovieRating AS
(
    SELECT
        M1.movie_id,
        M2.title,
        M1.user_id,
        U.name,
        M1.rating,
        M1.created_at
    FROM MovieRating M1
    LEFT JOIN Movies M2 ON M1.movie_id = M2.movie_id
    LEFT JOIN Users U ON M1.user_id = U.user_id
),
NumberOfMovieRatings AS
(
    SELECT
        user_id,
        name,
        num_movie_ratings,
        DENSE_RANK() OVER(ORDER BY num_movie_ratings DESC) AS rank_num
    FROM
    (
        SELECT
            user_id,
            name,
            COUNT(created_at) AS num_movie_ratings
        FROM NewMovieRating
        GROUP BY
            user_id,
            name
    ) N
),
AverageMovieRatings AS
(
    SELECT
        movie_id,
        title,
        average_movie_rating,
        DENSE_RANK() OVER(ORDER BY average_movie_rating DESC) AS rank_num
    FROM
    (
        SELECT
            movie_id,
            title,
            AVG(rating) AS average_movie_rating
        FROM NewMovieRating
        WHERE MONTH(created_at) = 2 AND YEAR(created_at) = 2020
        GROUP BY
            movie_id,
            title
    ) A
)
SELECT MIN(name) AS results
FROM NumberOfMovieRatings
WHERE rank_num = 1

UNION ALL

SELECT MIN(title) AS results
FROM AverageMovieRatings
WHERE rank_num = 1;
