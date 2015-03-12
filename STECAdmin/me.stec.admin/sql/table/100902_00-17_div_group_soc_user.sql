--		
-- #	PackageName	me.stec.admin.logic.org
-- #	MakeComboProvider
--
--				dbType															Caption,							Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--				SchemeName														ClassSummary,						ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE	div_group_soc_user     
 (																			' ||  -- #  Социальная Группа,					GroupSoc,			,	    ,                       true
'	div_group_soc_user_id	INT      		NOT NULL,						' ||  -- #  ИН группы,							Id
'	div_group_soc_id		INT      		NOT NULL,						' ||  -- #  ИН группы,							Id
'	stec_user_id			INT      		NOT NULL,						' ||  -- #  ИН группы,							Id
'	CONSTRAINT uq_div_group_soc_user UNIQUE (div_group_soc_id, stec_user_id),	' ||
'	CONSTRAINT fk_div_group_soc_user_soc
	FOREIGN KEY  (div_group_soc_id) REFERENCES div_group_soc (div_group_soc_id),	' ||
'	CONSTRAINT fk_div_group_soc_user_usr
	FOREIGN KEY (stec_user_id) REFERENCES stec_user (stec_user_id),	' ||
'	CONSTRAINT pk_div_group_soc_user_id     
	PRIMARY KEY ( div_group_soc_user_id ) 
	ENABLE                     
 )											' 
);
CALL pr_autoincrement_add_to('div_group_soc_user');

--------------------------------------------------------------------------------
