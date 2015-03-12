-- drop table temp_privs; 
CALL pr_create_if_not_exists(
'CREATE GLOBAL TEMPORARY TABLE				temp_privs     
 (													' ||
'	obj				VARCHAR2(30 BYTE)	NOT NULL,	' || 
'	obj_type		VARCHAR2(19 BYTE)			,	' || 
'	priv			VARCHAR2(40 BYTE)	NOT NULL,	' || 
'	gr				VARCHAR2( 3 BYTE)				' || -- GRANTABLE (==ADMIN_OPTION)
' )	ON COMMIT PRESERVE ROWS										' 
);
--------------------------------------------------------------------------------
