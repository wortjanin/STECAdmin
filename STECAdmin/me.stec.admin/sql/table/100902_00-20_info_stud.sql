--		
-- #	PackageName me.stec.admin.logic.user
--							dbType									Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--							SchemeName								ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE				info_stud     
 (														' ||  -- #  Информация студента,				StudInfo,			,	    ,                       true
'	info_stud_id			INT   			NOT NULL,	' ||  -- #  ИН информации студента,				Id
'	stec_user_id			INT	        	NOT NULL,	' ||  -- #  ИН пользователя,					IdStecUser
'	div_kurs_id				INT	        	NOT NULL,	' ||  -- #  ИН Курса,							IdKurs
'	div_faculty_id			INT	        	NOT NULL,	' ||  -- #  ИН факультета,						IdFaculty
'	div_speciality_id		INT	        	NOT NULL,	' ||  -- #  ИН специальности,					IdSpeciality
'	div_group_univer_id		INT	        	NOT NULL,	' ||  -- #  ИН группы,							IdStecGroup
'	CONSTRAINT uq_info_stud UNIQUE (stec_user_id),		' ||
'	CONSTRAINT fk_info_stud_user
	FOREIGN KEY (stec_user_id)			REFERENCES stec_user		(stec_user_id),			' ||
'	CONSTRAINT fk_info_stud_kurs
	FOREIGN KEY (div_kurs_id)			REFERENCES div_kurs			(div_kurs_id),				' ||
'	CONSTRAINT fk_info_stud_faculty
	FOREIGN KEY (div_faculty_id)		REFERENCES div_faculty		(div_faculty_id),			' ||
'	CONSTRAINT fk_info_stud_speciality
	FOREIGN KEY (div_speciality_id)		REFERENCES div_speciality	(div_speciality_id),		' ||
'	CONSTRAINT fk_info_stud_group
	FOREIGN KEY (div_group_univer_id)	REFERENCES div_group_univer	(div_group_univer_id),		' ||
'	CONSTRAINT pk_info_stud_id     
	PRIMARY KEY ( info_stud_id ) 
	ENABLE                     
 )											' 
);
CALL pr_autoincrement_add_to('info_stud');

--------------------------------------------------------------------------------
