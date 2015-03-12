-- NOTE! 	If you plan to execute some single operation (DELETE, UPDATE, INSERT)
--			or a transaction of cascade operations on table division_access
-- 			DO NOT FORGET TO LOCK SEMAPHORE WITH THE LOCK_NAME := <fn_stec_schema || '_change_division_access'>
--			BEFORE THE EXECUTION OF THE OPERATIONS
--			!AND RELEASE THE SEMAPHORE right after the execution
--			(otherwise you are going to break the chain of operations executed by you and/or someone else)
--	
--		use the following logic for the lock:
--
--			lock_name := fn_stec_schema || '_CHANGE_DIVISION_ACCESS';
--			DBMS_LOCK.ALLOCATE_UNIQUE(lock_name, lock_id); 
--			code := DBMS_LOCK.REQUEST(lock_id, DBMS_LOCK.X_MODE);
--				
--			IF 0 = code THEN 
--				<the operations>
--		    ELSE     
--				RAISE lock_exists;
--			END IF;
--		
--			code := DBMS_LOCK.RELEASE(lock_id);

-- temp_login_block works here only if stec_accessor_id is a user
-- (if it is a role, we should use stec_role_user.temp_login_block)
CALL pr_create_if_not_exists(
'CREATE TABLE	division_access  
 (															' ||
'	division_access_id		INT      		NOT NULL,		' ||
'	stec_accessor_id		INT      		NOT NULL,		' ||
'	master_stec_role_id		INT      		DEFAULT NULL,	' ||
'	obj_operation_set_id	INT      		NOT NULL,		' ||
'	division_id				INT	       		DEFAULT NULL,	' ||
'	is_grantable			CHAR(1 BYTE)   	DEFAULT ''N'' NOT NULL,	' ||
'	temp_login_block		CHAR(1 BYTE)   	NOT NULL,	' ||
'	CONSTRAINT ck_division_access_gr	CHECK	(is_grantable		IN (''Y'', ''N'')),			' ||
'	CONSTRAINT ck_division_access_blk	CHECK	(temp_login_block	IN (''Y'', ''N'')),			' ||
'	CONSTRAINT uq_division_access	UNIQUE	(stec_accessor_id, obj_operation_set_id),			' ||
'	CONSTRAINT fk_division_access_ac
	FOREIGN KEY (stec_accessor_id) 			REFERENCES stec_accessor		(stec_accessor_id),	' ||
'	CONSTRAINT fk_division_access_mr
	FOREIGN KEY (master_stec_role_id)	 	REFERENCES stec_role			(stec_role_id),	' ||
'	CONSTRAINT fk_division_access_set
	FOREIGN KEY (obj_operation_set_id) 		REFERENCES obj_operation_set	(obj_operation_set_id),	' ||
'	CONSTRAINT fk_division_access_division
	FOREIGN KEY (division_id) 				REFERENCES division				(division_id),	' ||
'	CONSTRAINT pk_division_access_id     
	PRIMARY KEY ( division_access_id ) 
	ENABLE                     
 )											' 
);

-- CALL pr_drop_if_exists ('DROP SEQUENCE sq_division_access_i ');
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_division_access_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER tr_division_access_biud 
BEFORE INSERT OR UPDATE OR DELETE ON division_access
FOR EACH ROW
DECLARE
	m_tp 		stec_accessor_type.constant%TYPE;
	m_rl_id		stec_role.stec_role_id%TYPE;
	m_master_id	stec_role.stec_role_id%TYPE;
	m_cnt		INT := 0;
BEGIN
	IF ( NOT (SYS.pkg_stec.fn_my_caller IN ( '<package body ' || pkg_stec_session.fn_schema || '.PKG_STEC_ACCESS>')) )  THEN 
		RAISE_APPLICATION_ERROR(-20001, 'Cannot insert/update/delete directly'); 
	END IF;
	
	IF    	INSERTING	THEN
		pkg_stec_access.pr_ck_role_can_give_access(:NEW.master_stec_role_id, :NEW.obj_operation_set_id);

		-- get the accesor type
		SELECT SAT.constant 	INTO m_tp 
			FROM stec_accessor SA, stec_accessor_type SAT
			WHERE 	SA.stec_accessor_id			= :NEW.stec_accessor_id		AND
					SA.stec_accessor_type_id	= SAT.stec_accessor_type_id;  
		
		-- the accessor is a role. Before the grantage we should get the genealogy of this role
		-- If the role is our master (direct or indirect), we should generate an exception
		-- if the value of master_stec_role_id
		IF 'SAT_ROLE' = m_tp THEN
		
			IF :NEW.temp_login_block <> 'N' THEN
				RAISE_APPLICATION_ERROR(-20001, 'FAULT: role cannot be blocked');
			END IF;
			SELECT SR.stec_role_id INTO m_rl_id FROM stec_role SR
				WHERE SR.stec_accessor_id = :NEW.stec_accessor_id;
			IF pkg_stec_access.fn_role_is_my_master(m_rl_id) THEN
				RAISE_APPLICATION_ERROR(-20003, 'FAULT: The accessor is a master role (direct or indirect)');
			END IF;
			
			IF (NOT pkg_stec_access.fn_i_am_master_of_role(m_rl_id)) THEN
				RAISE_APPLICATION_ERROR(-20003, 'FAULT: You are not a master of the accessor role (direct or indirect)');
			END IF;

			SELECT SR.master_stec_role_id INTO m_master_id
				FROM stec_role SR
				WHERE	SR.stec_role_id = m_rl_id;
				
			IF pkg_stecu.ineq(m_master_id, :NEW.master_stec_role_id) THEN
				RAISE_APPLICATION_ERROR(-20001, 'FAULT: Attemt to make a hybrid role (with 2 masters, i.e. with an undefined master)');
			END IF;

		ELSIF 'SAT_USER' = m_tp THEN
		
			IF 'N' <> :NEW.is_grantable THEN
				RAISE_APPLICATION_ERROR(-20003, 'FAULT: you cannot give a grantable access to a user directly (use a role for that or assign is_grantable to ''N'')');	
			END IF;

		END IF;

		IF :NEW.division_access_id IS NULL THEN
			SELECT sq_division_access_i.NEXTVAL INTO :NEW.division_access_id FROM DUAL;
		END IF;
		
	ELSIF	UPDATING	THEN
		pkg_stec_access.pr_ck_role_can_give_access(:NEW.master_stec_role_id, :NEW.obj_operation_set_id);

		IF 	(:NEW.stec_accessor_id <>	:OLD.stec_accessor_id) 						OR 
	        pkg_stecu.ineq(:NEW.master_stec_role_id,	:OLD.master_stec_role_id)	OR 
        	(:NEW.obj_operation_set_id <>		:OLD.obj_operation_set_id)				THEN
			RAISE_APPLICATION_ERROR(-20001, 'FAULT: you can update only division_id AND is_grantable ');	
		END IF;
	
		IF 	:NEW.is_grantable	<> :OLD.is_grantable THEN

			-- get the accesor type
			SELECT SAT.constant 	INTO m_tp 
				FROM stec_accessor SA, stec_accessor_type SAT
				WHERE 	SA.stec_accessor_id			= :OLD.stec_accessor_id		AND
						SA.stec_accessor_type_id	= SAT.stec_accessor_type_id;  
			
			-- the accessor is a role. Before the grantage we should get the genealogy of this role
			-- If the role is our master (direct or indirect), we should generate an exception
			-- if the value of master_stec_role_id
			IF 'SAT_ROLE' = m_tp THEN
			
				SELECT SR.stec_role_id INTO m_rl_id FROM stec_role SR
					WHERE SR.stec_accessor_id = :OLD.stec_accessor_id;
					
				IF 'N' = :NEW.is_grantable THEN
					-- !!!!!!!check, that all slave roles of the m_rl_id has 'N'=is_grantable
					SELECT COUNT(*) INTO m_cnt
							FROM	division_access DAc, 
									stec_role	SR
							WHERE	DAc.stec_accessor_id	= SR.stec_accessor_id	AND
									DAc.master_stec_role_id	= m_rl_id				AND
									DAc.is_grantable		= 'Y';
					IF m_cnt > 0 THEN
						RAISE_APPLICATION_ERROR(-20001, 'FAULT: slave roles of the accessor role must be non-grantable to make the accessor role non-grantable');
					END IF;
				END IF;
				
			ELSIF 'SAT_USER' = m_tp THEN
			
				RAISE_APPLICATION_ERROR(-20001, 'FAULT: you can not change is_grantable for a user ');
			
			END IF;
		END IF;
	
	ELSIF	DELETING	THEN
		pkg_stec_access.pr_ck_role_can_give_access(:OLD.master_stec_role_id, :OLD.obj_operation_set_id);

		-- get the accesor type
		SELECT SAT.constant 	INTO m_tp 
			FROM stec_accessor SA, stec_accessor_type SAT
			WHERE 	SA.stec_accessor_id			= :OLD.stec_accessor_id		AND
					SA.stec_accessor_type_id	= SAT.stec_accessor_type_id;  
	
		IF 'SAT_ROLE' = m_tp THEN
		
			SELECT SR.stec_role_id INTO m_rl_id FROM stec_role SR
				WHERE SR.stec_accessor_id = :OLD.stec_accessor_id;
				
			SELECT COUNT(*) INTO m_cnt
							FROM	division_access DAc, 
									stec_role	SR
							WHERE	DAc.master_stec_role_id		= m_rl_id					AND
									DAc.obj_operation_set_id	= :OLD.obj_operation_set_id;
			IF m_cnt > 0 THEN
				RAISE_APPLICATION_ERROR(-20001, 'FAULT: slave roles of the accessor role must NOT contain the obj_operation_set before the deletion');
			END IF;
		
--		ELSIF 'SAT_USER' = m_tp THEN
		END IF;
	
	END IF;
	
END;
/

--------------------------------------------------------------------------------------
