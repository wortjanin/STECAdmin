--		
-- #	PackageName me.stec.admin.logic.user
-- #	MakeComboProvider
--
--							dbType									Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--							SchemeName								ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE				o_good     
 (													' ||  -- #  Категория пользователя,				StecUserCat,	,	    ,                       true
'	o_good_id		INT    				NOT NULL,	' ||  -- #  ИН Категории пользователя,			Id
'	name			VARCHAR2(32 CHAR)	NOT NULL,	' ||  -- #	Категория,							Name,			,	    ,						,   		        ,   	        name
'	division_id		INT		        	NOT NULL,	' ||  -- #	ИН Подразделения,					IdDivision,			,		false,					true
'	CONSTRAINT uq_o_good_name UNIQUE (name),		' ||
'	CONSTRAINT fk_o_good_division
	FOREIGN KEY (division_id) REFERENCES division (division_id),	' ||
'	CONSTRAINT pk_o_good_id     
	PRIMARY KEY ( o_good_id ) 
	ENABLE                     
 )											' 
);

CALL pr_autoincrement_add_to('o_good');

--------------------------------------------------------------------------------
