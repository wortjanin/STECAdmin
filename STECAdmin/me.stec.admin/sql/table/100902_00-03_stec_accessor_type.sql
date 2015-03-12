CALL pr_create_if_not_exists(
'CREATE TABLE				stec_accessor_type    
 (															' ||
'	stec_accessor_type_id	INT	NOT NULL,					' ||
'	constant				VARCHAR2(32 BYTE)	NOT NULL,	' ||
'	name					VARCHAR2(32 CHAR)	NOT NULL,	' ||
'	CONSTRAINT uq_stec_accessor_type_cs UNIQUE (constant),	' ||
'	CONSTRAINT uq_stec_accessor_type_nm UNIQUE (name),		' ||
'	CONSTRAINT pk_stec_accessor_type_id     
	PRIMARY KEY ( stec_accessor_type_id ) 
	ENABLE                     
 )											' 
);
CALL pr_autoincrement_add_to('stec_accessor_type', 'Y');

--------------------------------------------------------------------------------

