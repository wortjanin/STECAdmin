--		
-- #	PackageName	me.stec.admin.logic.org
-- #	MakeComboProvider
--
--				dbType											Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--				SchemeName										ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE	div_faculty     
 (													' ||  -- #  Факультет,							Faculty,			,	    ,                       true
'	div_faculty_id	INT  		   	   	NOT NULL,	' ||  -- #  ИН Факультета,						Id
'	name			VARCHAR2(256 CHAR)	NOT NULL,	' ||  -- #	Название факультета,				Name,				,	    ,						,   		        ,   	        name
'	tech_name		VARCHAR2(256 CHAR),				' ||  -- #	Техническое название факультета,	TechName,			,   	false
'	eng_name		VARCHAR2(256 CHAR),				' ||  -- #	Название латиницей,					EngName,			,	   	false
'	division_id		INT	        		NOT NULL,	' ||  -- #	ИН Подразделения,					IdDivision,			,		false,					true
'	CONSTRAINT fk_div_facilty_division
	FOREIGN KEY (division_id) REFERENCES division (division_id),	' ||
'	CONSTRAINT pk_div_faculty_id     
	PRIMARY KEY ( div_faculty_id ) 
	ENABLE                     
 )											' 
);
-- CALL pr_autoincrement_add_to('div_faculty');
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_div_faculty_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');

CALL pr_create_tr_division_biud('div_faculty');
-- select * from division_type;
DECLARE
	m_cnt INT := 0;
BEGIN
	SELECT COUNT(*) INTO m_cnt FROM division_type DT WHERE DT.constant='DIV_FACULTY';
	IF m_cnt < 1 THEN
		INSERT  INTO division_type(constant,       name,         table_name)
		        VALUES            ('DIV_FACULTY',  'Факультет',  'div_faculty');
		COMMIT;
	END IF;
END;
/
--------------------------------------------------------------------------------
