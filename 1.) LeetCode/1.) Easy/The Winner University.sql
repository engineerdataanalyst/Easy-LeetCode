/* There is a competition between New York University and California University.
   The competition is held between the same number of students from both universities.
   The university that has more excellent students wins the competition. 
   If the two universities have the same number of excellent students, the competition ends in a draw.

   An excellent student is a student that scored 90% or more in the exam.

   Write an SQL query to report:

   "New York University" if New York University wins the competition.
   "California University" if California University wins the competition.
   "No Winner" if the competition ends in a draw. */

WITH NewYorkExcellentStudents AS
(
    SELECT COUNT(CASE WHEN score >= 90 THEN student_id ELSE NULL END) AS num_excellent_students
    FROM NewYork
),
CaliforniaExcellentStudents AS
(
    SELECT COUNT(CASE WHEN score >= 90 THEN student_id ELSE NULL END) AS num_excellent_students
    FROM California
)
SELECT CASE
           WHEN N.num_excellent_students > C.num_excellent_students THEN 'New York University'
           WHEN N.num_excellent_students < C.num_excellent_students THEN 'California University'
           ELSE 'No Winner'
       END as winner
FROM
    NewYorkExcellentStudents N,
    CaliforniaExcellentStudents C;
