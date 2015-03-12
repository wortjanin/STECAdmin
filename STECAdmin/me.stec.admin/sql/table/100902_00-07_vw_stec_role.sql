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

CREATE OR REPLACE VIEW vw_stec_role AS
SELECT  								-- #	СТЭК-роль,				StecRole
SR.stec_role_id,  						-- #	ИН СТЭК-роли,			Id,				,			,				true 
SR.name,								-- #	Имя,					Name,			,			,				,					,				true
SR.master_stec_role_id,					-- #	ИН Мастер-СТЭК-роли,	IdMasterStecRole			 
SR.stec_accessor_id						-- #	ИН аксессора,			IdStecAccessor,				false,			true
FROM stec_role SR;

--	PROCEDURE pr_stec_role_create_transact(
--			in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
--			in_name							IN stec_role		.name					%TYPE,
--			in_master_stec_role_id			IN stec_role		.master_stec_role_id	%TYPE
--	  	);

--	PROCEDURE pr_stec_role_change_transact(
--			in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
--			in_name_o						IN stec_role		.name					%TYPE,
--			in_name_n						IN stec_role		.name					%TYPE,
--			in_master_stec_role_id_o		IN stec_role		.master_stec_role_id	%TYPE,
--			in_master_stec_role_id_n		IN stec_role		.master_stec_role_id	%TYPE
--		);

--	PROCEDURE pr_stec_role_drop_transact(
--			in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
--			in_name_o						IN stec_role		.name					%TYPE,
--			in_master_stec_role_id_o		IN stec_role		.master_stec_role_id	%TYPE,
--			in_stec_accessor_id_o			IN stec_accessor	.stec_accessor_id		%TYPE
--		);

CREATE OR REPLACE TRIGGER tr_vw_stec_role_iiud
INSTEAD OF INSERT OR UPDATE OR DELETE
ON vw_stec_role
FOR EACH ROW
BEGIN
	IF		INSERTING	THEN
		pkg_stec_access.pr_stec_role_create_transact( /* :NEW.stec_role_id */ NULL,
	  		:NEW.name, :NEW.master_stec_role_id);
	ELSIF	UPDATING	THEN
		pkg_stec_access.pr_stec_role_change_transact(
		  	:OLD.stec_role_id, 
		  	:OLD.name,					:NEW.name, 
		  	:OLD.master_stec_role_id,	:NEW.master_stec_role_id);
	ELSIF	DELETING	THEN
		pkg_stec_access.pr_stec_role_drop_transact(	:OLD.stec_role_id,
			:OLD.name, :OLD.master_stec_role_id, 
			:OLD.stec_accessor_id	);
	END IF;	
END;
/

--------------------------------------------------------------------------------
