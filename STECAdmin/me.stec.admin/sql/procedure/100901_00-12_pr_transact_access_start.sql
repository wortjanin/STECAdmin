CREATE OR REPLACE PROCEDURE pr_transact_access_start
AS
-- PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	pkg_stec_access.pr_lock();
--	COMMIT;
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE;
END;
/
--------------------------------------------------------------------------------
