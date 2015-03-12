-- it is to separate different transactions started by different packages in different sessions
CALL pr_create_if_not_exists(
'CREATE TABLE				a_transaction_locker     
 (																	' ||
'	a_transaction_locker_id	INT						NOT NULL,		' || 
'	name					VARCHAR2(512	CHAR)	NOT NULL,		' || 
'	login					VARCHAR2(30		BYTE)	NOT NULL,		' || 
'	cmd_on_complete			VARCHAR2(2000	CHAR)	DEFAULT NULL,	' || 
'	CONSTRAINT uq_a_transaction_locker UNIQUE (name),				' ||
'	CONSTRAINT pk_a_transaction_locker_id     
	PRIMARY KEY ( a_transaction_locker_id ) 
	ENABLE                     
 )											' 
);
-- CALL pr_drop_if_exists ('DROP SEQUENCE sq_a_transaction_locker_i ');
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_a_transaction_locker_i START WITH 1 INCREMENT BY 1 MAXVALUE 10000000000 CYCLE');

-- DROP TRIGGER tr_a_transaction_locker_biud ;
CREATE OR REPLACE TRIGGER tr_a_transaction_locker_biud 
BEFORE INSERT OR UPDATE OR DELETE ON a_transaction_locker
FOR EACH ROW
DECLARE
	m_cnt a_transaction_locker.a_transaction_locker_id%TYPE :=0 ;
BEGIN
	IF ( NOT (SYS.pkg_stec.fn_my_caller IN ( 
			'<package body ' || pkg_stec_session.fn_schema || '.PKG_STEC_TRANSACT>')) )  THEN 
		RAISE_APPLICATION_ERROR(-20001, 'Cannot insert/update/delete directly'); 
	END IF;
	
	IF    INSERTING THEN
		SELECT sq_a_transaction_locker_i.NEXTVAL INTO :NEW.a_transaction_locker_id FROM DUAL;
	END IF;
END;
/
--------------------------------------------------------------------------------
