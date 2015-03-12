select CONCAT(
'INSERT INTO div_speciality(div_speciality_id, name, tech_name) VALUES(',
spec_id, ', ',
'\'', (case when name is null then '-' else trim(name) end), '\', ',
'\'', (case when tech_name is null then '-' else trim(tech_name) end), '\');'
) s
from spec
order by spec_id;