CREATE OR REPLACE PROCEDURE pr_clear_session
AS
-- PRAGMA AUTONOMOUS_TRANSACTION;
--  This procedure is used by TR_STEC_CLEAR_SESSION_BLOD
--	Also you are strongly recommended to 
-- 		use this function after every change of the database structure  (just in case)
--	NOTE: this function is open to any reasonable changes
BEGIN
	-- always rollback transactions on the end of session (otherwise there will be "lock" errors)
	-- if you need to commit any changes, you call pr_commit before the session quit.
	pr_rollback();
EXCEPTION
	WHEN OTHERS THEN
		NULL;
END;
/

--------------------------------------------------------------------------------
