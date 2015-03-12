CALL pr_create_if_not_exists(
'CREATE TABLE				priv_group_obj    
 (																					' ||
'	priv_group_obj_id	INT	        		NOT NULL,								' ||
'	priv_group_id		INT	        		NOT NULL,								' || 
'	object_id			INT	        		NOT NULL,								' ||
'	object_type_id		INT					NOT NULL,								' ||
'	CONSTRAINT uq_priv_group_obj UNIQUE (priv_group_id, object_id, object_type_id),' ||
'	CONSTRAINT pk_priv_group_obj_id     
	PRIMARY KEY ( priv_group_obj_id ) 
	ENABLE                     
 )											' 
);
CALL pr_autoincrement_add_to('priv_group_obj');

--------------------------------------------------------------------------------
