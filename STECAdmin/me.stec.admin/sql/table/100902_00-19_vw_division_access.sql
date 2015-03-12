--
-- NOTE! DO NOT FORGET TO CALL pkg_stec_access.pr_lock_release() AFTER INSERT/UPDATE/DELETE ON vw_stec_role
--

--	
-- #	PackageName		me.stec.admin.logic.user
--
-- #	Sequence		sq_stec_user_i	
--
--												Caption,				Name(1),		jType,		dbLoadInList, 	dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull,	isMinMax
--
--					   SchemeName				ClassSummary,			ClassName(1),	,       	,				Scheme.ReadOnly

CREATE OR REPLACE VIEW vw_division_access AS
SELECT  					-- #	СТЭК-роль,				StecRole
DA.division_access_id,		-- #	ИН СТЭК-роли,			Id,				,			,				true 
DA.stec_accessor_id,		-- #	Имя,					Name,			,			,				,					,				true
DA.master_stec_role_id,		-- #	Имя,					Name,			,			,				,					,				true
DA.obj_operation_set_id,	-- #	Имя,					Name,			,			,				,					,				true
DA.division_id,				-- #	Имя,					Name,			,			,				,					,				true
DA.is_grantable,			-- #	Имя,					Name,			,			,				,					,				true
DA.temp_login_block			-- #	Имя,					Name,			,			,				,					,				true
FROM division_access DA;

--	PROCEDURE pr_access_create_transact(
--		in_division_access_id			IN division_access	.division_access_id		%TYPE,
--		in_stec_accessor_id				IN division_access	.stec_accessor_id		%TYPE,
--		in_master_stec_role_id			IN division_access	.master_stec_role_id	%TYPE,
--		in_obj_operation_set_id			IN division_access	.obj_operation_set_id	%TYPE,
--		in_division_id					IN division_access	.division_id			%TYPE,
--		in_is_grantable					IN division_access	.is_grantable			%TYPE,
--		in_temp_login_block				IN division_access	.temp_login_block		%TYPE
--	)

--  PROCEDURE pr_access_change_transact(
--      in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
--      in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
--      in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
--      in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
--      in_division_id_o				IN division_access	.division_id			%TYPE,
--      in_division_id_n				IN division_access	.division_id			%TYPE,
--      in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
--      in_is_grantable_n				IN division_access	.is_grantable			%TYPE,
--      in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE,
--      in_temp_login_block_n			IN division_access	.temp_login_block		%TYPE
--    )
--	PROCEDURE pr_access_drop_transact(
--		in_division_access_id_o			IN division_access	.division_access_id		%TYPE,
--		in_stec_accessor_id_o			IN division_access	.stec_accessor_id		%TYPE,
--		in_master_stec_role_id_o		IN division_access	.master_stec_role_id	%TYPE,
--		in_obj_operation_set_id_o		IN division_access	.obj_operation_set_id	%TYPE,
--		in_division_id_o				IN division_access	.division_id			%TYPE,
--		in_is_grantable_o				IN division_access	.is_grantable			%TYPE,
--		in_temp_login_block_o			IN division_access	.temp_login_block		%TYPE
--	)

CREATE OR REPLACE TRIGGER tr_vw_division_access_iiud
INSTEAD OF INSERT OR UPDATE OR DELETE
ON vw_division_access
FOR EACH ROW
BEGIN
	IF		INSERTING	THEN
		pkg_stec_access.pr_access_create_transact( /*:NEW.division_access_id*/ NULL,
	  		:NEW.stec_accessor_id,	:NEW.master_stec_role_id,	:NEW.obj_operation_set_id,
			:NEW.division_id,		:NEW.is_grantable,			:NEW.temp_login_block	  	);
	ELSIF	UPDATING	THEN
		pkg_stec_access.pr_access_change_transact(
			:OLD.division_access_id,
			:OLD.stec_accessor_id,		
			:OLD.master_stec_role_id,	
			:OLD.obj_operation_set_id,	
			:OLD.division_id,			:NEW.division_id,
			:OLD.is_grantable,			:NEW.is_grantable,
			:OLD.temp_login_block,		:NEW.temp_login_block );
	ELSIF	DELETING	THEN
		pkg_stec_access.pr_access_drop_transact( :OLD.division_access_id,	
			:OLD.stec_accessor_id,	:OLD.master_stec_role_id,	:OLD.obj_operation_set_id,
			:OLD.division_id, :OLD.is_grantable, :OLD.temp_login_block);
	END IF;
END;
/


--------------------------------------------------------------------------------
