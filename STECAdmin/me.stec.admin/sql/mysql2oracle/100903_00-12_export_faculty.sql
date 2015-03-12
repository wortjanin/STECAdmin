select CONCAT(
'INSERT INTO div_faculty(div_faculty_id, name, tech_name, eng_name) VALUES(',
faculty_id, ', ',
'\'', (case when name is null then '-' else trim(name) end), '\', ',
'\'', (case when tech_name is null then '-' else trim(tech_name) end), '\', ',
'\'', (case when eng_name is null then '-' else trim(eng_name) end), '\');'
) s
from faculty order by faculty_id;