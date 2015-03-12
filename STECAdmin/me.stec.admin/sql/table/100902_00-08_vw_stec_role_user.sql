CREATE OR REPLACE VIEW vw_stec_role_user AS
SELECT  
SRU.stec_role_user_id, 
SRU.stec_role_id,
SRU.stec_user_id,
SRU.temp_login_block
FROM stec_role_user SRU;

--	PROCEDURE pr_role_user_link_transact(
--			in_stec_role_user_id			IN stec_role_user	.stec_role_user_id		%TYPE,
--			in_stec_role_id					IN stec_role		.stec_role_id			%TYPE,
--			in_stec_user_id					IN stec_user		.stec_user_id			%TYPE,
--			in_temp_login_block				IN stec_role_user	.temp_login_block		%TYPE
--		)
--	PROCEDURE pr_role_user_relink_transact(
--		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
--		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
--		in_stec_role_id_n				IN stec_role		.stec_role_id			%TYPE,
--		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
--		in_stec_user_id_n				IN stec_user		.stec_user_id			%TYPE,
--		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE,
--		in_temp_login_block_n			IN stec_role_user	.temp_login_block		%TYPE
--	);	

--	PROCEDURE pr_role_user_unlink_transact(
--		in_stec_role_user_id_o			IN stec_role_user	.stec_role_user_id		%TYPE,
--		in_stec_role_id_o				IN stec_role		.stec_role_id			%TYPE,
--		in_stec_user_id_o				IN stec_user		.stec_user_id			%TYPE,
--		in_temp_login_block_o			IN stec_role_user	.temp_login_block		%TYPE
--	);

CREATE OR REPLACE TRIGGER tr_vw_stec_role_user_iiud
INSTEAD OF INSERT OR UPDATE OR DELETE
ON vw_stec_role_user
FOR EACH ROW
DECLARE
	m_blk stec_role_user.temp_login_block%TYPE;
BEGIN
	IF		INSERTING OR UPDATING	THEN
		IF ( SYS.pkg_stec.fn_my_caller IN ( '<package body ' || pkg_stec_session.fn_schema || '.PKG_STEC_ACCESS>') )  THEN 
			m_blk := :NEW.temp_login_block;
		ELSE
			SELECT SL.pw_is_temp INTO m_blk
				FROM stec_login SL
				WHERE SL.stec_user_id = :NEW.stec_user_id;
		END IF;
    
		IF		INSERTING	THEN
			pkg_stec_access.pr_role_user_link_transact(/*:NEW.stec_role_user_id*/ NULL, 
				:NEW.stec_role_id, :NEW.stec_user_id, m_blk);
		ELSIF	UPDATING	THEN
			pkg_stec_access.pr_role_user_relink_transact(:OLD.stec_role_user_id, 
				:OLD.stec_role_id,		:NEW.stec_role_id,
				:OLD.stec_user_id,		:NEW.stec_user_id,
				:OLD.temp_login_block,	m_blk);
		END IF;
	ELSIF	DELETING	THEN
		pkg_stec_access.pr_role_user_unlink_transact(:OLD.stec_role_user_id, 
			:OLD.stec_role_id,	:OLD.stec_user_id,	:OLD.temp_login_block	);
	END IF;
  
  
END;
/


--------------------------------------------------------------------------------
