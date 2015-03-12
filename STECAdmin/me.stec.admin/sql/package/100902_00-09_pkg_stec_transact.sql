CREATE OR REPLACE PACKAGE pkg_stec_transact AS
-- RULE: DO NOT ALLOW USERS to use it directly!
-- Use this package directly ONLY in other packages
-- (Ignorance of this rule can lead to serious errors)
	
	-- the main purpose of in_cmd_on_complete 
	-- is to give pkg_stec_transact a function releasing locks in the calling object 
	-- on the (successful or not) end of transaction
	PROCEDURE pr_start(	in_cmd_on_complete	IN VARCHAR2	DEFAULT NULL );
	
	PROCEDURE pr_add_operation(
		in_cmd_commit		IN a_transaction	.cmd_commit		%TYPE,
		in_cmd_rollback		IN a_transaction	.cmd_rollback	%TYPE
	);
	
	PROCEDURE pr_complete(
		in_commit			IN CHAR	DEFAULT 'N');
	
	-- 'Y'->Yes, 'N'->No, NULL->transaction has not been started
	FUNCTION fn_is_active RETURN CHAR;
END;
/

CREATE OR REPLACE
PACKAGE BODY pkg_stec_transact AS

	mp_is_active					CHAR(1) 			:= 'N';
	
	FUNCTION fn_is_active  RETURN CHAR
	AS  PRAGMA AUTONOMOUS_TRANSACTION;
		m_cnt INT :=0;
	BEGIN
		SELECT COUNT(*) INTO m_cnt
			FROM a_transaction_locker ATL
			WHERE ATL.login = USER;
		IF m_cnt < 1 THEN
			RETURN NULL;
		END IF;
		RETURN mp_is_active;
	END;
	
	PROCEDURE pr_execute_immediate(in_cmd	IN VARCHAR2)
	AS  PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		EXECUTE IMMEDIATE in_cmd;
		COMMIT;
	END;


	-- be sure that a package call this function once
	PROCEDURE pr_clear
	AS PRAGMA AUTONOMOUS_TRANSACTION;
		CURSOR cur_cmd_on_complete IS
			SELECT	ATL.cmd_on_complete
				FROM a_transaction_locker ATL
				WHERE	ATL.login = USER	
				ORDER BY ATL.a_transaction_locker_id DESC;
	BEGIN
		FOR rec_on_complete IN cur_cmd_on_complete LOOP
			BEGIN
				IF NOT rec_on_complete.cmd_on_complete IS NULL THEN
					pr_execute_immediate(rec_on_complete.cmd_on_complete);
				END IF;
			EXCEPTION
				WHEN OTHERS THEN NULL;
			END;
		END LOOP;
		
		DELETE FROM  a_transaction ATR1
			WHERE ATR1.a_transaction_id IN
				(SELECT ATR.a_transaction_id FROM a_transaction ATR, a_transaction_locker ATL
					WHERE	ATR.a_transaction_locker_id = ATL.a_transaction_locker_id AND
							ATL.login					= USER);
		DELETE FROM a_transaction_locker ATL
			WHERE	ATL.login = USER;

		COMMIT;
	END;

	PROCEDURE pr_start(
		in_cmd_on_complete	IN VARCHAR2	DEFAULT NULL
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		--The dbms_lock seems useless here, as we have a unique constrain on name field in a_transaction_locker table
		
		INSERT 	INTO a_transaction_locker	(name,						login,	cmd_on_complete)
				VALUES						(SYS.pkg_stec.fn_my_caller,	USER,	in_cmd_on_complete);
				
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			IF NOT in_cmd_on_complete IS NULL THEN
				BEGIN
					pr_execute_immediate(in_cmd_on_complete);
				EXCEPTION
					WHEN OTHERS THEN NULL;
				END;
			END IF;
			pr_clear();
			RAISE_APPLICATION_ERROR(-20012, '
Похожая операция уже выполняется в другом сеансе,
Подождите 1 минуту и попробуйте ещё раз.
В случае проблем - обращайтесь к Администратору Системы.
');
	END;

	PROCEDURE pr_add_operation(
		in_cmd_commit	IN a_transaction.cmd_commit%TYPE,
		in_cmd_rollback	IN a_transaction.cmd_rollback%TYPE
	) AS  PRAGMA AUTONOMOUS_TRANSACTION;
		m_locker_id a_transaction_locker.a_transaction_locker_id%TYPE;
	BEGIN
		SELECT ATL.a_transaction_locker_id INTO m_locker_id
			FROM a_transaction_locker ATL
			WHERE ATL.name = SYS.pkg_stec.fn_my_caller;
		INSERT 	INTO a_transaction	(cmd_commit,	cmd_rollback,		a_transaction_locker_id)
				VALUES				(in_cmd_commit,	in_cmd_rollback,	m_locker_id);
		COMMIT;
	END;
	
	-- in the future it is planned to remove this check (it is to prevent programming errors)
	PROCEDURE pr_check
	AS
		m_cnt INT := 0;
	BEGIN
		SELECT COUNT(*) INTO m_cnt 
			FROM a_transaction ATR, a_transaction_locker ATL
			WHERE	ATL.a_transaction_locker_id = ATR.a_transaction_locker_id	AND	
					ATL.login					= USER							AND
					ATR.done					= 'Y';
		IF m_cnt > 0 THEN
			RAISE_APPLICATION_ERROR(-20011, '
Incorrect transaction input 
(probably there is an interrupted transaction from a different user).
');
		END IF;
	END;

	PROCEDURE pr_perform
	AS  PRAGMA AUTONOMOUS_TRANSACTION;
	
		CURSOR cur_a_transaction_commit IS
			SELECT	ATR.a_transaction_id,
					ATR.cmd_commit
				FROM a_transaction ATR, a_transaction_locker ATL
				WHERE	ATL.a_transaction_locker_id = ATR.a_transaction_locker_id	AND
						ATL.login					= USER							AND
						ATR.done					= 'N'	
				ORDER BY ATR.a_transaction_id;
				
		CURSOR cur_a_transaction_rollback IS
			SELECT	ATR.a_transaction_id,
					ATR.cmd_rollback
				FROM a_transaction ATR, a_transaction_locker ATL
				WHERE	ATL.a_transaction_locker_id = ATR.a_transaction_locker_id	AND
						ATL.login					= USER							AND
						ATR.done					= 'Y'	
				ORDER BY ATR.a_transaction_id DESC;

		m_checked	CHAR(1) := 'N';
	BEGIN
		pr_check();
		m_checked := 'Y';
		
		FOR rec_a_transaction IN cur_a_transaction_commit LOOP
			UPDATE a_transaction ATR 
				SET ATR.done = 'Y' 
				WHERE ATR.a_transaction_id = rec_a_transaction.a_transaction_id;
			pr_execute_immediate(rec_a_transaction.cmd_commit);
			COMMIT;
		END LOOP;

		pr_clear();
		COMMIT;	
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			IF 'N' = m_checked THEN
				RAISE;
			END IF;
	
			BEGIN
				FOR rec_a_transaction IN cur_a_transaction_rollback LOOP
					DELETE FROM a_transaction ATR  
						WHERE ATR.a_transaction_id = rec_a_transaction.a_transaction_id;
					pr_execute_immediate(rec_a_transaction.cmd_rollback);
					COMMIT;
				END LOOP;
				pr_clear();
				COMMIT;
			EXCEPTION
				WHEN OTHERS THEN
					ROLLBACK;
					RAISE;
			END;
			RAISE;
	END;
	
	PROCEDURE pr_complete
		(in_commit	IN CHAR DEFAULT 'N')
	AS PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		IF fn_is_active IS NULL THEN
			RETURN;
		END IF;

		-- in the future it is planned to remove this check (it is to prevent programming errors)
		IF ('Y'= mp_is_active) THEN
			RAISE_APPLICATION_ERROR(-20011, '
A recursive call of pkg_stec_transact.pr_complete is not allowed.
');
		END IF;
		mp_is_active := 'Y';
		IF 'Y' = in_commit THEN
			pr_perform();
		ELSE
			pr_clear();	
		END IF;
		mp_is_active := 'N';
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			mp_is_active := 'N';
			RAISE;
	END;

END;
/

--------------------------------------------------------------------------------
