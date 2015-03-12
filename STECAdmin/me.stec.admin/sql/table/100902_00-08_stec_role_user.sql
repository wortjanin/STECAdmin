CALL pr_create_if_not_exists(
'CREATE TABLE				stec_role_user    
 (																		' ||
'	stec_role_user_id		INT	        		NOT NULL,				' ||
'	stec_role_id			INT	        		NOT NULL,				' ||
'	stec_user_id			INT	        		NOT NULL,				' ||
'	temp_login_block		CHAR(1 BYTE)   		DEFAULT ''N'' NOT NULL,			' ||
'	CONSTRAINT ck_stec_role_user_bl	CHECK	(temp_login_block	IN (''Y'', ''N'')),			' ||
'	CONSTRAINT uq_stec_role_user UNIQUE (stec_role_id, stec_user_id),	' ||
'	CONSTRAINT fk_stec_role_user_rl
	FOREIGN KEY (stec_role_id) REFERENCES stec_role  (stec_role_id),	' ||
'	CONSTRAINT fk_stec_role_user_ur
	FOREIGN KEY (stec_user_id) REFERENCES stec_user  (stec_user_id),	' ||
'	CONSTRAINT pk_stec_role_user_id     
	PRIMARY KEY ( stec_role_user_id ) 
	ENABLE                     
 )											' 
);

CALL pr_create_if_not_exists('CREATE SEQUENCE sq_stec_role_user_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');

--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER tr_stec_role_user_biud 
BEFORE INSERT OR UPDATE OR DELETE ON stec_role_user
FOR EACH ROW
DECLARE 
	CURSOR  cur_user_role IS
    	SELECT SR.stec_role_id
            FROM stec_role SR, stec_role_user SRU
            WHERE 	:NEW.stec_user_id	= SRU.stec_user_id  AND
            		SR.stec_role_id		= SRU.stec_role_id;
            		
BEGIN
	IF ( NOT (SYS.pkg_stec.fn_my_caller IN ( '<package body ' || pkg_stec_session.fn_schema || '.PKG_STEC_ACCESS>')) )  THEN 
		RAISE_APPLICATION_ERROR(-20001, 'Cannot insert/update/delete directly'); 
	END IF;
	
	IF		INSERTING	THEN
	
		IF NOT pkg_stec_access.fn_i_am_master_of_role(:NEW.stec_role_id) THEN
			RAISE_APPLICATION_ERROR(-20003, 'You are not a master of the role, you can not grant/revoke it to/from anyone');
		END IF;
			
		-- check that user is not a master of the granted role
		FOR rec_user_role IN cur_user_role  LOOP
			IF pkg_stec_access.fn_role_is_my_master(rec_user_role.stec_role_id) THEN
				RAISE_APPLICATION_ERROR(-20003, 'The user has a role that is a master of the granted role');
			END IF;
	    END LOOP;
			
		IF :NEW.stec_role_user_id IS NULL THEN
			SELECT sq_stec_role_user_i.NEXTVAL INTO :NEW.stec_role_user_id FROM DUAL;
		END IF;
		
	ELSIF	UPDATING	THEN

		IF (:OLD.stec_role_user_id	<> :NEW.stec_role_user_id ) THEN
			RAISE_APPLICATION_ERROR(-20001, 'You cannot change stec_role_user_id');
		END IF;

		IF NOT (pkg_stec_access.fn_i_am_master_of_role(:OLD.stec_role_id) AND
				pkg_stec_access.fn_i_am_master_of_role(:NEW.stec_role_id) 		) THEN
			RAISE_APPLICATION_ERROR(-20003, 'You are not a master  of old and new roles, you can not change one by another');
		END IF;
		
		-- check that user is not a master of the granted role
		FOR rec_user_role IN cur_user_role  LOOP
			IF pkg_stec_access.fn_role_is_my_master(rec_user_role.stec_role_id) THEN
				RAISE_APPLICATION_ERROR(-20003, 'The :NEW.user has a role that is a master of the granted :NEW.role');
			END IF;
	    END LOOP;

	ELSIF	DELETING	THEN

		IF NOT pkg_stec_access.fn_i_am_master_of_role(:OLD.stec_role_id) THEN
			RAISE_APPLICATION_ERROR(-20003, 'You are not a master of the role, you can not grant/revoke it to/from anyone');
		END IF;

	END IF;
	
END;
/

--------------------------------------------------------------------------------

