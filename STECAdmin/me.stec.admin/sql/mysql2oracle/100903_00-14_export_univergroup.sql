select CONCAT(
'INSERT INTO div_group_univer(div_group_univer_id, name, tech_name) VALUES(',
univergroup_id, ', ',
'\'', substr(name, 8), '\', ',
'\'', tech_name, '\');'
) s
from `univergroup` order by univergroup_id;