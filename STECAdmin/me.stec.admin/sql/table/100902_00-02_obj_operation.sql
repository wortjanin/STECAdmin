CALL pr_create_if_not_exists(
'CREATE TABLE				obj_operation    
 (																' ||
'	obj_operation_id		INT	        		NOT NULL,		' ||
'	obj_operation_set_id	INT	        		NOT NULL,		' ||
'	object_name				VARCHAR2(30 BYTE)	NOT NULL,		' ||
'	object_type				CHAR(2 BYTE)		NOT NULL,		' ||
'	sel						CHAR(1 BYTE)   		DEFAULT ''N'' NOT NULL,	' ||
'	ins						CHAR(1 BYTE)   		DEFAULT ''N'' NOT NULL,	' ||
'	upd						CHAR(1 BYTE)   		DEFAULT ''N'' NOT NULL,	' ||
'	del						CHAR(1 BYTE)   		DEFAULT ''N'' NOT NULL,	' ||
'	exe						CHAR(1 BYTE)   		DEFAULT ''N'' NOT NULL,	' ||
'	CONSTRAINT uq_obj_operation UNIQUE (
		obj_operation_set_id,
		object_name,
		object_type),			' ||
'	CONSTRAINT ck_obj_operation_type	CHECK	(object_type	IN (''TB'', ''VW'', ''FN'', ''PR'', ''PK'')),	' ||
'	CONSTRAINT ck_obj_operation_sel		CHECK	(sel			IN (''Y'', ''N'')),			' ||
'	CONSTRAINT ck_obj_operation_ins		CHECK	(ins			IN (''Y'', ''N'')),			' ||
'	CONSTRAINT ck_obj_operation_upd		CHECK	(upd			IN (''Y'', ''N'')),			' ||
'	CONSTRAINT ck_obj_operation_del		CHECK	(del			IN (''Y'', ''N'')),			' ||
'	CONSTRAINT ck_obj_operation_exe		CHECK	(exe			IN (''Y'', ''N'')),			' ||
'	CONSTRAINT fk_obj_operation_set
	FOREIGN KEY	( obj_operation_set_id )	REFERENCES obj_operation_set	(obj_operation_set_id),	' ||
'	CONSTRAINT pk_obj_operation_id     
	PRIMARY KEY ( obj_operation_id ) 
	ENABLE                     
 )											' 
);

-- CALL pr_drop_if_exists ('DROP SEQUENCE sq_obj_operation_i ');
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_obj_operation_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');

--------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER tr_obj_operation_biud 
BEFORE INSERT OR UPDATE OR DELETE ON obj_operation
FOR EACH ROW
BEGIN
	IF ( NOT (SYS.pkg_stec.fn_my_caller IN ( '<package body ' || fn_stec_schema || '.PKG_STEC_OPERATION_SET>')) )  THEN 
		RAISE_APPLICATION_ERROR(-20001, 'Cannot insert/update/delete directly'); 
	END IF;
	
	IF		INSERTING	THEN
		pkg_stec_operation_set.pr_obj_operation_ck(:NEW.object_type, :NEW.object_name,
			:NEW.sel, :NEW.ins,	:NEW.upd,	:NEW.del,	:NEW.exe);

		IF :NEW.obj_operation_id IS NULL THEN
		    SELECT sq_obj_operation_i.NEXTVAL INTO :NEW.obj_operation_id FROM DUAL;
		END IF;
	ELSIF	UPDATING	THEN
		pkg_stec_operation_set.pr_obj_operation_ck(:NEW.object_type, :NEW.object_name,
			:NEW.sel, :NEW.ins,	:NEW.upd,	:NEW.del,	:NEW.exe);

		IF 	:NEW.object_type <> :OLD.object_type OR 
			:NEW.object_name <> :OLD.object_name THEN
    		RAISE_APPLICATION_ERROR(-20001, 'Cannot change object_type or object_type');
		END IF;
--	ELSIF	DELETING	THEN
	END IF;
END;
/


DECLARE
  m_cnt INT := 0;
BEGIN
  SELECT COUNT(*) INTO m_cnt FROM a_dangerous_object ADO
                  WHERE 'OBJ_OPERATION' = ADO.object_name AND
                        'TB'            = ADO.object_type;
  IF 0 = m_cnt THEN
    INSERT 	INTO a_dangerous_object	(a_dangerous_object_id, object_name, 		object_type, 	description)
          VALUES					(NULL,					'OBJ_OPERATION',	'TB',			'Таблица obj_operation содержит поле object_name (имя объекта БД) и object_type (таблица, функция и т.д.) - имена этих объектов в БД категорически НЕ рекомендуется изменять (иначе придётся заново регенерировать права для всех аксессоров, ссылающихся на эти права задающиеся в obj_operation)');
    COMMIT;   		
  END IF;
END;
/

-- select * from a_dangerous_object;


CREATE OR REPLACE FUNCTION FN_PLC_OBJ_OPERATION_S
(
    p_schema  IN VARCHAR2,
    p_table   IN VARCHAR2
)
RETURN VARCHAR
AS
BEGIN
  IF('SYS' = USER OR p_schema = USER) THEN
    RETURN NULL;
  END IF;
  RETURN '(obj_operation_set_id IN 
			(SELECT OOS.obj_operation_set_id 
				FROM	obj_operation_set OOS 	
		  	)	 																	
		  )';
END;
/

--  begin
--    dbms_rls.drop_policy(
--      object_schema => fn_stec_schema,
--      object_name => 'OBJ_OPERATION_SET',
--      policy_name => 'PLC_OBJ_OPERATION_SET_S'
--    );
--  end;
--  /

BEGIN
  sys.dbms_rls.add_policy (
    object_schema     		=> fn_stec_schema,
    object_name      		=> 'OBJ_OPERATION',
    policy_name       		=> 'PLC_OBJ_OPERATION_S',
    function_schema   		=> fn_stec_schema,
    policy_function   		=> 'FN_PLC_OBJ_OPERATION_S',
    statement_types   		=> 'SELECT',
    update_check      		=> FALSE
--    sec_relevant_cols		=> 'PW',
--    sec_relevant_cols_opt	=> dbms_rls.ALL_ROWS
  );
END;
/

--------------------------------------------------------------------------------

		