/* Write an SQL query to report the first name, last name, city, and state 
   of each person in the Person table. 
   If the address of a personId is not present in the Address table, report null instead. */

SELECT P.firstName, P.lastName, A.city, A.state
FROM Person P
LEFT JOIN Address A ON P.personId = A.personId;
