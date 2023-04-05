/* Write an SQL query to delete all the duplicate emails,
   keeping only one unique email with the smallest id.
   Note that you are supposed to write a DELETE statement and not a SELECT one.
    After running your script, the answer shown is the Person table.
    The driver will first compile and run your piece of code and then show the Person table.
    
    The final order of the Person table does not matter. */

DELETE new_Person1 FROM Person new_Person1
JOIN Person new_Person2
WHERE
    new_Person1.id > new_Person2.id AND
    new_Person1.email = new_Person2.email;
