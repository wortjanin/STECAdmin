CALL pr_create_if_not_exists(
'CREATE TABLE				stec_accessor    
 (											' ||
'	stec_accessor_id		INT	NOT NULL,	' ||
'	stec_accessor_type_id	INT	NOT NULL,	' ||
'	CONSTRAINT fk_stec_accessor_tp
	FOREIGN KEY (stec_accessor_type_id) REFERENCES stec_accessor_type (stec_accessor_type_id),	' ||
'	CONSTRAINT pk_stec_accessor_id     
	PRIMARY KEY ( stec_accessor_id ) 
	ENABLE                     
 )											' 
);
CALL pr_autoincrement_add_to('stec_accessor');

--------------------------------------------------------------------------
