--		
-- #	PackageName	me.stec.admin.logic.org
-- #	MakeComboProvider
--
--				dbType															Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--				SchemeName														ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE	div_speciality     
 (														' ||  -- #  Специальность,						Speciality,			,	    ,                       true
'	div_speciality_id	INT 		     	NOT NULL,	' ||  -- #  ИН специальности,					Id
'	name				VARCHAR2(256 CHAR)	NOT NULL,	' ||  -- #	Название специальности,				Name,				,	    ,						,   		        ,   	        name
'	tech_name			VARCHAR2(256 CHAR),				' ||  -- #	Техническое название специальности,	TechName,			,   	false
'	division_id			INT	        		NOT NULL,	' ||  -- #	ИН Подразделения,					IdDivision,			,		false,					true
'	CONSTRAINT fk_div_speciality_division
	FOREIGN KEY (division_id) REFERENCES division (division_id),	' ||
'	CONSTRAINT pk_div_speciality_id     
	PRIMARY KEY ( div_speciality_id ) 
	ENABLE                     
 )											' 
);
CALL pr_autoincrement_add_to('div_speciality');

CALL pr_create_tr_division_biud('div_speciality');
-- select * from division_type;
DECLARE
	m_cnt INT := 0;
BEGIN
	SELECT COUNT(*) INTO m_cnt FROM division_type DT WHERE DT.constant='DIV_SPECIALITY';
	IF m_cnt < 1 THEN
		INSERT  INTO division_type(division_type_id,  constant,       	name,    			table_name)
        		VALUES            (NULL,              'DIV_SPECIALITY', 'Специальность',  	'DIV_SPECIALITY');
		COMMIT;
	END IF;
END;
/

--------------------------------------------------------------------------------
