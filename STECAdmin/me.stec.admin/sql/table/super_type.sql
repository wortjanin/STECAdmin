--		
-- #	PackageName me.stec.admin.logic.user
-- #	MakeComboProvider
--
--							dbType									Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--							SchemeName								ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE				super_type     
 (														' ||  -- #  Категория пользователя,				StecUserCat,	,	    ,                       true
'	super_type_id		INT        			NOT NULL,	' ||  -- #  ИН Категории пользователя,			Id
'	constant			VARCHAR2(32 BYTE)	NOT NULL,	' ||  -- #	Константа,							Constant,		,	    ,						,   		        ,   	        true
'	name				VARCHAR2(32 CHAR)	NOT NULL,	' ||  -- #	Категория,							Name,			,	    ,						,   		        ,   	        name
'	CONSTRAINT uq_super_type_cnst UNIQUE (constant),	' ||
'	CONSTRAINT uq_super_type_name UNIQUE (name),		' ||
'	CONSTRAINT pk_super_type_id     
	PRIMARY KEY ( super_type_id ) 
	ENABLE                     
 )											' 
);


CALL pr_autoincrement_add_to('super_type');
