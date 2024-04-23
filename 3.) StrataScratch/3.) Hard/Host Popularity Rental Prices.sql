/* You’re given a table of rental property searches by users.
   The table consists of search results and outputs host information for searchers.

   Find the minimum, average, maximum rental prices for each host’s popularity rating. The host’s popularity rating is defined as below:
   0 reviews: New
   1 to 5 reviews: Rising
   6 to 15 reviews: Trending Up
   16 to 40 reviews: Popular
   more than 40 reviews: Hot

   Tip: 
   The id column in the table refers to the search ID. 
   You'll need to create your own host_id by concating price, room_type, host_since, zipcode, and number_of_reviews.

   Output host popularity rating and their minimum, average and maximum rental prices. */

WITH host_reviews AS
(
    SELECT
        CONCAT(price, ' ', room_type, ' ', host_since, ' ', zipcode, ' ', number_of_reviews) AS host_id,
        SUM(number_of_reviews) AS total_reviews
    FROM airbnb_host_searches
    GROUP BY host_id
),
host_prices AS
(
    SELECT DISTINCT
        CONCAT(price, ' ', room_type, ' ', host_since, ' ', zipcode, ' ', number_of_reviews) AS host_id,
        price
    FROM airbnb_host_searches
)
SELECT
    CASE
        WHEN r.total_reviews = 0 THEN 'New'
        WHEN r.total_reviews BETWEEN 1 AND 5 THEN 'Rising'
        WHEN r.total_reviews BETWEEN 6 AND 15 THEN 'Trending Up'
        WHEN r.total_reviews BETWEEN 16 AND 40 THEN 'Popular'
        ELSE 'Hot'
    END AS host_popularity,
    MIN(p.price) AS min_price,
    AVG(p.price) AS avg_price,
    MAX(p.price) AS max_price
FROM host_reviews r
INNER JOIN host_prices p ON r.host_id = p.host_id
GROUP BY host_popularity;
