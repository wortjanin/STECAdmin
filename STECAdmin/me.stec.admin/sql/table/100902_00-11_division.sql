CALL pr_create_if_not_exists(
'CREATE TABLE				division    
 (																	' ||
'	division_id			INT	NOT NULL,								' ||
'	division_type_id	INT	NOT NULL,								' ||
'	parent_division_id	INT	DEFAULT NULL,							' ||
'	CONSTRAINT fk_division_type_id
	FOREIGN KEY	( division_type_id )	REFERENCES division_type	(division_type_id),	' ||
'	CONSTRAINT fk_parent_division_id
	FOREIGN KEY	( parent_division_id )	REFERENCES division			(division_id),	' ||
'	CONSTRAINT pk_division_id     
	PRIMARY KEY ( division_id ) 
	ENABLE                     
 )											' 
);
CALL pr_autoincrement_add_to('division');

--------------------------------------------------------------------------------
