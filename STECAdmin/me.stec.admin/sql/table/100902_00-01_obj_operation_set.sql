CALL pr_create_if_not_exists(
'CREATE TABLE				obj_operation_set    
 (																	' ||
'	obj_operation_set_id	INT	        		NOT NULL,			' ||
'	constant				VARCHAR2(64 BYTE)	NOT NULL,			' ||
'	name					VARCHAR2(64 CHAR)	NOT NULL,			' ||
'	CONSTRAINT ck_obj_operation_set		CHECK	(obj_operation_set_id >= 0),			' ||
'	CONSTRAINT uq_obj_operation_set_c UNIQUE (constant),			' ||
'	CONSTRAINT uq_obj_operation_set_n UNIQUE (name),				' ||
'	CONSTRAINT pk_obj_operation_set_id     
	PRIMARY KEY ( obj_operation_set_id ) 
	ENABLE                     
 )											' 
);

CALL pr_create_if_not_exists('CREATE SEQUENCE sq_obj_operation_set_i START WITH 1 INCREMENT BY 1 NOMAXVALUE');

--------------------------------------------------------------------------------

-- constant =
--	OSET_ACCESS
--	OSET_PASSWORD_CHANGE
--  OSET_MANAGER_DOCUMENTS
--  OSET_MANAGER_GOODS
--  OSET_ADD_NEWS

CREATE OR REPLACE TRIGGER tr_obj_operation_set_biud 
BEFORE INSERT OR UPDATE OR DELETE ON obj_operation_set
FOR EACH ROW
BEGIN
	IF ( NOT (SYS.pkg_stec.fn_my_caller IN ( '<package body ' || fn_stec_schema || '.PKG_STEC_OPERATION_SET>')) )  THEN 
		RAISE_APPLICATION_ERROR(-20001, 'Cannot insert/update/delete directly'); 
	END IF;
	
	IF		INSERTING THEN
		IF :NEW.obj_operation_set_id IS NULL THEN
			SELECT sq_obj_operation_set_i.NEXTVAL INTO :NEW.obj_operation_set_id FROM DUAL;
		END IF;
	ELSIF 	UPDATING THEN
		IF (:NEW.obj_operation_set_id <> :OLD.obj_operation_set_id) THEN
			RAISE_APPLICATION_ERROR(-20001, 'Cannot update, FALSE == ( :NEW.obj_operation_set_id <> :OLD.obj_operation_set_id ), see tr_obj_operation_set_bu trigger ');
		END IF;
--	ELSIF	DELETING THEN
	END IF;
END;
/


CREATE OR REPLACE FUNCTION FN_PLC_OBJ_OPERATION_SET_S
(
    p_schema  IN VARCHAR2,
    p_table   IN VARCHAR2
)
RETURN VARCHAR
AS
BEGIN
  RETURN '(obj_operation_set_id IN 
			(SELECT DA.obj_operation_set_id 
				FROM	division_access DA,
						stec_role		SR, 
						stec_role_user 	SRU 
					WHERE (	DA.stec_accessor_id = pkg_stec_account.fn_stec_user_acc_id	) 	OR
						  (	SRU.stec_user_id	= pkg_stec_account.fn_stec_user_id 	AND
							SRU.stec_role_id	= SR.stec_role_id 					AND 
							SR.stec_accessor_id	= DA.stec_accessor_id					) 	  	
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
    object_name      		=> 'OBJ_OPERATION_SET',
    policy_name       		=> 'PLC_OBJ_OPERATION_SET_S',
    function_schema   		=> fn_stec_schema,
    policy_function   		=> 'FN_PLC_OBJ_OPERATION_SET_S',
    statement_types   		=> 'SELECT',
    update_check      		=> FALSE,
--    sec_relevant_cols		=> 'PW',
--    sec_relevant_cols_opt	=> dbms_rls.ALL_ROWS
  );
END;
/


--------------------------------------------------------------------------------
