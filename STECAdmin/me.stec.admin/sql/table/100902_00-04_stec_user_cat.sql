--		
-- #	PackageName me.stec.admin.logic.user
-- #	MakeComboProvider
--
--							dbType									Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--							SchemeName								ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE				stec_user_cat     
 (															' ||  -- #  Категория пользователя,				StecUserCat,	,	    ,                       true
'	stec_user_cat_id		INT        			NOT NULL,	' ||  -- #  ИН Категории пользователя,			Id
'	constant				VARCHAR2(32 BYTE)	NOT NULL,	' ||  -- #	Константа,							Constant,		,	    ,						,   		        ,   	        true
'	name					VARCHAR2(32 CHAR)	NOT NULL,	' ||  -- #	Категория,							Name,			,	    ,						,   		        ,   	        name
'	CONSTRAINT uq_stec_user_cat_cnst UNIQUE (constant),		' ||
'	CONSTRAINT uq_stec_user_cat_name UNIQUE (name),			' ||
'	CONSTRAINT pk_stec_user_cat_id     
	PRIMARY KEY ( stec_user_cat_id ) 
	ENABLE                     
 )											' 
);
-- '	CONSTRAINT ck_stec_user_cat_name CHECK (name IN (''Студент'', ''Работник'', ''Администратор'')),	' ||

CALL pr_autoincrement_add_to('stec_user_cat');

--------------------------------------------------------------------------
