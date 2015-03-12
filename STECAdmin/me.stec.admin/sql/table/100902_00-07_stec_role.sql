CALL pr_create_if_not_exists(
'CREATE TABLE				stec_role    
 (																' ||
'	stec_role_id			INT	        		NOT NULL,		' ||
'	name					VARCHAR2(64 CHAR)	NOT NULL,		' ||
'	master_stec_role_id		INT	        		DEFAULT NULL,	' ||
'	stec_accessor_id		INT        			NOT NULL,		' ||  -- #	ИН Аксессора,					IdAccessor,			,		false,					true
'	CONSTRAINT uq_stec_role_name UNIQUE (name),					' ||
'	CONSTRAINT fk_stec_role_master_id
	FOREIGN KEY (master_stec_role_id) 	REFERENCES stec_role		(stec_role_id),	' ||
'	CONSTRAINT fk_stec_role_acc_id
	FOREIGN KEY (stec_accessor_id) 		REFERENCES stec_accessor	(stec_accessor_id),	' ||
'	CONSTRAINT pk_stec_role_id     
	PRIMARY KEY ( stec_role_id ) 
	ENABLE                     
 )											' 
);

-- CALL pr_drop_if_exists ('DROP SEQUENCE sq_stec_role_i ');
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_stec_role_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER tr_stec_role_biud 
BEFORE INSERT OR UPDATE OR DELETE ON stec_role
FOR EACH ROW
DECLARE
	m_tp_id stec_accessor_type.stec_accessor_type_id%TYPE;
	m_cnt	INT := 0;
BEGIN
	IF ( NOT (SYS.pkg_stec.fn_my_caller IN ( '<package body ' || pkg_stec_session.fn_schema || '.PKG_STEC_ACCESS>')) )  THEN 
		RAISE_APPLICATION_ERROR(-20001, 'Cannot insert/update/delete directly'); 
	END IF;
	
	IF    INSERTING THEN
		pkg_stec_access.pr_ck_effective_master_role( :NEW.master_stec_role_id );

		SELECT SAT.stec_accessor_type_id 	INTO m_tp_id FROM stec_accessor_type SAT
											WHERE SAT.constant = 'SAT_ROLE';
		INSERT INTO stec_accessor(stec_accessor_id, 		stec_accessor_type_id) 
		VALUES					 (:NEW.stec_accessor_id,	m_tp_id);
		IF :NEW.stec_accessor_id IS NULL THEN
			SELECT sq_stec_accessor_i.CURRVAL INTO :NEW.stec_accessor_id FROM DUAL;
		END IF;

		IF :NEW.stec_role_id IS NULL THEN
			SELECT sq_stec_role_i.NEXTVAL INTO :NEW.stec_role_id FROM DUAL;
		END IF;
		
	ELSIF UPDATING THEN
		IF NOT pkg_stec_access.fn_i_am_master_of_role(:OLD.stec_role_id) THEN
			RAISE_APPLICATION_ERROR(-20003, 'You have no rights to update this record');
		END IF;

		IF (:OLD.stec_role_id		<> :NEW.stec_role_id OR
			:OLD.stec_accessor_id 	<> :NEW.stec_accessor_id) THEN
			RAISE_APPLICATION_ERROR(-20001, 'You cannot change stec_role_id and stec_accessor_id');
		END IF;

		IF 	pkg_stecu.ineq(:OLD.master_stec_role_id, :NEW.master_stec_role_id)	THEN
		
			pkg_stec_access.pr_ck_effective_master_role( :NEW.master_stec_role_id );

			-- we can change master of the role only if it has no slave accessors
			SELECT COUNT(*) INTO m_cnt
				FROM division_access DA, stec_role SR
				WHERE 	:OLD.master_stec_role_id	= SR.stec_role_id		AND
						DA.stec_accessor_id			= SR.stec_accessor_id;
			IF m_cnt > 0 THEN
				RAISE_APPLICATION_ERROR(-20001, 'You cannot change master_stec_role_id of the role as it has slave accessors');
			END IF;
					
			-- new master should have grantable privileges
			SELECT COUNT(*) INTO m_cnt
				FROM division_access DA, stec_role SR
				WHERE 	:NEW.master_stec_role_id	= SR.stec_role_id		AND
						DA.stec_accessor_id			= SR.stec_accessor_id	AND
						DA.is_grantable				= 'Y';
			IF m_cnt < 1 THEN
				RAISE_APPLICATION_ERROR(-20001, 'You cannot change master_stec_role_id of the role as new master has no grantable privileges');
			END IF;

		END IF;
			
		
	ELSIF DELETING THEN
	
		IF NOT pkg_stec_access.fn_i_am_master_of_role(:OLD.stec_role_id) THEN
			RAISE_APPLICATION_ERROR(-20003, 'You have no rights to delete this record ');
		END IF;
		
		DELETE FROM stec_accessor SA WHERE SA.stec_accessor_id = :OLD.stec_accessor_id;
		
	END IF;

END;
/

--------------------------------------------------------------------------------
