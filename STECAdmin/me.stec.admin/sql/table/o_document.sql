--		
-- #	PackageName me.stec.admin.logic.user
-- #	MakeComboProvider
--
--							dbType									Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--							SchemeName								ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE				o_document     
 (													' ||  -- #  Категория пользователя,				StecUserCat,	,	    ,                       true
'	o_document_id	INT    				NOT NULL,	' ||  -- #  ИН Категории пользователя,			Id
'	name			VARCHAR2(64 CHAR)	NOT NULL,	' ||  -- #	Категория,							Name,			,	    ,						,   		        ,   	        name
'	body			VARCHAR2(1024 CHAR)	NOT NULL,	' ||  -- #	Категория,							Name,			,	    ,						,   		        ,   	        name
'	date_creation	DATE				NOT NULL,	' ||  -- #	Категория,							Name,			,	    ,						,   		        ,   	        name
'	date_approval	DATE			DEFAULT NULL,	' ||  -- #	Категория,							Name,			,	    ,						,   		        ,   	        name
'	division_id		INT		        	NOT NULL,	' ||  -- #	ИН Подразделения,					IdDivision,			,		false,					true
'	CONSTRAINT ck_o_document_date	CHECK	((date_approval IS NULL) OR	(date_approval >= date_creation)),			' ||
'	CONSTRAINT fk_o_o_document_division
	FOREIGN KEY (division_id) REFERENCES division (division_id),	' ||
'	CONSTRAINT pk_o_document_id     
	PRIMARY KEY ( o_document_id ) 
	ENABLE                     
 )											' 
);

CALL pr_autoincrement_add_to('o_document');

--------------------------------------------------------------------------------
