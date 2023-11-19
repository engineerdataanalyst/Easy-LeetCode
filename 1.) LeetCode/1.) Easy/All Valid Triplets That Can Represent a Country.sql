/* There is a country with three schools, where each student is enrolled in exactly one school.
   The country is joining a competition and wants to select one student from each school to represent the country such that:

   member_A is selected from SchoolA,
   member_B is selected from SchoolB,
   member_C is selected from SchoolC, and
   The selected students' names and IDs are pairwise distinct (i.e. no two students share the same name, and no two students share the same ID).

   Write an SQL query to find all the possible triplets representing the country under the given constraints. */

SELECT
    A.student_name AS member_A,
    B.student_name AS member_B,
    C.student_name AS member_C
FROM SchoolA A
CROSS JOIN SchoolB B
CROSS JOIN SchoolC C
WHERE A.student_name != B.student_name AND
      A.student_name != C.student_name AND
      B.student_name != C.student_name AND
      A.student_id != B.student_id AND
      A.student_id != C.student_id AND
      B.student_id != C.student_id;
