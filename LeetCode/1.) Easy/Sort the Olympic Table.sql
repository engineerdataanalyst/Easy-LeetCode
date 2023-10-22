/* The Olympic table is sorted according to the following rules:

   The country with more gold medals comes first.
   If there is a tie in the gold medals, the country with more silver medals comes first.
   If there is a tie in the silver medals, the country with more bronze medals comes first.
   If there is a tie in the bronze medals, the countries with the tie are sorted in ascending order lexicographically. */

SELECT *
FROM Olympic
ORDER BY
    gold_medals DESC,
    silver_medals DESC,
    bronze_medals DESC,
    country;
