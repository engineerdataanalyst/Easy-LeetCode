-- Find all words which contain exactly two vowels in any list in the table.

WITH word_list AS
(
    SELECT SUBSTRING_INDEX(words1, ',', 1) AS word
    FROM google_word_lists
    
    UNION
    
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(words1, ',', 2), ',', '-1') AS word
    FROM google_word_lists
    
    UNION
    
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(words1, ',', 3), ',', '-1') AS word
    FROM google_word_lists
    
    UNION
    
    SELECT SUBSTRING_INDEX(words2, ',', 1) AS word
    FROM google_word_lists
    
    UNION
    
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(words2, ',', 2), ',', '-1') AS word
    FROM google_word_lists
    
    UNION
    
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(words2, ',', 3), ',', '-1') AS word
    FROM google_word_lists
)
SELECT word
FROM word_list
WHERE LENGTH(word)-LENGTH(REPLACE(word, 'a', ''))+
      LENGTH(word)-LENGTH(REPLACE(word, 'e', ''))+
      LENGTH(word)-LENGTH(REPLACE(word, 'i', ''))+
      LENGTH(word)-LENGTH(REPLACE(word, 'o', ''))+
      LENGTH(word)-LENGTH(REPLACE(word, 'u', '')) = 2;
