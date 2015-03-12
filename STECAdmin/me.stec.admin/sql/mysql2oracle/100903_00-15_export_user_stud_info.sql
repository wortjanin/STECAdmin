select CONCAT(
'INSERT INTO info_stud(info_stud_id, stec_user_id, div_kurs_id, div_faculty_id, div_speciality_id, div_group_univer_id) VALUES(',
'NULL, ',
student_id, ', ',
kurs_id, ', ',
faculty_id, ', ',
spec_id, ', ',
univergroup_id, ');'
) s
from user where not (student_id is null or kurs_id is null or faculty_id is null or spec_id is null or univergroup_id is null)
order by student_id;