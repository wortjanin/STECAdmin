-- This package is used by vw_stec_obj_operation_set and vw_obj_operation

CREATE OR REPLACE PACKAGE pkg_stec_operation_set AS

	PROCEDURE pr_lock;

	-- pr_lock_release is called AUTOMATICALLY on the pr_commit or pr_rollback calls (or in the case of any exception during the transaction process)
	PROCEDURE pr_lock_release;
	
	PROCEDURE pr_obj_operation_ck(	
		in_object_type				IN obj_operation		.object_type			%TYPE,
		in_object_name				IN obj_operation		.object_name			%TYPE,
		in_sel						IN obj_operation		.sel					%TYPE,
		in_ins						IN obj_operation		.ins					%TYPE,
		in_upd						IN obj_operation		.upd					%TYPE,
		in_del						IN obj_operation		.del					%TYPE,
		in_exe						IN obj_operation		.exe					%TYPE			
	);
	
------------------------------------------------------------------------------------------	
--------    vw_obj_operation_set    ------------------------------------------------------	
	PROCEDURE pr_oper_set_create(
		in_obj_operation_set_id		IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant					IN obj_operation_set	.constant				%TYPE,
		in_name						IN obj_operation_set	.name					%TYPE
  	);
	PROCEDURE pr_oper_set_create_transact(
		in_obj_operation_set_id		IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant					IN obj_operation_set	.constant				%TYPE,
		in_name						IN obj_operation_set	.name					%TYPE
  	);
  	
  	PROCEDURE pr_oper_set_change(
		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant_n				IN obj_operation_set	.constant				%TYPE,
		in_name_n					IN obj_operation_set	.name					%TYPE
  	);
  	PROCEDURE pr_oper_set_change_transact(
		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant_o				IN obj_operation_set	.constant				%TYPE,
		in_constant_n				IN obj_operation_set	.constant				%TYPE,
		in_name_o					IN obj_operation_set	.name					%TYPE,
		in_name_n					IN obj_operation_set	.name					%TYPE
  	);
  	
  	PROCEDURE pr_oper_set_drop(
		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant_o				IN obj_operation_set	.constant				%TYPE,
		in_name_o					IN obj_operation_set	.name					%TYPE
  	);
  	PROCEDURE pr_oper_set_drop_transact(
		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant_o				IN obj_operation_set	.constant				%TYPE,
		in_name_o					IN obj_operation_set	.name					%TYPE
  	);

------------------------------------------------------------------------------------------	
--------      vw_obj_operation      ------------------------------------------------------	
  	
	PROCEDURE pr_oper_create(
		in_obj_operation_id			IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id		IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name				IN obj_operation	.object_name			%TYPE,
		in_object_type				IN obj_operation	.object_type			%TYPE,
		in_sel						IN obj_operation	.sel					%TYPE,
		in_ins						IN obj_operation	.ins					%TYPE,
		in_upd						IN obj_operation	.upd					%TYPE,
		in_del						IN obj_operation	.del					%TYPE,
		in_exe						IN obj_operation	.exe					%TYPE
	);
	PROCEDURE pr_oper_create_transact(
		in_obj_operation_id			IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id		IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name				IN obj_operation	.object_name			%TYPE,
		in_object_type				IN obj_operation	.object_type			%TYPE,
		in_sel						IN obj_operation	.sel					%TYPE,
		in_ins						IN obj_operation	.ins					%TYPE,
		in_upd						IN obj_operation	.upd					%TYPE,
		in_del						IN obj_operation	.del					%TYPE,
		in_exe						IN obj_operation	.exe					%TYPE
	);  	

	PROCEDURE pr_oper_change(
		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name_o			IN obj_operation	.object_name			%TYPE,
		in_object_type_o			IN obj_operation	.object_type			%TYPE,
		in_sel_o					IN obj_operation	.sel					%TYPE,
		in_sel_n					IN obj_operation	.sel					%TYPE,
		in_ins_o					IN obj_operation	.ins					%TYPE,
		in_ins_n					IN obj_operation	.ins					%TYPE,
		in_upd_o					IN obj_operation	.upd					%TYPE,
		in_upd_n					IN obj_operation	.upd					%TYPE,
		in_del_o					IN obj_operation	.del					%TYPE,
		in_del_n					IN obj_operation	.del					%TYPE,
		in_exe_o					IN obj_operation	.exe					%TYPE,
		in_exe_n					IN obj_operation	.exe					%TYPE
	);
	PROCEDURE pr_oper_change_transact(
		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name_o			IN obj_operation	.object_name			%TYPE,
		in_object_type_o			IN obj_operation	.object_type			%TYPE,
		in_sel_o					IN obj_operation	.sel					%TYPE,
		in_sel_n					IN obj_operation	.sel					%TYPE,
		in_ins_o					IN obj_operation	.ins					%TYPE,
		in_ins_n					IN obj_operation	.ins					%TYPE,
		in_upd_o					IN obj_operation	.upd					%TYPE,
		in_upd_n					IN obj_operation	.upd					%TYPE,
		in_del_o					IN obj_operation	.del					%TYPE,
		in_del_n					IN obj_operation	.del					%TYPE,
		in_exe_o					IN obj_operation	.exe					%TYPE,
		in_exe_n					IN obj_operation	.exe					%TYPE
	);  	

	PROCEDURE pr_oper_drop(
		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name_o			IN obj_operation	.object_name			%TYPE,
		in_object_type_o			IN obj_operation	.object_type			%TYPE,
		in_sel_o					IN obj_operation	.sel					%TYPE,
		in_ins_o					IN obj_operation	.ins					%TYPE,
		in_upd_o					IN obj_operation	.upd					%TYPE,
		in_del_o					IN obj_operation	.del					%TYPE,
		in_exe_o					IN obj_operation	.exe					%TYPE
	);
	PROCEDURE pr_oper_drop_transact(
		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name_o			IN obj_operation	.object_name			%TYPE,
		in_object_type_o			IN obj_operation	.object_type			%TYPE,
		in_sel_o					IN obj_operation	.sel					%TYPE,
		in_ins_o					IN obj_operation	.ins					%TYPE,
		in_upd_o					IN obj_operation	.upd					%TYPE,
		in_del_o					IN obj_operation	.del					%TYPE,
		in_exe_o					IN obj_operation	.exe					%TYPE
	);  	
	
END;
/

CREATE OR REPLACE
PACKAGE BODY pkg_stec_operation_set AS

	mp_schema					VARCHAR2(30 BYTE)	:= fn_stec_schema;
	mp_schema_id				INT					:= fn_stec_schema_num;

	mp_obj_operation_id			obj_operation		.obj_operation_id		%TYPE := NULL;
	mp_obj_operation_set_id		obj_operation_set	.obj_operation_set_id	%TYPE := NULL;
	
	mp_lock_id					INT := NULL;
	lock_exists		EXCEPTION;
	s_lock_exists	CONSTANT VARCHAR(128 CHAR) := '
Создание/изменение/удаление права уже выполняется в другом сеансе.
';

	-- pr_lock_release is called AUTOMATICALLY on the pr_commit or pr_rollback calls (or in the case of any exception during the transaction process)
	PROCEDURE pr_lock_release
	AS	
	BEGIN
		mp_obj_operation_id 	:= NULL;
		mp_obj_operation_set_id	:= NULL;
		
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
			pkg_stec_transact.pr_start('CALL pkg_stec_operation_set.pr_lock_release()');
		EXCEPTION
			WHEN OTHERS THEN
				RAISE lock_exists;
		END;
		mp_lock_id := 1;
	END;

	PROCEDURE pr_obj_operation_ck(	
		in_object_type	IN obj_operation.object_type%TYPE,
		in_object_name	IN obj_operation.object_name%TYPE,
		in_sel			IN obj_operation.sel%TYPE,
		in_ins			IN obj_operation.ins%TYPE,
		in_upd			IN obj_operation.upd%TYPE,
		in_del			IN obj_operation.del%TYPE,
		in_exe			IN obj_operation.exe%TYPE			
	) AS
	  m_obj_name DBA_OBJECTS.OBJECT_NAME%TYPE;
	  m_obj_type DBA_OBJECTS.OBJECT_TYPE%TYPE := 
	  		(CASE WHEN 'VW' = in_object_type THEN	'VIEW'		ELSE
	  		(CASE WHEN 'TB' = in_object_type THEN	'TABLE'		ELSE
	  		(CASE WHEN 'FN' = in_object_type THEN	'FUNCTION'	ELSE
	  		(CASE WHEN 'PR' = in_object_type THEN	'PROCEDURE'	ELSE
													'PACKAGE'  			
	  		 END) END) END) END);
	BEGIN
	
		SELECT OBJECT_NAME 	INTO m_obj_name
							FROM DBA_OBJECTS 
	   	    	  			WHERE 	mp_schema			= OWNER			AND 
	       	    	    			in_object_name		= OBJECT_NAME	AND
	           	    				m_obj_type			= OBJECT_TYPE;
	-- if the in_object_name or in_object_type are incorrect, there should be an exception	(DATA_NOT_FOUND)
	
	    IF(	'VW' =		in_object_type OR
	    	'TB' =		in_object_type 		) THEN
	    	IF ('Y' =	in_exe) THEN
	    		RAISE_APPLICATION_ERROR(-20002, 'EXECUTE is not for TABLE or VIEW');
	    	END IF;
	    ELSE
	    	IF ('Y' = in_sel OR
	    		'Y' = in_ins OR
	    		'Y' = in_upd OR
	    		'Y' = in_del 		) THEN
	    		RAISE_APPLICATION_ERROR(-20002, 'SELECT, INSERT, UPDATE, DELETE operations are for TABLE or VIEW only');
	    	END IF;
	    END IF;
	END;

	PROCEDURE pr_obj_operation_grant(	
		in_object_name				IN obj_operation.object_name			%TYPE,
		in_obj_operation_set_id		IN obj_operation.obj_operation_set_id	%TYPE,
		in_operation				IN VARCHAR2,
		in_grant 					IN CHAR
	)
	AS PRAGMA AUTONOMOUS_TRANSACTION; 
	BEGIN
		IF 'SYS' <> USER THEN
			RAISE_APPLICATION_ERROR(-20002, 'Only SYS DBA user can change obj_operation table');
			-- Note, that access from other users to this procedure (direct or not)
			--	can compromise sequrity of the STEC system
		END IF;

		EXECUTE IMMEDIATE
			'CALL pkg_stec_account.pr_ora_grant(''' || 
				(CASE WHEN 'N'= in_grant THEN ' REVOKE ' 	ELSE ' GRANT '	END) || 
				in_operation || ' ON ' || mp_schema || '.' || in_object_name || 
				(CASE WHEN 'N'= in_grant THEN ' FROM '		ELSE ' TO '		END) ||
	   			'OS' || mp_schema_id || '_' || in_obj_operation_set_id || ''')';
	   	COMMIT;
	END;

	PROCEDURE pr_oper_create(
		in_obj_operation_id			IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id		IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name				IN obj_operation	.object_name			%TYPE,
		in_object_type				IN obj_operation	.object_type			%TYPE,
		in_sel						IN obj_operation	.sel					%TYPE,
		in_ins						IN obj_operation	.ins					%TYPE,
		in_upd						IN obj_operation	.upd					%TYPE,
		in_del						IN obj_operation	.del					%TYPE,
		in_exe						IN obj_operation	.exe					%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_operation_y	VARCHAR2(128 BYTE)	:= '';
		m_comma_y		BOOLEAN				:= FALSE;
	BEGIN
		INSERT	INTO obj_operation	(	obj_operation_id,		obj_operation_set_id,		
										object_name,			object_type,
					sel,	ins,	upd,	del,	exe		)
				VALUES				(	in_obj_operation_id,	in_obj_operation_set_id,	
										in_object_name,			in_object_type,
					in_sel,	in_ins,	in_upd,	in_del,	in_exe	);
					
   	    IF ('Y' = in_exe) THEN
	    	pr_obj_operation_grant(	in_object_name,	in_obj_operation_set_id, 'EXECUTE', 'Y');
	   	ELSE
		    IF ('Y' = in_sel) THEN
				m_operation_y 	:= 'SELECT';
				m_comma_y		:= TRUE;
		   	END IF;
		    IF ('Y' = in_ins) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'INSERT';
				m_comma_y		:= TRUE;
		   	END IF;
		    IF ('Y' = in_upd) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'UPDATE';
				m_comma_y		:= TRUE;
		   	END IF;
		    IF ('Y' = in_del) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'DELETE';
				m_comma_y		:= TRUE;
		   	END IF;
		   	IF m_comma_y THEN
		    	pr_obj_operation_grant(in_object_name,	in_obj_operation_set_id, m_operation_y, 'Y');
		   	END IF;
		END IF;
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
			RAISE;
	END;
	
	PROCEDURE pr_oper_change(
		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name_o			IN obj_operation	.object_name			%TYPE,
		in_object_type_o			IN obj_operation	.object_type			%TYPE,
		in_sel_o					IN obj_operation	.sel					%TYPE,
		in_sel_n					IN obj_operation	.sel					%TYPE,
		in_ins_o					IN obj_operation	.ins					%TYPE,
		in_ins_n					IN obj_operation	.ins					%TYPE,
		in_upd_o					IN obj_operation	.upd					%TYPE,
		in_upd_n					IN obj_operation	.upd					%TYPE,
		in_del_o					IN obj_operation	.del					%TYPE,
		in_del_n					IN obj_operation	.del					%TYPE,
		in_exe_o					IN obj_operation	.exe					%TYPE,
		in_exe_n					IN obj_operation	.exe					%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_operation_y	VARCHAR2(128 BYTE)	:= '';
		m_comma_y		BOOLEAN				:= FALSE;
		m_operation_n	VARCHAR2(128 BYTE)	:= '';
		m_comma_n		BOOLEAN				:= FALSE;
	BEGIN
		UPDATE	obj_operation OO
			SET
				OO.sel	= in_sel_n,	OO.ins	= in_ins_n,	OO.upd	= in_upd_n,	OO.del	= in_del_n,	
				OO.exe	= in_exe_n	
			WHERE
				OO.obj_operation_id = in_obj_operation_id_o;
		
		
		IF (in_exe_o <> in_exe_n) THEN
	    	pr_obj_operation_grant(	in_object_name_o,	in_obj_operation_set_id_o, 'EXECUTE', in_exe_n);
		ELSE
			IF 		('N' = in_sel_o AND 'Y' = in_sel_n) THEN
				m_operation_y 	:= 'SELECT';
				m_comma_y		:= TRUE;
			ELSIF	('Y' = in_sel_o AND 'N' = in_sel_n) THEN
				m_operation_n 	:= 'SELECT';
				m_comma_n		:= TRUE;
			END IF;
			
			IF		('N' = in_ins_o AND 'Y' = in_ins_n) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'INSERT';
				m_comma_y		:= TRUE;
			ELSIF	('Y' = in_ins_o AND 'N' = in_ins_n) THEN
				m_operation_n	:= m_operation_n || (CASE WHEN m_comma_n THEN ', ' ELSE '' END) || 'INSERT';
				m_comma_n		:= TRUE;
			END IF;
			
		    IF		('N' = in_upd_o AND 'Y' = in_upd_n) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'UPDATE';
				m_comma_y		:= TRUE;
			ELSIF	('Y' = in_upd_o AND 'N' = in_upd_n) THEN
				m_operation_n	:= m_operation_n || (CASE WHEN m_comma_n THEN ', ' ELSE '' END) || 'UPDATE';
				m_comma_n		:= TRUE;
			END IF;
			
		    IF		('N' = in_del_o AND 'Y' = in_del_n) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'DELETE';
				m_comma_y		:= TRUE;
			ELSIF	('Y' = in_del_o AND 'N' = in_del_n) THEN
				m_operation_n	:= m_operation_n || (CASE WHEN m_comma_n THEN ', ' ELSE '' END) || 'DELETE';
				m_comma_n		:= TRUE;
			END IF;
			
		   	IF m_comma_y THEN
		    	pr_obj_operation_grant(in_object_name_o, in_obj_operation_set_id_o, m_operation_y, 'Y');
			END IF;
			BEGIN
			   	IF m_comma_n THEN
			    	pr_obj_operation_grant(in_object_name_o, in_obj_operation_set_id_o, m_operation_n, 'N');
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
				   	IF m_comma_y THEN
				    	pr_obj_operation_grant(in_object_name_o, in_obj_operation_set_id_o, m_operation_y, 'N');
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
	
	PROCEDURE pr_oper_drop(
		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name_o			IN obj_operation	.object_name			%TYPE,
		in_object_type_o			IN obj_operation	.object_type			%TYPE,
		in_sel_o					IN obj_operation	.sel					%TYPE,
		in_ins_o					IN obj_operation	.ins					%TYPE,
		in_upd_o					IN obj_operation	.upd					%TYPE,
		in_del_o					IN obj_operation	.del					%TYPE,
		in_exe_o					IN obj_operation	.exe					%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_operation_y	VARCHAR2(128 BYTE)	:= '';
		m_comma_y		BOOLEAN				:= FALSE;
	BEGIN
		DELETE FROM obj_operation OO WHERE OO.obj_operation_id = in_obj_operation_id_o;	
		
		IF ('Y' = in_exe_o) THEN
	    	pr_obj_operation_grant(	in_object_name_o,	in_obj_operation_set_id_o, 'EXECUTE', 'N');
	   	ELSE
		    IF ('Y' = in_sel_o) THEN
				m_operation_y 	:= 'SELECT';
				m_comma_y		:= TRUE;
		   	END IF;
		    IF ('Y' = in_ins_o) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'INSERT';
				m_comma_y		:= TRUE;
		   	END IF;
		    IF ('Y' = in_upd_o) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'UPDATE';
				m_comma_y		:= TRUE;
		   	END IF;
		    IF ('Y' = in_del_o) THEN
				m_operation_y	:= m_operation_y || (CASE WHEN m_comma_y THEN ', ' ELSE '' END) || 'DELETE';
				m_comma_y		:= TRUE;
		   	END IF;
		   	IF m_comma_y THEN
		    	pr_obj_operation_grant(in_object_name_o,	in_obj_operation_set_id_o, m_operation_y, 'N');
		   	END IF;
		END IF;
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN 
			ROLLBACK;
			RAISE;
	END;

	
	PROCEDURE pr_oper_create_transact(
		in_obj_operation_id			IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id		IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name				IN obj_operation	.object_name			%TYPE,
		in_object_type				IN obj_operation	.object_type			%TYPE,
		in_sel						IN obj_operation	.sel					%TYPE,
		in_ins						IN obj_operation	.ins					%TYPE,
		in_upd						IN obj_operation	.upd					%TYPE,
		in_del						IN obj_operation	.del					%TYPE,
		in_exe						IN obj_operation	.exe					%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	    m_id		obj_operation	.obj_operation_id	%TYPE;
	BEGIN
		pr_lock();
	
		IF in_obj_operation_id IS NULL THEN
			IF mp_obj_operation_id IS NULL THEN
				SELECT MAX(OO.obj_operation_id) INTO mp_obj_operation_id FROM obj_operation OO;
				IF mp_obj_operation_id IS NULL THEN
					mp_obj_operation_id := 1;
				ELSE
					mp_obj_operation_id := mp_obj_operation_id + 1;
				END IF;
			ELSE
				mp_obj_operation_id := mp_obj_operation_id + 1;
			END IF;
			pr_set_startval_for_seq('sq_obj_operation_i', mp_obj_operation_id);
			m_id := mp_obj_operation_id;
		ELSE
			m_id := in_obj_operation_id;
		END IF;
		
		m_cmd_cmt := 
	     	'CALL pkg_stec_operation_set.pr_oper_create('
				|| fn_num(m_id) || ', '
				|| fn_num(in_obj_operation_set_id) || ', '
				|| fn_str(in_object_name) || ', '
				|| fn_str(in_object_type) || ', '
				|| fn_str(in_sel) || ', '
				|| fn_str(in_ins) || ', '
				|| fn_str(in_upd) || ', '
				|| fn_str(in_del) || ', '
				|| fn_str(in_exe) ||  ')';
				
	    m_cmd_rlb := 
	    	'CALL pkg_stec_operation_set.pr_oper_drop('
				|| fn_num(m_id) || ', '
				|| fn_num(in_obj_operation_set_id) || ', '
				|| fn_str(in_object_name) || ', '
				|| fn_str(in_object_type) || ', '
				|| fn_str(in_sel) || ', '
				|| fn_str(in_ins) || ', '
				|| fn_str(in_upd) || ', '
				|| fn_str(in_del) || ', '
				|| fn_str(in_exe) ||  ')';
	    	
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

	PROCEDURE pr_oper_drop_transact(
		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name_o			IN obj_operation	.object_name			%TYPE,
		in_object_type_o			IN obj_operation	.object_type			%TYPE,
		in_sel_o					IN obj_operation	.sel					%TYPE,
		in_ins_o					IN obj_operation	.ins					%TYPE,
		in_upd_o					IN obj_operation	.upd					%TYPE,
		in_del_o					IN obj_operation	.del					%TYPE,
		in_exe_o					IN obj_operation	.exe					%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	     	'CALL pkg_stec_operation_set.pr_oper_drop('
				|| fn_num(in_obj_operation_id_o) || ', '
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_str(in_object_name_o) || ', '
				|| fn_str(in_object_type_o) || ', '
				|| fn_str(in_sel_o) || ', '
				|| fn_str(in_ins_o) || ', '
				|| fn_str(in_upd_o) || ', '
				|| fn_str(in_del_o) || ', '
				|| fn_str(in_exe_o) ||  ')';
				
	    m_cmd_rlb := 
	    	'CALL pkg_stec_operation_set.pr_oper_create('
				|| fn_num(in_obj_operation_id_o) || ', '
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_str(in_object_name_o) || ', '
				|| fn_str(in_object_type_o) || ', '
				|| fn_str(in_sel_o) || ', '
				|| fn_str(in_ins_o) || ', '
				|| fn_str(in_upd_o) || ', '
				|| fn_str(in_del_o) || ', '
				|| fn_str(in_exe_o) ||  ')';
	    	
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
	
	PROCEDURE pr_oper_change_transact(
		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
		in_object_name_o			IN obj_operation	.object_name			%TYPE,
		in_object_type_o			IN obj_operation	.object_type			%TYPE,
		in_sel_o					IN obj_operation	.sel					%TYPE,
		in_sel_n					IN obj_operation	.sel					%TYPE,
		in_ins_o					IN obj_operation	.ins					%TYPE,
		in_ins_n					IN obj_operation	.ins					%TYPE,
		in_upd_o					IN obj_operation	.upd					%TYPE,
		in_upd_n					IN obj_operation	.upd					%TYPE,
		in_del_o					IN obj_operation	.del					%TYPE,
		in_del_n					IN obj_operation	.del					%TYPE,
		in_exe_o					IN obj_operation	.exe					%TYPE,
		in_exe_n					IN obj_operation	.exe					%TYPE
	)  AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction	.cmd_commit			%TYPE;
	    m_cmd_rlb	a_transaction	.cmd_rollback		%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	     	'CALL pkg_stec_operation_set.pr_oper_change('
				|| fn_num(in_obj_operation_id_o) || ', '
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_str(in_object_name_o) || ', '
				|| fn_str(in_object_type_o) || ', '
				|| fn_str(in_sel_o) || ', '
				|| fn_str(in_sel_n) || ', '
				|| fn_str(in_ins_o) || ', '
				|| fn_str(in_ins_n) || ', '
				|| fn_str(in_upd_o) || ', '
				|| fn_str(in_upd_n) || ', '
				|| fn_str(in_del_o) || ', '
				|| fn_str(in_del_n) || ', '
				|| fn_str(in_exe_o) || ', '
				|| fn_str(in_exe_n) ||  ')';
				
	    m_cmd_rlb := 
	    	'CALL pkg_stec_operation_set.pr_oper_change('
				|| fn_num(in_obj_operation_id_o) || ', '
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_str(in_object_name_o) || ', '
				|| fn_str(in_object_type_o) || ', '
				|| fn_str(in_sel_n) || ', '
				|| fn_str(in_sel_o) || ', '
				|| fn_str(in_ins_n) || ', '
				|| fn_str(in_ins_o) || ', '
				|| fn_str(in_upd_n) || ', '
				|| fn_str(in_upd_o) || ', '
				|| fn_str(in_del_n) || ', '
				|| fn_str(in_del_o) || ', '
				|| fn_str(in_exe_n) || ', '
				|| fn_str(in_exe_o) ||  ')';
	    	
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
	
	PROCEDURE pr_oper_set_create(
		in_obj_operation_set_id		IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant					IN obj_operation_set	.constant				%TYPE,
		in_name						IN obj_operation_set	.name					%TYPE
  	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		m_id	obj_operation_set.obj_operation_set_id%TYPE;
	BEGIN
		
		INSERT 	INTO obj_operation_set	(obj_operation_set_id,		constant,		name)
				VALUES					(in_obj_operation_set_id,	in_constant,	in_name);
				
		IF in_obj_operation_set_id IS NULL THEN
			SELECT sq_obj_operation_set_i.CURRVAL INTO m_id FROM DUAL;
		ELSE
			m_id := in_obj_operation_set_id;
		END IF;
		pkg_stec_account.pr_ora_role_create('OS' || mp_schema_id || '_' || m_id);
		
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;
	
	PROCEDURE pr_oper_set_drop(
		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant_o				IN obj_operation_set	.constant				%TYPE,
		in_name_o					IN obj_operation_set	.name					%TYPE
  	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		
		DELETE FROM obj_operation_set OOS WHERE OOS.obj_operation_set_id = in_obj_operation_set_id_o;
		
		pkg_stec_account.pr_ora_role_drop('OS' || mp_schema_id || '_' || in_obj_operation_set_id_o);
		
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;
	
	PROCEDURE pr_oper_set_change(
		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant_n				IN obj_operation_set	.constant				%TYPE,
		in_name_n					IN obj_operation_set	.name					%TYPE
  	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		
		UPDATE obj_operation_set OOS
			SET
				OOS.constant				= in_constant_n,
				OOS.name					= in_name_n
			WHERE
				OOS.obj_operation_set_id	= in_obj_operation_set_id_o;
			
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;

	PROCEDURE pr_oper_set_create_transact(
		in_obj_operation_set_id		IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant					IN obj_operation_set	.constant				%TYPE,
		in_name						IN obj_operation_set	.name					%TYPE
  	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction		.cmd_commit				%TYPE;
	    m_cmd_rlb	a_transaction		.cmd_rollback			%TYPE;
	    m_id		obj_operation_set	.obj_operation_set_id	%TYPE;
	BEGIN
		pr_lock();
	
		IF in_obj_operation_set_id IS NULL THEN
			IF mp_obj_operation_set_id IS NULL THEN
				SELECT MAX(OS.obj_operation_set_id) INTO mp_obj_operation_set_id FROM obj_operation_set OS;
				IF mp_obj_operation_set_id IS NULL THEN
					mp_obj_operation_set_id := 1;
				ELSE
					mp_obj_operation_set_id := mp_obj_operation_set_id + 1;
				END IF;
			ELSE
				mp_obj_operation_set_id := mp_obj_operation_set_id + 1;
			END IF;
			pr_set_startval_for_seq('sq_obj_operation_i', mp_obj_operation_set_id);
			m_id := mp_obj_operation_set_id;
		ELSE
			m_id := in_obj_operation_set_id;
		END IF;
		
		m_cmd_cmt := 
	     	'CALL pkg_stec_operation_set.pr_oper_set_create('
				|| fn_num(m_id) || ', '
				|| fn_str(in_constant) || ', '
				|| fn_str(in_name) || ')';
				
	    m_cmd_rlb := 
	    	'CALL pkg_stec_operation_set.pr_oper_set_drop('
				|| fn_num(m_id) || ', '
				|| fn_str(in_constant) || ', '
				|| fn_str(in_name) || ')';
	    	
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
	
	PROCEDURE pr_oper_set_drop_transact(
		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant_o				IN obj_operation_set	.constant				%TYPE,
		in_name_o					IN obj_operation_set	.name					%TYPE
  	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction		.cmd_commit				%TYPE;
	    m_cmd_rlb	a_transaction		.cmd_rollback			%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	    	'CALL pkg_stec_operation_set.pr_oper_set_drop('
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_str(in_constant_o) || ', '
				|| fn_str(in_name_o) || ')';
				
	    m_cmd_rlb := 
	     	'CALL pkg_stec_operation_set.pr_oper_set_create('
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_str(in_constant_o) || ', '
				|| fn_str(in_name_o) || ')';
	    	
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
	
	PROCEDURE pr_oper_set_change_transact(
		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
		in_constant_o				IN obj_operation_set	.constant				%TYPE,
		in_constant_n				IN obj_operation_set	.constant				%TYPE,
		in_name_o					IN obj_operation_set	.name					%TYPE,
		in_name_n					IN obj_operation_set	.name					%TYPE
  	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	    m_cmd_cmt	a_transaction		.cmd_commit				%TYPE;
	    m_cmd_rlb	a_transaction		.cmd_rollback			%TYPE;
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
	    	'CALL pkg_stec_operation_set.pr_oper_set_change('
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_str(in_constant_n) || ', '
				|| fn_str(in_name_n) || ')';
				
	    m_cmd_rlb := 
	     	'CALL pkg_stec_operation_set.pr_oper_set_change('
				|| fn_num(in_obj_operation_set_id_o) || ', '
				|| fn_str(in_constant_o) || ', '
				|| fn_str(in_name_o) || ')';
	    	
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