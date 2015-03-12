--	PROCEDURE pr_create_transact(
--		in_stec_user_id			IN	stec_user	.stec_user_id		%TYPE,
--		in_stec_accessor_id		IN	stec_user	.stec_accessor_id	%TYPE DEFAULT NULL,
--		in_surname    			IN  stec_user	.surname			%TYPE,
--		in_name       			IN  stec_user	.name				%TYPE,
--		in_patronymic 			IN  stec_user	.patronymic			%TYPE,
--		in_gender     			IN  stec_user	.gender				%TYPE,
--		in_stec_user_cat_id		IN	stec_user	.stec_user_cat_id	%TYPE DEFAULT 0,
--		in_pw		   			IN  stec_login	.pw					%TYPE DEFAULT NULL,
--		in_blocked				IN	stec_login	.blocked			%TYPE DEFAULT 'Y'
--	);


SELECT
  CONCAT (
    'pkg_stec_account.pr_create_transact(',
    student_id, ', ',
    'NULL, ',
    '\'',
      (case
        when isnull(replace(trim(surname), ' ', '-'))
        then 'Фамилия'
        else replace(trim(surname), ' ', '-')
       end),
    '\', ',
    '\'',
      (case
        when isnull(replace(trim(name),    ' ', '-'))
        then '-'
        else replace(trim(name), ' ', '-')
       end),
    '\', ',
    '\'',
      (case
        when isnull(replace(replace(trim(otch), '"', ''), ' ', '-'))
        then '-'
        else replace(replace(trim(otch), '"', ''), ' ', '-')
       end),
    '\', ',
    '\'',
      (case
        when 0 = gender
        then (case when RIGHT(replace(trim(otch), '"', ''), 3) like 'вна' then 'W' else 'M' end)
        else (case when 1=gender then 'M' else 'W' end)
       end),
    '\', ',
      (case when category IS NULL then 0 else category end),
    ');'
        ) s
from user
where (
(name is null or surname is null or otch is null) or
(UPPER(name) not rlike '^[А-Я]+$' and UPPER(name) not like '%Ё%') or
(UPPER(surname) not rlike '^[А-Я]+$' and UPPER(surname) not like '%Ё%') or
(UPPER(otch) not rlike '^[А-Я]+$' and UPPER(otch) not like '%Ё%')
) IS TRUE
order by student_id;
