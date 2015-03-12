--		
-- #	PackageName	me.stec.admin.logic.org
-- #	MakeComboProvider
--
--				dbType															Caption,							Name(1),			jType,	dbLoadInList,	 	dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--				SchemeName														ClassSummary,						ClassName(1),		,       ,					Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE	div_group_univer     
 (																' ||  -- #  Группа,								GroupUniver,		,	    ,                       true
'	div_group_univer_id	INT		      		NOT NULL,			' ||  -- #  ИН группы,							Id
'	name				VARCHAR2(32 CHAR)	NOT NULL,			' ||  -- #	Название группы,					Name,				,	    ,						,   		        ,   	        name
'	tech_name			VARCHAR2(32 CHAR),						' ||  -- #	Техническое название группы,		TechName,			,   	false
'	division_id			INT	 		       	NOT NULL,			' ||  -- #	ИН Подразделения,					IdDivision,			,		false,					true
'	CONSTRAINT fk_div_group_univer_division
	FOREIGN KEY (division_id) REFERENCES division (division_id),	' ||
'	CONSTRAINT pk_div_group_univer_id     
	PRIMARY KEY ( div_group_univer_id ) 
	ENABLE                     
 )											' 
);
-- CALL pr_autoincrement_add_to('div_group_univer');

CALL pr_create_tr_division_biud('div_group_univer');
-- select * from division_type;
DECLARE
	m_cnt INT := 0;
BEGIN
	SELECT COUNT(*) INTO m_cnt FROM division_type DT WHERE DT.constant='DIV_GROUP_UNIVER';
	IF m_cnt < 1 THEN
    INSERT  INTO division_type(division_type_id,  constant,       		name,    table_name)
            VALUES            (NULL,              'DIV_GROUP_UNIVER',  	'Группа универстета',  'DIV_GROUP_UNIVER');
    COMMIT;
	END IF;
END;
/
--------------------------------------------------------------------------------
