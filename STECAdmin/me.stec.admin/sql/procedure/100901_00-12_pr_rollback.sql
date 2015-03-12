CREATE OR REPLACE PROCEDURE pr_rollback
AS
-- PRAGMA AUTONOMOUS_TRANSACTION;
-- use this procedure only for those queries, which use pkg_stec_transact (directly or not)
BEGIN
	IF 'N' = pkg_stec_transact.fn_is_active THEN
		pkg_stec_transact.pr_complete('N');
	END IF;
	ROLLBACK;
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE;
END;
/

--------------------------------------------------------------------------------
