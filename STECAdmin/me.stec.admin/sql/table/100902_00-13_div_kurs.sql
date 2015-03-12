--		
-- #	PackageName	me.stec.admin.logic.org
-- #	MakeComboProvider
--
--				dbType									Caption,									Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--				SchemeName								ClassSummary,								ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE	div_kurs     
 (													' ||  -- #  Курс,								Kurs,				,	    ,                       true
'	div_kurs_id		INT   		  	   	NOT NULL,	' ||  -- #  ИН Курса,							Id
'	name			VARCHAR2(16 CHAR)	NOT NULL,	' ||  -- #	Название курса,						Name,				,	    ,						,   		        ,   	        name
'	CONSTRAINT pk_div_kurs_id     
	PRIMARY KEY ( div_kurs_id ) 
	ENABLE                     
 )											' 
);
CALL pr_autoincrement_add_to('div_kurs');

--------------------------------------------------------------------------------
