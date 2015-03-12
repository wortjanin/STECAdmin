--	
-- #	PackageName		me.stec.admin.logic.user
--
-- #	Sequence		sq_stec_user_i	
--
--												Caption,			Name(1),		jType,			dbLoadInList, 	dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull,	isMinMax
--
--					   SchemeName				ClassSummary,		ClassName(1),	,       		,				Scheme.ReadOnly
-- select fn_stec_schema from dual;
CREATE OR REPLACE VIEW vw_stec_stud AS
SELECT  								-- #	Студент,			Student,		,				,				true
SU.stec_user_id,  						-- #	ИН Студента,		Id 
SU.surname,								-- #	Фамилия,			Surname
SU.name,								-- #	Имя,				Name
SU.patronymic,							-- #	Отчество,			Patronymic
SU.gender,								-- #	Пол,				Gender,			EGender
SU.login, 								-- #	Логин,				Login
SU.pw,									-- #	Пароль,				Password,		,				false,			,					true
SU.pw_is_temp,							-- #	Пароль временный,	PassIsTemp,		EYN,			,				true
K.name kurs,							-- #  	Курс,				Kurs,			,	    		,          		true
F.name faculty,							-- #  	Факультет,			Faculty,		,	    		,          		true
S.name speciality,						-- #	Специальность,		Speciality,		,	    		,	        	true							
SG.name group_univer,					-- #	Группа,				GroupUniver,	,	    		,           	true
SI.div_kurs_id,							-- #	ИН Курса,			IdKurs,			,	    		false
F.div_faculty_id,						-- #  	ИН Факультета,		IdFaculty,		,	    		false
S.div_speciality_id,					-- #	ИН Специальности,	IdSpeciality,	,	    		false							
SG.div_group_univer_id					-- #	ИН Группы,			IdStecGroup,	,	    		false
FROM 	vw_stec_user 	SU, 
		info_stud		SI, 
		div_kurs		K, 
		div_faculty		F, 
		div_speciality	S, 
		div_group_univer	SG
WHERE (
	SU.cat_id				= 0						AND
	SU.stec_user_id 		= SI.stec_user_id		AND 
	SI.div_kurs_id			= K .div_kurs_id		AND
	SI.div_faculty_id		= F .div_faculty_id		AND
	SI.div_speciality_id 	= S .div_speciality_id	AND
	SI.div_group_univer_id 	= SG.div_group_univer_id		);

--------------------------------------------------------------------------------
