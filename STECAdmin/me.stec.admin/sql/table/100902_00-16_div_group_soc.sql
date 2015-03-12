--		
-- #	PackageName	me.stec.admin.logic.org
-- #	MakeComboProvider
--
--				dbType															Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--				SchemeName														ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE	div_group_soc     
 (														' ||  -- #  Социальная Группа,					GroupSoc,			,	    ,                       true
'	div_group_soc_id	INT 		     	NOT NULL,	' ||  -- #  ИН группы,							Id
'	name				VARCHAR2(32 CHAR)	NOT NULL,	' ||  -- #	Название группы,					Name,				,	    ,						,   		        ,   	        name
'	tech_name			VARCHAR2(32 CHAR),				' ||  -- #	Техническое название группы,		TechName,			,   	false
'	division_id			INT		        	NOT NULL,	' ||  -- #	ИН Подразделения,					IdDivision,			,		false,					true
'	CONSTRAINT fk_div_group_soc_division
	FOREIGN KEY (division_id) REFERENCES division (division_id),	' ||
'	CONSTRAINT pk_div_group_soc_id     
	PRIMARY KEY ( div_group_soc_id ) 
	ENABLE                     
 )											' 
);
-- CALL pr_autoincrement_add_to('div_group_soc');

CALL pr_create_tr_division_biud('div_group_soc');
-- select * from division_type;
DECLARE
	m_cnt INT := 0;
BEGIN
	SELECT COUNT(*) INTO m_cnt FROM division_type DT WHERE DT.constant='DIV_GROUP_SOC';
	IF m_cnt < 1 THEN
		INSERT  INTO division_type(division_type_id,  constant,       		name,    table_name)
        		VALUES            (NULL,              'DIV_GROUP_SOC',  	'Группа социальная',  'DIV_GROUP_SOC');
		COMMIT;
	END IF;
END;
/

--------------------------------------------------------------------------------

