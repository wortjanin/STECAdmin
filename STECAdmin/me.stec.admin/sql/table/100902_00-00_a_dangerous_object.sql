-- drop table a_dangerous_object;
CALL pr_create_if_not_exists(
'CREATE TABLE				a_dangerous_object    
 (															' ||
'	a_dangerous_object_id	INT	        		NOT NULL,	' ||
'	object_name				VARCHAR2(30 BYTE)	NOT NULL,	' ||
'	object_type				CHAR(2 BYTE)		NOT NULL,	' ||
'	description				VARCHAR2(512 CHAR)	NOT NULL,	' ||
'	CONSTRAINT ck_a_dangerous_object_type	CHECK	(object_type	IN (''TB'', ''VW'', ''FN'', ''PR'', ''PK'')),	' ||
'	CONSTRAINT uq_a_dangerous_object UNIQUE (	object_name,	object_type),			' ||
'	CONSTRAINT pk_a_dangerous_object_id     
	PRIMARY KEY ( a_dangerous_object_id ) 
	ENABLE                     
 )											' 
);

-- CALL pr_drop_if_exists ('DROP SEQUENCE sq_a_dangerous_object_i ');
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_a_dangerous_object_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');

CREATE OR REPLACE TRIGGER tr_a_dangerous_object_biu 
BEFORE INSERT OR UPDATE ON a_dangerous_object
FOR EACH ROW
DECLARE
  me_obj_name DBA_OBJECTS.OBJECT_NAME%TYPE;
  me_obj_type DBA_OBJECTS.OBJECT_TYPE%TYPE := 
  		(CASE WHEN 'VW' = :NEW.object_type THEN 'VIEW'		ELSE
  		(CASE WHEN 'TB' = :NEW.object_type THEN 'TABLE'		ELSE
  		(CASE WHEN 'FN' = :NEW.object_type THEN 'FUNCTION'	ELSE
  		(CASE WHEN 'PR' = :NEW.object_type THEN 'PROCEDURE'	ELSE
											  	'PACKAGE'  			
  		 END) END) END) END);
BEGIN
	SELECT OBJECT_NAME 	INTO me_obj_name
		FROM DBA_OBJECTS 
   		WHERE 	fn_stec_schema		= OWNER			AND 
      			:NEW.object_name	= OBJECT_NAME	AND
    			me_obj_type			= OBJECT_TYPE;
-- if the NEW.object_name or NEW.object_type are incorrect, there should be an exception	
 IF INSERTING THEN
    SELECT sq_a_dangerous_object_i.NEXTVAL INTO :NEW.a_dangerous_object_id FROM DUAL;
 END IF;
END;
/

CREATE OR REPLACE FUNCTION FN_PLC_A_DANGEROUS_OBJECT_S
(
    p_schema  IN VARCHAR2,
    p_table   IN VARCHAR2
)
RETURN VARCHAR
AS
BEGIN
  RETURN '(1=0)';
END;
/

--  begin
--    dbms_rls.drop_policy(
--      object_schema => fn_stec_schema,
--      object_name => 'A_DANGEROUS_OBJECT',
--      policy_name => 'PLC_A_DANGEROUS_OBJECT_S'
--    );
--  end;
--  /

DECLARE
    ex EXCEPTION; 
    PRAGMA EXCEPTION_INIT ( ex, -28101); 
BEGIN
  sys.dbms_rls.add_policy (
    object_schema     		=> fn_stec_schema,
    object_name      		=> 'A_DANGEROUS_OBJECT',
    policy_name       		=> 'PLC_A_DANGEROUS_OBJECT_S',
    function_schema   		=> fn_stec_schema,
    policy_function   		=> 'FN_PLC_A_DANGEROUS_OBJECT_S',
    statement_types   		=> 'SELECT'
--    update_check      		=> FALSE,
--    sec_relevant_cols		=> dbms_rls.ALL_COLS,
--    sec_relevant_cols_opt	=> dbms_rls.ALL_ROWS
  );
EXCEPTION
	WHEN ex THEN NULL;
END;
/
-- SELECT * FROM a_dangerous_object;
--------------------------------------------------------------------------------
