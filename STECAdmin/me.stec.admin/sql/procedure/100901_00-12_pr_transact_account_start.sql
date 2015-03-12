CREATE OR REPLACE PROCEDURE pr_transact_account_start
AS
-- PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	pkg_stec_account.pr_lock();
--	COMMIT;
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE;
END;
/

--------------------------------------------------------------------------------
