/* Write an SQL query to delete all the duplicate emails, keeping only one unique email with the smallest id.
   Note that you are supposed to write a DELETE statement and not a SELECT one. */

DELETE new_Person1 FROM Person new_Person1
JOIN Person new_Person2
WHERE
    new_Person1.id > new_Person2.id AND
    new_Person1.email = new_Person2.email;
