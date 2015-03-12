CREATE OR REPLACE PROCEDURE pr_set_startval_for_seq
    (	in_sequence_name	IN VARCHAR2,
    	in_start_val		IN INT DEFAULT 1) 
-- it is highly recommended to use this procedure only in sections
-- guarded by a_transaction_locker
AS  PRAGMA AUTONOMOUS_TRANSACTION;
  m_max_id INT;
    
  lock_id   VARCHAR2(128);
	code      NUMBER;
  lock_name   VARCHAR2(128) := fn_stec_schema || '__pr_set_startval_for_seq__' || in_sequence_name;
  lock_exists EXCEPTION; 

BEGIN
	DBMS_LOCK.ALLOCATE_UNIQUE(lock_name, lock_id); 
	code := DBMS_LOCK.REQUEST(lock_id, DBMS_LOCK.X_MODE);
	IF 0 = code THEN 

		EXECUTE IMMEDIATE 'SELECT ' || in_sequence_name || '.NEXTVAL FROM DUAL'
	      INTO m_max_id;
		IF in_start_val - 1 <> m_max_id THEN
	        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || in_sequence_name || ' INCREMENT BY ' || 
	          (in_start_val - 1 - m_max_id) || ' MINVALUE ' || 
	          ( in_start_val - 1 );
	        EXECUTE IMMEDIATE 'SELECT ' || in_sequence_name || '.NEXTVAL FROM DUAL'
	          INTO m_max_id;
	        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || in_sequence_name || ' INCREMENT BY 1';
		END IF;
  
	ELSE     
		RAISE lock_exists;
	END IF;
			
	code := DBMS_LOCK.RELEASE(lock_id);
  COMMIT;
EXCEPTION
  WHEN lock_exists THEN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(-20002, '
Похожая операция выполняется в другом сеансе,
подождите 1 минуту и попробуйте снова.
В случае проблем, обращайтесь к Администратору Системы.
');
 WHEN OTHERS THEN
 	ROLLBACK;
 	code := DBMS_LOCK.RELEASE(lock_id);
 	RAISE;
END;
/

--------------------------------------------------------------------------------
