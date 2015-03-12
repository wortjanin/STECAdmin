-- NOTE, THAT ONLY ONE USER PER STEC SCHEMA AT A TIME CAN WRITE TO THIS TABLE 
-- DIRECT ACCESS TO THIS TABLE IS NOT ALLOWED!!

-- This table is to allow a transaction mechanism for DDL, DCL operators
-- or for a mix of DML, DDL, and DCL operators
CALL pr_create_if_not_exists(
'CREATE TABLE				a_transaction     
 (															' ||
'	a_transaction_id		INT					NOT NULL,	' || 
'	cmd_commit				VARCHAR2(2000 CHAR)	NOT NULL,	' || 
'	cmd_rollback			VARCHAR2(2000 CHAR)	NOT NULL,	' || 
'	done					CHAR(1 BYTE)		NOT NULL,	' || 
'	a_transaction_locker_id	INT					NOT NULL,	' || 
'	CONSTRAINT fk_a_transaction_lk
	FOREIGN KEY	( a_transaction_locker_id )	REFERENCES a_transaction_locker	(a_transaction_locker_id),	' ||
'	CONSTRAINT ck_a_transaction_dn	CHECK	(done IN (''Y'', ''N'')),	' ||
'	CONSTRAINT pk_a_transaction_id     
	PRIMARY KEY ( a_transaction_id ) 
	ENABLE                     
 )											' 
);

-- CALL pr_drop_if_exists ('DROP SEQUENCE sq_a_transaction_i ');
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_a_transaction_i START WITH 1 INCREMENT BY 1 MAXVALUE 1000000000000 CYCLE');

CREATE OR REPLACE TRIGGER tr_a_transaction_biud 
BEFORE INSERT OR UPDATE OR DELETE ON a_transaction
FOR EACH ROW
BEGIN
-- -- we cannot say exactly who is the caller of this trigger
	IF ( SYS.pkg_stec.fn_my_caller <> ('<package body ' || pkg_stec_session.fn_schema || '.PKG_STEC_TRANSACT>'))  THEN 
		RAISE_APPLICATION_ERROR(-20011, 'Cannot insert/update/delete directly'); 
	END IF;
	
	IF    INSERTING THEN
		SELECT sq_a_transaction_i.NEXTVAL INTO :NEW.a_transaction_id FROM DUAL;
		SELECT 'N' INTO :NEW.done FROM DUAL;
	END IF;
END;
/


CREATE OR REPLACE FUNCTION FN_PLC_A_TRANSACTION_S
(
    p_schema  IN VARCHAR2,
    p_table   IN VARCHAR2
)
RETURN VARCHAR
AS
BEGIN
  RETURN '(1=0)';
END;
/

--  begin
--    dbms_rls.drop_policy(
--      object_schema => fn_stec_schema,
--      object_name => 'A_TRANSACTION',
--      policy_name => 'PLC_A_TRANSACTION_S'
--    );
--  end;
--  /

DECLARE
    ex EXCEPTION; 
    PRAGMA EXCEPTION_INIT ( ex, -28101); 
BEGIN
  sys.dbms_rls.add_policy (
    object_schema     		=> fn_stec_schema,
    object_name      		=> 'A_TRANSACTION',
    policy_name       		=> 'PLC_A_TRANSACTION_S',
    function_schema   		=> fn_stec_schema,
    policy_function   		=> 'FN_PLC_A_TRANSACTION_S',
    statement_types   		=> 'SELECT',
--    update_check      		=> FALSE,
    sec_relevant_cols		=> 'cmd_commit, cmd_rollback',
    sec_relevant_cols_opt	=> dbms_rls.ALL_ROWS
  );
EXCEPTION
	WHEN ex THEN NULL;
END;
/


DECLARE
	m_cnt INT := 0;
BEGIN
	SELECT COUNT(*) INTO m_cnt FROM a_dangerous_object ADO 
		WHERE ADO.object_name='A_TRANSACTION' AND ADO.object_type= 'TB';
	IF m_cnt < 1 THEN
		INSERT 	INTO a_dangerous_object	(object_name, 		object_type, 	description)
		   		VALUES					('A_TRANSACTION',	'TB',			'Таблица a_transaction содержит поля cmd_commit и cmd_rollback (команды выполнения и отката) - прямой доступ к этип полям на чтение/запись серьёзно нарушает политику безопасности');
		COMMIT;
	END IF;
END;
/

-- SELECT * FROM a_dangerous_object;
--------------------------------------------------------------------------------
