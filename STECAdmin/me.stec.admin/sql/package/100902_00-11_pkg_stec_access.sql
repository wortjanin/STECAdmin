--
-- NOTE! DO NOT FORGET TO CALL pkg_stec_access.pr_lock_release() AFTER calling create/change/drop functions of this package
--


-- THIS PACKAGE IS NOT FOR A DIRECT USE!! (it is used by a vw_stec_role VIEW and some other views)
CREATE OR REPLACE PACKAGE pkg_stec_access AS

	PROCEDURE pr_lock;

	-- pr_lock_release is called AUTOMATICALLY on the pr_commit or pr_rollback calls (or in the case of any exception during the transaction process)
	PROCEDURE pr_lock_release;
	
	FUNCTION fn_i_am_master_of_role(
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE
	) RETURN BOOLEAN;	
	
	FUNCTION fn_role_is_my_master(
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE
	) RETURN BOOLEAN;	

	PROCEDURE pr_ck_role_can_give_access(
  		in_master_stec_role_id			IN division_access	.master_stec_role_id	%TYPE,
  		in_obj_operation_set_id			IN division_access	.obj_operation_set_id	%TYPE
	);
	
	PROCEDURE pr_ck_effective_master_role(
  		in_master_stec_role_id			IN stec_role		.master_stec_role_id	%TYPE
	);
------------------------------------------------------------------

---   vw_stec_role   ---------------------------------------------
	-- pr_stec_role_create is for internal use ONLY
	PROCEDURE pr_stec_role_create(
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
		in_name							IN stec_role		.name					%TYPE,
		in_master_stec_role_id			IN stec_role		.master_stec_role_id	%TYPE,
		in_stec_accessor_id				IN stec_accessor	.stec_accessor_id		%TYPE
	);
	PROCEDURE pr_stec_role_create_transact(
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
		in_name							IN stec_role		.name					%TYPE,
		in_master_stec_role_id			IN stec_role		.master_stec_role_id	%TYPE
  	);

  	PROCEDURE pr_stec_role_change(
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_name_n						IN stec_role		.name					%TYPE,
		in_master_stec_role_id_n		IN stec_role		.master_stec_role_id	%TYPE
	);
	PROCEDURE pr_stec_role_change_transact(
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_name_o						IN stec_role		.name					%TYPE,
		in_name_n						IN stec_role		.name					%TYPE,
		in_master_stec_role_id_o		IN stec_role		.master_stec_role_id	%TYPE,
		in_master_stec_role_id_n		IN stec_role		.master_stec_role_id	%TYPE
	);
  
	PROCEDURE pr_stec_role_drop(
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE
	);
	PROCEDURE pr_stec_role_drop_transact(
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_name_o						IN stec_role		.name					%TYPE,
		in_master_stec_role_id_o		IN stec_role		.master_stec_role_id	%TYPE,
		in_stec_accessor_id_o			IN stec_accessor	.stec_accessor_id		%TYPE
	);

------------------------------------------------------------------

---   vw_division_access   ---------------------------------------
	PROCEDURE pr_access_create(
		in_division_access_id			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id				IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id			IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id			IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id					IN division_access	.division_id			%TYPE,
		in_is_grantable					IN division_access	.is_grantable			%TYPE,
		in_temp_login_block				IN division_access	.temp_login_block		%TYPE
	);
	PROCEDURE pr_access_create_transact(
		in_division_access_id			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id				IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id			IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id			IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id					IN division_access	.division_id			%TYPE,
		in_is_grantable					IN division_access	.is_grantable			%TYPE,
		in_temp_login_block				IN division_access	.temp_login_block		%TYPE
	);

	PROCEDURE pr_access_change(
		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id_o				IN division_access	.division_id			%TYPE,
		in_division_id_n				IN division_access	.division_id			%TYPE,
		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
		in_is_grantable_n				IN division_access	.is_grantable			%TYPE,
		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE,
		in_temp_login_block_n			IN division_access	.temp_login_block		%TYPE
	);
	PROCEDURE pr_access_change_transact(
		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id_o				IN division_access	.division_id			%TYPE,
		in_division_id_n				IN division_access	.division_id			%TYPE,
		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
		in_is_grantable_n				IN division_access	.is_grantable			%TYPE,
		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE,
		in_temp_login_block_n			IN division_access	.temp_login_block		%TYPE
	);

	PROCEDURE pr_access_drop(
		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id_o				IN division_access	.division_id			%TYPE,
		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE
	);
	PROCEDURE pr_access_drop_transact(
		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id_o				IN division_access	.division_id			%TYPE,
		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE
	);

------------------------------------------------------------------

---   vw_stec_role_user   ----------------------------------------

	PROCEDURE pr_role_user_link(
		in_stec_role_user_id			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id					IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block				IN stec_role_user	.temp_login_block		%TYPE
	);
	PROCEDURE pr_role_user_link_transact(
		in_stec_role_user_id			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id					IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block				IN stec_role_user	.temp_login_block		%TYPE
	);
	
	PROCEDURE pr_role_user_relink(
		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_stec_role_id_n				IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
		in_stec_user_id_n				IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE,
		in_temp_login_block_n			IN stec_role_user	.temp_login_block		%TYPE
	);
	PROCEDURE pr_role_user_relink_transact(
		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_stec_role_id_n				IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
		in_stec_user_id_n				IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE,
		in_temp_login_block_n			IN stec_role_user	.temp_login_block		%TYPE
	);

	PROCEDURE pr_role_user_unlink(
		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE
	);
	PROCEDURE pr_role_user_unlink_transact(
		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE
	);
--------------------------------------------------------------------------------
	
END;
/

CREATE OR REPLACE
PACKAGE BODY pkg_stec_access AS
--------------------------------------------------------------------------------
------------------------------PRIVATE_PART--------------------------------------
--------------------------------------------------------------------------------
	mp_schema_id	INT := fn_stec_schema_num;
	mp_user_id		INT := fn_stec_user_id;
	mp_schema		VARCHAR2(30 BYTE) := fn_stec_schema;
	
	mp_stec_role_id			stec_role		.stec_role_id		%TYPE := NULL;
	mp_division_access_id	division_access	.division_access_id	%TYPE := NULL;
	mp_stec_role_user_id	stec_role_user	.stec_role_user_id	%TYPE := NULL;
	
	lock_exists		EXCEPTION;
	s_lock_exists	CONSTANT VARCHAR2(1024 CHAR) := '
Создание/изменение/удаление роли/права уже выполняется в другом сеансе.
Повторите попытку через 1 минуту.
В случае проблем обратитесь к Администратору Системы.
';
	mp_lock_id   	INT := NULL;

	PROCEDURE pr_ck_effective_master_role(
  		in_master_stec_role_id		IN	stec_role.master_stec_role_id%TYPE
	)	
	AS	
		m_cnt	INT := 0;
	BEGIN
		IF 'SYS' <> USER THEN
			SELECT COUNT(*) INTO m_cnt
				FROM division_access DA, stec_role SR, stec_role_user SRU
				WHERE 	SRU.stec_user_id			= mp_user_id				AND
						SRU.stec_role_id			= in_master_stec_role_id	AND
						SRU.stec_role_id			= SR.stec_role_id			AND
						DA.stec_accessor_id			= SR.stec_accessor_id		AND
						DA.is_grantable				= 'Y';
			IF m_cnt < 1 THEN
				RAISE_APPLICATION_ERROR(-20011, 'You must point manually one of your roles with a grantable access as a master role ');
			END IF;
		ELSIF 'SYS' = USER AND NOT in_master_stec_role_id IS NULL THEN
			RAISE_APPLICATION_ERROR(-20011, 'You can only create roles with the NULL master');
		END IF;
	END;
	
	PROCEDURE pr_ck_role_can_give_access(
  		in_master_stec_role_id		IN	division_access.master_stec_role_id%TYPE,
  		in_obj_operation_set_id		IN	division_access.obj_operation_set_id%TYPE
	)	
	AS			
		m_cnt			INT := 0;
	BEGIN
		IF pkg_stec_access.fn_i_am_master_of_role(in_master_stec_role_id) THEN
			-- I am master of role (in_master_stec_role_id), granting a division_access to someone =>
			-- check this role has DA with grantable='Y' on in_obj_operation_set_id
			IF 'SYS' = USER AND in_master_stec_role_id IS NULL THEN
				RETURN;
			END IF;
			
			SELECT COUNT(*) INTO m_cnt
				FROM division_access DA, stec_role SR
				WHERE 	in_master_stec_role_id	= SR.stec_role_id 			AND 
						DA.stec_accessor_id		= SR.stec_accessor_id		AND
						DA.obj_operation_set_id	= in_obj_operation_set_id	AND
						DA.is_grantable			= 'Y';
						
			IF m_cnt < 1 THEN
				RAISE_APPLICATION_ERROR(-20011, '
FAULT: The granted/revoked/changed obj_operation_set from the master_stec_role 
is not grantable (or is absent in the master_stec_role)');
			END IF;
			
			RETURN;
		END IF;
		
		-- First of all, we have to know is the granted access [OS] is grantable. If no - generate exception
		-- To know if it is grantable, we should scan our stec_roles [SR] and find 
		-- division_access[obj_operation_set_id=in_obj_operation_set_id, stec_accessor_id=my_role.acc_id]
		-- and get division_access.is_grantable
		-- if it is not found or found and 'N'=division_access.is_grantable, it will not be grantable
		-- (we can grant only those roles, that are in our stec_role-s, 
		-- they cannot be roles granted directly to a user)
		SELECT COUNT(*) INTO m_cnt
			FROM division_access DA, stec_role SR, stec_role_user SRU
			WHERE 	SRU.stec_user_id		= mp_user_id				AND
					SRU.stec_role_id		= SR.stec_role_id			AND
					in_master_stec_role_id	= SR.stec_role_id			AND
					DA.stec_accessor_id		= SR.stec_accessor_id		AND
					DA.obj_operation_set_id	= in_obj_operation_set_id	AND
					DA.is_grantable			= 'Y';
		IF m_cnt < 1 THEN
			RAISE_APPLICATION_ERROR(-20011, '
FAULT: The granted/revoked/changed obj_operation_set from the master_stec_role 
is not grantable (or is absent in the list of my roles)');
		END IF;
	END;

--------------------------------------------------------------------------------
-------------------------------PUBLIC_PART--------------------------------------
--------------------------------------------------------------------------------

	

-----------fn_i_am_master_of_role-----------------------------------------
--	SELECT * FROM SCOTT.emp;
--	
--	SELECT COUNT(*) FROM DUAL WHERE 7839 IN(
--							SELECT SR.empno  FROM SCOTT.emp SR 
--			   						START WITH SR.empno = 7566
--			   						CONNECT BY PRIOR  SR.mgr = SR.empno		
--	                  );

	FUNCTION fn_i_am_master_of_role(
		in_stec_role_id		IN	stec_role.stec_role_id%TYPE	
	) RETURN BOOLEAN	
	AS
		m_cnt 	INT := 0;
		CURSOR  cur_user_roles IS
			SELECT SR.stec_role_id
				FROM stec_role SR, stec_role_user SRU
				WHERE 	mp_user_id		= SRU.stec_user_id  AND
						SR.stec_role_id	= SRU.stec_role_id;
	BEGIN

		IF ('SYS' = USER) THEN
			RETURN TRUE;
		END IF;
	
		IF (in_stec_role_id IS NULL) THEN
			RETURN FALSE;
		END IF;
	
	-- if the user has no roles, he cannot be a master of some other role.
		SELECT COUNT(*) INTO m_cnt FROM stec_role_user SRU
						WHERE mp_user_id = SRU.stec_user_id;
		IF m_cnt < 1 THEN
			RETURN FALSE;
		END IF;

    	FOR m_role IN cur_user_roles  LOOP
			SELECT COUNT(*) INTO m_cnt FROM	DUAL
				WHERE m_role.stec_role_id IN (
					SELECT  SR.stec_role_id	
						FROM stec_role SR
						START WITH SR.stec_role_id = in_stec_role_id 
						CONNECT BY PRIOR SR.master_stec_role_id = SR.stec_role_id
				);
			IF m_cnt > 0 THEN
				RETURN TRUE;
			END IF;
    	END LOOP;

		RETURN FALSE;
	END;

----------- fn_role_is_my_master -----------------------------------------

	FUNCTION fn_role_is_my_master(
		in_stec_role_id				IN	stec_role.stec_role_id%TYPE
	) RETURN BOOLEAN	
	AS
		m_cnt 	INT := 0;
		CURSOR  cur_user_roles IS
			SELECT SR.master_stec_role_id, SR.stec_role_id 
			FROM stec_role SR, stec_role_user SRU
				WHERE 	mp_user_id		= SRU.stec_user_id  AND
						SR.stec_role_id	= SRU.stec_role_id;
	BEGIN
		IF ('SYS' = USER) THEN
			RETURN FALSE;
		END IF;
		
		IF (in_stec_role_id IS NULL) THEN
			RETURN FALSE;
		END IF;
		
		FOR m_role IN cur_user_roles  LOOP
			SELECT COUNT(*) INTO m_cnt FROM	DUAL
				WHERE m_role.master_stec_role_id IN (
					SELECT  SR.stec_role_id	
						FROM stec_role SR
						START WITH SR.stec_role_id = in_stec_role_id 
						CONNECT BY PRIOR SR.stec_role_id = SR.master_stec_role_id
				);
			IF m_cnt > 0 THEN
				RETURN TRUE;
			END IF;
		END LOOP;
	
		RETURN FALSE;
	END;

	PROCEDURE pr_lock_release
	AS
	BEGIN
	    mp_stec_role_id 		:= NULL;
		mp_division_access_id	:= NULL;
		mp_stec_role_user_id	:= NULL;
		
	    mp_lock_id := NULL;
	END;
	
	-- a local (fn_stec_schema) lock
	PROCEDURE pr_lock	
	AS			
	BEGIN
		IF (NOT mp_lock_id IS NULL) THEN
			RETURN;
		END IF;
		
		BEGIN
			pkg_stec_transact.pr_start('CALL pkg_stec_access.pr_lock_release()');
		EXCEPTION
			WHEN OTHERS THEN
				RAISE lock_exists;
		END;
		mp_lock_id := 1;
	END;

-----------   pr_stec_role_create   -----------------------------------------
	PROCEDURE pr_stec_role_create(
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
		in_name							IN stec_role		.name					%TYPE,
		in_master_stec_role_id			IN stec_role		.master_stec_role_id	%TYPE,
		in_stec_accessor_id				IN stec_accessor	.stec_accessor_id		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_id		stec_role.stec_role_id%TYPE;
	BEGIN
		
		INSERT 	INTO stec_role	(stec_role_id,		name, 		master_stec_role_id,	stec_accessor_id)
				VALUES			(in_stec_role_id,	in_name, 	in_master_stec_role_id,	in_stec_accessor_id);

		IF 	in_stec_role_id IS NULL THEN
			SELECT sq_stec_role_i.CURRVAL INTO m_id FROM DUAL;
		ELSE
			m_id := in_stec_role_id;
		END IF;

		pkg_stec_account.pr_ora_role_create('SR' || mp_schema_id || '_' || m_id );

		COMMIT;	
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;
	
	PROCEDURE pr_stec_role_create_transact(
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
		in_name							IN stec_role		.name					%TYPE,
		in_master_stec_role_id			IN stec_role		.master_stec_role_id	%TYPE
  	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit		%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback	%TYPE;
	    m_id		stec_role		.stec_role_id	%TYPE;
	BEGIN
		pr_lock();
	
		IF in_stec_role_id IS NULL THEN
			IF mp_stec_role_id IS NULL THEN
				SELECT MAX(SR.stec_role_id) INTO mp_stec_role_id FROM stec_role SR;
				IF mp_stec_role_id IS NULL THEN
					mp_stec_role_id := 1;
				ELSE
					mp_stec_role_id := mp_stec_role_id + 1;
				END IF;
			ELSE
				mp_stec_role_id := mp_stec_role_id + 1;
			END IF;
			pr_set_startval_for_seq('sq_stec_role_i', mp_stec_role_id);
			m_id := mp_stec_role_id;
		ELSE
			m_id := in_stec_role_id;
		END IF;
		
		m_cmd_cmt := 
	     	'CALL pkg_stec_access.pr_stec_role_create('
				|| fn_num(m_id) || ', '
				|| fn_str(in_name) || ', '
				|| fn_num(in_master_stec_role_id) || ', ' 
				|| 'NULL)';
	    m_cmd_rlb := 
	    	'CALL pkg_stec_access.pr_stec_role_drop('|| fn_num(m_id) || ')';
	    	
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;

	
	PROCEDURE pr_stec_role_change(
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_name_n						IN stec_role		.name					%TYPE,
		in_master_stec_role_id_n		IN stec_role		.master_stec_role_id	%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_cnt		INT :=0;
	BEGIN
		
		UPDATE stec_role SR 
			SET
				SR.name					= in_name_n,
				SR.master_stec_role_id	= in_master_stec_role_id_n
			WHERE
				SR.stec_role_id = in_stec_role_id_o;

		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;
  
	PROCEDURE pr_stec_role_change_transact(
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_name_o						IN stec_role		.name					%TYPE,
		in_name_n						IN stec_role		.name					%TYPE,
		in_master_stec_role_id_o		IN stec_role		.master_stec_role_id	%TYPE,
		in_master_stec_role_id_n		IN stec_role		.master_stec_role_id	%TYPE
	)AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit		%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback	%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	     	'CALL pkg_stec_access.pr_stec_role_change('
				|| fn_num(in_stec_role_id_o) || ', '
				|| fn_str(in_name_n) || ', '
				|| fn_num(in_master_stec_role_id_n) || ')';
	    m_cmd_rlb := 
	     	'CALL pkg_stec_access.pr_stec_role_change('
				|| fn_num(in_stec_role_id_o) || ', '
				|| fn_str(in_name_o) || ', '
				|| fn_num(in_master_stec_role_id_o) || ')';
				
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
	    
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;

	
	PROCEDURE pr_stec_role_drop(
		in_stec_role_id_o				IN stec_role.stec_role_id%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_cnt		INT := 0;
	BEGIN

		DELETE FROM stec_role SR WHERE SR.stec_role_id = in_stec_role_id_o;			

		pkg_stec_account.pr_ora_role_drop('SR' || mp_schema_id || '_' || in_stec_role_id_o );

		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;
	
	PROCEDURE pr_stec_role_drop_transact(
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_name_o						IN stec_role		.name					%TYPE,
		in_master_stec_role_id_o		IN stec_role		.master_stec_role_id	%TYPE,
		in_stec_accessor_id_o			IN stec_accessor	.stec_accessor_id		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit		%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback	%TYPE;
	BEGIN
		pr_lock();
	
	    m_cmd_cmt := 
	    	'CALL pkg_stec_access.pr_stec_role_drop('|| fn_num(in_stec_role_id_o) || ')';
		m_cmd_rlb := 
	     	'CALL pkg_stec_access.pr_stec_role_create('
				|| fn_num(in_stec_role_id_o) || ', '
				|| fn_str(in_name_o) || ', '
				|| fn_num(in_master_stec_role_id_o) || ', ' 
				|| fn_num(in_stec_accessor_id_o) || ')';
				
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
	    
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;

------------------------------------------------------------------
------------------------------------------------------------------
---   vw_division_access   ---------------------------------------

	PROCEDURE pr_access_create(
		in_division_access_id			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id				IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id			IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id			IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id					IN division_access	.division_id			%TYPE,
		in_is_grantable					IN division_access	.is_grantable			%TYPE,
		in_temp_login_block				IN division_access	.temp_login_block		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_tp    		stec_accessor_type	.constant     	%TYPE;
	    m_rl_id 		stec_role         	.stec_role_id 	%TYPE;
	    m_login 		stec_login			.login        	%TYPE;
	    m_pw_is_temp	stec_login			.pw_is_temp		%TYPE;							
	BEGIN

		-- get the accesor type
		SELECT SAT.constant 	INTO m_tp 
			FROM stec_accessor SA, stec_accessor_type SAT
			WHERE 	SA.stec_accessor_id			= in_stec_accessor_id AND
					SA.stec_accessor_type_id	= SAT.stec_accessor_type_id;  
		
		-- the accessor is a role. Before the grantage we should get the genealogy of this role
		-- If the role is our master (direct or indirect), we should generate an exception
		-- if the value of master_stec_role_id
		
		IF 'SAT_ROLE' = m_tp THEN
		
			SELECT SR.stec_role_id INTO m_rl_id FROM stec_role SR
				WHERE SR.stec_accessor_id = in_stec_accessor_id;

			INSERT 	INTO division_access(
				division_access_id, 
				stec_accessor_id,		master_stec_role_id,	obj_operation_set_id,
				division_id,			is_grantable,			temp_login_block
			)	VALUES				(
				in_division_access_id,
				in_stec_accessor_id,	in_master_stec_role_id,	in_obj_operation_set_id,	
				in_division_id,			in_is_grantable,		'N'
			);
			
			pkg_stec_account.pr_ora_grant(
				'GRANT ' || 
				'OS' || mp_schema_id || '_' || in_obj_operation_set_id || ' TO ' ||
				'SR' || mp_schema_id || '_' || m_rl_id || ' ' ||
				(CASE WHEN 'Y' = in_is_grantable THEN 'WITH ADMIN OPTION' ELSE ' ' END)
			);
				
		ELSIF 'SAT_USER' = m_tp THEN
		
			SELECT SL.login, SL.pw_is_temp	INTO m_login, m_pw_is_temp
				FROM	stec_login SL, stec_user SU
				WHERE	SL.stec_user_id 	= SU.stec_user_id 		AND
						in_stec_accessor_id	= SU.stec_accessor_id;
			
			INSERT 	INTO division_access(
				division_access_id, 
				stec_accessor_id,		master_stec_role_id,	obj_operation_set_id,
				division_id,			is_grantable,			temp_login_block
			)	VALUES				(
				in_division_access_id, 
				in_stec_accessor_id,	in_master_stec_role_id,	in_obj_operation_set_id,	
				in_division_id,			in_is_grantable,		m_pw_is_temp
				-- in_temp_login_block
			);
			
			-- IF 'N' = in_temp_login_block THEN
			IF 'N' = m_pw_is_temp THEN
				pkg_stec_account.pr_ora_grant(
					'GRANT ' || 
					'OS' || mp_schema_id || '_' || in_obj_operation_set_id || ' TO ' ||
					m_login  || ' ' 													);
			END IF;			
		END IF;
	
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;
	
	PROCEDURE pr_access_create_transact(
		in_division_access_id			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id				IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id			IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id			IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id					IN division_access	.division_id			%TYPE,
		in_is_grantable					IN division_access	.is_grantable			%TYPE,
		in_temp_login_block				IN division_access	.temp_login_block		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	    m_id		division_access	.division_access_id	%TYPE;
	BEGIN
		pr_lock();
	
		IF in_division_access_id IS NULL THEN
			IF mp_division_access_id IS NULL THEN
				SELECT MAX(DA.division_access_id) INTO mp_division_access_id
					FROM division_access DA;
				IF mp_division_access_id IS NULL THEN
					mp_division_access_id := 1;
				ELSE 
					mp_division_access_id := mp_division_access_id + 1;
				END IF;
			ELSE
				mp_division_access_id := mp_division_access_id + 1;
			END IF;
			pr_set_startval_for_seq('sq_division_access_i', mp_division_access_id);
			m_id := mp_division_access_id;
		ELSE
			m_id := in_division_access_id;
		END IF;
		
		m_cmd_cmt := 
	     	'CALL pkg_stec_access.pr_access_create('
				|| fn_num(m_id) || ', '
				|| fn_num(in_stec_accessor_id) || ', '
				|| fn_num(in_master_stec_role_id) || ', '
				|| fn_num(in_obj_operation_set_id) || ', '
				|| fn_num(in_division_id) || ', '
				|| fn_str(in_is_grantable) || ', '
				|| fn_str(in_temp_login_block) || ')';

		m_cmd_rlb := 
	    	'CALL pkg_stec_access.pr_access_drop('
				|| fn_num(m_id) || ', '
				|| fn_num(in_stec_accessor_id) || ', '
				|| fn_num(in_master_stec_role_id) || ', '
				|| fn_num(in_obj_operation_set_id) || ', '
				|| fn_num(in_division_id) || ', '
				|| fn_str(in_is_grantable) || ', '
				|| fn_str(in_temp_login_block) || ')';
				
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
	    
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;
	

	PROCEDURE pr_access_change(
		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id_o				IN division_access	.division_id			%TYPE,
		in_division_id_n				IN division_access	.division_id			%TYPE,
		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
		in_is_grantable_n				IN division_access	.is_grantable			%TYPE,
		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE,
		in_temp_login_block_n			IN division_access	.temp_login_block		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_tp    stec_accessor_type.constant     %TYPE;
	    m_rl_id stec_role         .stec_role_id %TYPE;
	    m_login stec_login        .login        %TYPE;
	BEGIN

		-- get the accesor type
		SELECT SAT.constant 	INTO m_tp 
			FROM stec_accessor SA, stec_accessor_type SAT
			WHERE 	SA.stec_accessor_id			= in_stec_accessor_id_o		AND
					SA.stec_accessor_type_id	= SAT.stec_accessor_type_id;  
			
		IF 'SAT_ROLE' = m_tp THEN
		
			SELECT SR.stec_role_id INTO m_rl_id FROM stec_role SR
				WHERE SR.stec_accessor_id	= in_stec_accessor_id_o;

			UPDATE division_access DA
				SET	
					DA.division_id			= in_division_id_n,
					DA.is_grantable			= in_is_grantable_n
				WHERE
					DA.division_access_id = in_division_access_id_o;
			IF		'Y' = in_is_grantable_o AND 'N' = in_is_grantable_n THEN
				pkg_stec_account.pr_ora_grant(
					'REVOKE ' || 
					'OS' || mp_schema_id || '_' || in_obj_operation_set_id_o || ' FROM ' ||
					'SR' || mp_schema_id || '_' || m_rl_id || ' '							);
				pkg_stec_account.pr_ora_grant(
					'GRANT ' || 
					'OS' || mp_schema_id || '_' || in_obj_operation_set_id_o || ' TO ' || 
					'SR' || mp_schema_id || '_' || m_rl_id || ' ');
			ELSIF	'N' = in_is_grantable_o AND 'Y' = in_is_grantable_n THEN
				pkg_stec_account.pr_ora_grant(
					'GRANT ' || 
					'OS' || mp_schema_id || '_' || in_obj_operation_set_id_o || ' TO ' || 
					'SR' || mp_schema_id || '_' || m_rl_id || ' WITH ADMIN OPTION');
			END IF;
		ELSIF 'SAT_USER' = m_tp THEN
		
			SELECT SL.login	INTO m_login
				FROM	stec_login SL, stec_user SU
				WHERE	SL.stec_user_id 		= SU.stec_user_id 		AND
						in_stec_accessor_id_o	= SU.stec_accessor_id;

			UPDATE division_access DA
				SET	
					DA.division_id			= in_division_id_n,
					DA.temp_login_block		= in_temp_login_block_n
				WHERE
					DA.division_access_id = in_division_access_id_o;
			IF		'N' = in_temp_login_block_o AND  'Y' = in_temp_login_block_n THEN		
				pkg_stec_account.pr_ora_grant(
					'REVOKE ' || 
					'OS' || mp_schema_id || '_' || in_obj_operation_set_id_o || ' FROM ' ||
					m_login	);
			ELSIF 	'Y' = in_temp_login_block_o AND  'N' = in_temp_login_block_n THEN
				pkg_stec_account.pr_ora_grant(
					'GRANT ' || 
					'OS' || mp_schema_id || '_' || in_obj_operation_set_id_o || ' TO ' || 
					m_login																);
			END IF;
			
		END IF;
	
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;

	PROCEDURE pr_access_change_transact(
		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id_o				IN division_access	.division_id			%TYPE,
		in_division_id_n				IN division_access	.division_id			%TYPE,
		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
		in_is_grantable_n				IN division_access	.is_grantable			%TYPE,
		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE,
		in_temp_login_block_n			IN division_access	.temp_login_block		%TYPE
	)AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	     	'CALL pkg_stec_access.pr_access_change('
				|| fn_num(in_division_access_id_o) || ', '
				|| fn_num(in_stec_accessor_id_o) || ', '
				|| fn_num(in_master_stec_role_id_o) || ', '
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_num(in_division_id_o) || ', '
				|| fn_num(in_division_id_n) || ', '
				|| fn_str(in_is_grantable_o) || ', '
				|| fn_str(in_is_grantable_n) || ', '
				|| fn_str(in_temp_login_block_o) || ', '
				|| fn_str(in_temp_login_block_n) || ')';

		m_cmd_rlb := 
	     	'CALL pkg_stec_access.pr_access_change('
				|| fn_num(in_division_access_id_o) || ', '
				|| fn_num(in_stec_accessor_id_o) || ', '
				|| fn_num(in_master_stec_role_id_o) || ', '
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_num(in_division_id_n) || ', '
				|| fn_num(in_division_id_o) || ', '
				|| fn_str(in_is_grantable_n) || ', '
				|| fn_str(in_is_grantable_o) || ', '
				|| fn_str(in_temp_login_block_n) || ', '
				|| fn_str(in_temp_login_block_o) || ')';
				
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
	    
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;
	
	
	PROCEDURE pr_access_drop(
		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id_o				IN division_access	.division_id			%TYPE,
		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_tp    stec_accessor_type.constant     %TYPE;
    	m_rl_id stec_role         .stec_role_id %TYPE;
    	m_login stec_login        .login        %TYPE;
	BEGIN

		-- get the accesor type
		SELECT SAT.constant 	INTO m_tp 
			FROM stec_accessor SA, stec_accessor_type SAT
			WHERE 	SA.stec_accessor_id			= in_stec_accessor_id_o AND
					SA.stec_accessor_type_id	= SAT.stec_accessor_type_id;  
	
		DELETE FROM division_access DA WHERE DA.division_access_id = in_division_access_id_o;

		IF 'SAT_ROLE' = m_tp THEN
		
			SELECT SR.stec_role_id INTO m_rl_id FROM stec_role SR
				WHERE SR.stec_accessor_id = in_stec_accessor_id_o;
				
			pkg_stec_account.pr_ora_grant(
				'REVOKE ' || 
				'OS' || mp_schema_id || '_' || in_obj_operation_set_id_o || ' FROM ' ||
				'SR' || mp_schema_id || '_' || m_rl_id || ' '						);
	
		ELSIF 'SAT_USER' = m_tp THEN
		
			SELECT SL.login	INTO m_login
				FROM	stec_login SL, stec_user SU
				WHERE	SL.stec_user_id 		= SU.stec_user_id 		AND
						in_stec_accessor_id_o	= SU.stec_accessor_id;
				
			IF 'N' = in_temp_login_block_o THEN
				pkg_stec_account.pr_ora_grant(
					'REVOKE ' || 
					'OS' || mp_schema_id || '_' || in_obj_operation_set_id_o || ' FROM ' ||
					m_login || ' ' 													);
			END IF;				
		END IF;

		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;
	
	PROCEDURE pr_access_drop_transact(
		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
		in_division_id_o				IN division_access	.division_id			%TYPE,
		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	     	'CALL pkg_stec_access.pr_access_drop('
				|| fn_num(in_division_access_id_o) || ', '
				|| fn_num(in_stec_accessor_id_o) || ', '
				|| fn_num(in_master_stec_role_id_o) || ', '
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_num(in_division_id_o) || ', '
				|| fn_str(in_is_grantable_o) || ', '
				|| fn_str(in_temp_login_block_o) || ')';

		m_cmd_rlb := 
	    	'CALL pkg_stec_access.pr_access_create('
				|| fn_num(in_division_access_id_o) || ', '
				|| fn_num(in_stec_accessor_id_o) || ', '
				|| fn_num(in_master_stec_role_id_o) || ', '
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_num(in_division_id_o) || ', '
				|| fn_str(in_is_grantable_o) || ', '
				|| fn_str(in_temp_login_block_o) || ')';
				
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
	    
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;

------------------------------------------------------------------

	PROCEDURE pr_role_user_link(
		in_stec_role_user_id			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id					IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block				IN stec_role_user	.temp_login_block		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_login		stec_login	.login			%TYPE;
	BEGIN
		
		INSERT 	INTO stec_role_user	(stec_role_user_id,		stec_user_id,		stec_role_id,		temp_login_block)
				VALUES				(in_stec_role_user_id,	in_stec_user_id, 	in_stec_role_id,	in_temp_login_block);

		SELECT SL.login	INTO m_login
			FROM	stec_login SL, stec_user SU
			WHERE	SL.stec_user_id 		= in_stec_user_id;

		IF 'N' = in_temp_login_block THEN
			pkg_stec_account.pr_ora_grant(
				'GRANT ' || 
				'SR' || mp_schema_id || '_' || in_stec_role_id || ' TO ' ||
				m_login || ' ' 													);
		END IF;
		
		COMMIT;	
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;

	PROCEDURE pr_role_user_link_transact(
		in_stec_role_user_id			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id					IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block				IN stec_role_user	.temp_login_block		%TYPE
	)AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	    m_id		stec_role_user	.stec_role_user_id	%TYPE;
	BEGIN
		pr_lock();
		IF in_stec_role_user_id IS NULL THEN
			IF mp_stec_role_user_id IS NULL THEN
				SELECT MAX(SRU.stec_role_user_id) INTO mp_stec_role_user_id
					FROM stec_role_user SRU;
				IF mp_stec_role_user_id IS NULL THEN
					mp_stec_role_user_id := 1;
				ELSE
					mp_stec_role_user_id := mp_stec_role_user_id + 1;
				END IF;
			ELSE
				mp_stec_role_user_id := mp_stec_role_user_id + 1;
			END IF;		
			pr_set_startval_for_seq('sq_stec_role_user_i', mp_stec_role_user_id);
			m_id := mp_stec_role_user_id;
		ELSE
			m_id := in_stec_role_user_id;
		END IF;
		
		m_cmd_cmt := 
	     	'CALL pkg_stec_access.pr_role_user_link('
				|| fn_num(m_id) || ', '
				|| fn_num(in_stec_role_id) || ', '
				|| fn_num(in_stec_user_id) || ', '
				|| fn_str(in_temp_login_block) || ')';

		m_cmd_rlb := 
	    	'CALL pkg_stec_access.pr_role_user_unlink('
				|| fn_num(m_id) || ', '
				|| fn_num(in_stec_role_id) || ', '
				|| fn_num(in_stec_user_id) || ', '
				|| fn_str(in_temp_login_block) || ')';
				
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
	    
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;
	
	PROCEDURE pr_role_user_relink(
		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_stec_role_id_n				IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
		in_stec_user_id_n				IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE,
		in_temp_login_block_n			IN stec_role_user	.temp_login_block		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_login_o	stec_login	.login			%TYPE;
		m_login_n	stec_login	.login			%TYPE;
	BEGIN
		
		UPDATE 	stec_role_user SRU
			SET
				SRU.stec_user_id		= in_stec_user_id_n,
				SRU.stec_role_id		= in_stec_role_id_n,		
				SRU.temp_login_block	= in_temp_login_block_n
			WHERE
				SRU.stec_role_user_id	= in_stec_role_user_id_o;

		SELECT SL.login	INTO m_login_o
			FROM	stec_login SL, stec_user SU
			WHERE	SL.stec_user_id 		= in_stec_user_id_o;

		SELECT SL.login	INTO m_login_n
			FROM	stec_login SL, stec_user SU
			WHERE	SL.stec_user_id 		= in_stec_user_id_n;

		IF 'N' = in_temp_login_block_o THEN
			pkg_stec_account.pr_ora_grant(
				'REVOKE ' || 
				'SR' || mp_schema_id || '_' || in_stec_role_id_o || ' FROM ' ||
				m_login_o || ' ' 											);
		END IF;

		IF 'N' = in_temp_login_block_n THEN
			BEGIN
				pkg_stec_account.pr_ora_grant(
					'GRANT ' || 
					'SR' || mp_schema_id || '_' || in_stec_role_id_n || ' TO ' ||
					m_login_n || ' ' 											);
			EXCEPTION WHEN OTHERS THEN
				IF 'N' = in_temp_login_block_o THEN
					pkg_stec_account.pr_ora_grant(
						'GRANT ' || 
						'SR' || mp_schema_id || '_' || in_stec_role_id_o || ' TO ' ||
						m_login_o || ' ' 											);
				END IF;
				RAISE;
			END;
		END IF;
		
		COMMIT;	
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;

	PROCEDURE pr_role_user_relink_transact(
		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_stec_role_id_n				IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
		in_stec_user_id_n				IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE,
		in_temp_login_block_n			IN stec_role_user	.temp_login_block		%TYPE
	)AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	     	'CALL pkg_stec_access.pr_role_user_relink('
				|| fn_num(in_stec_role_user_id_o) || ', '
				|| fn_num(in_stec_role_id_o) || ', '
				|| fn_num(in_stec_role_id_n) || ', '
				|| fn_num(in_stec_user_id_o) || ', '
				|| fn_num(in_stec_user_id_n) || ', '
				|| fn_str(in_temp_login_block_o) || ', ' 
				|| fn_str(in_temp_login_block_n) || ')';

		m_cmd_rlb := 
	    	'CALL pkg_stec_access.pr_role_user_relink('
				|| fn_num(in_stec_role_user_id_o) || ', '
				|| fn_num(in_stec_role_id_n) || ', '
				|| fn_num(in_stec_role_id_o) || ', '
				|| fn_num(in_stec_user_id_n) || ', '
				|| fn_num(in_stec_user_id_o) || ', '
				|| fn_str(in_temp_login_block_n) || ', ' 
				|| fn_str(in_temp_login_block_o) || ')';
				
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;

	PROCEDURE pr_role_user_unlink(
		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
      	m_login		stec_login    .login    			%TYPE;
	BEGIN
		
		DELETE FROM  stec_role_user SRU
			WHERE SRU.stec_role_user_id = in_stec_role_user_id_o;

		SELECT SL.login	INTO m_login
			FROM	stec_login SL, stec_user SU
			WHERE	SL.stec_user_id 		= in_stec_user_id_o;

		IF 'N' = in_temp_login_block_o THEN
			pkg_stec_account.pr_ora_grant(
				'REVOKE ' || 
				'SR' || mp_schema_id || '_' || in_stec_role_id_o || ' FROM ' ||
				m_login || ' ' 											);
		END IF;
		
		COMMIT;	
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;
	
	PROCEDURE pr_role_user_unlink_transact(
		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE
	)AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	     	'CALL pkg_stec_access.pr_role_user_unlink('
				|| fn_num(in_stec_role_user_id_o) || ', '
				|| fn_num(in_stec_role_id_o) || ', '
				|| fn_num(in_stec_user_id_o) || ', '
				|| fn_str(in_temp_login_block_o) || ')';

		m_cmd_rlb := 
	    	'CALL pkg_stec_access.pr_role_user_link('
				|| fn_num(in_stec_role_user_id_o) || ', '
				|| fn_num(in_stec_role_id_o) || ', '
				|| fn_num(in_stec_user_id_o) || ', '
				|| fn_str(in_temp_login_block_o) || ')';
				
	    pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;
END;
/

---------------------------------------------------------------------------------