--		
-- #	PackageName me.stec.admin.logic.user
--					dbType										Caption,				Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--					SchemeName									ClassSummary,			ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE		stec_login     
 (																	' ||  -- #  Логин пользователя,		Login,				,	    ,                       true
'	stec_login_id	INT        			NOT NULL,					' ||  -- #  ИН логина,				Id
'	stec_user_id	INT	        		NOT NULL,					' ||  -- #  ИН Пользователя,		IdStecUser
'	login			VARCHAR2(30 BYTE)	NOT NULL,					' ||  -- #	Логин,					Login
'	pw				VARCHAR2(30 BYTE)	DEFAULT NULL,				' ||  -- $#
'	pw_is_temp		CHAR(1 BYTE)		NOT NULL,					' ||  -- $#
'	blocked			CHAR(1 BYTE)		NOT NULL,					' ||  -- #	Аккаунт заблокирован,	IsBlocked
'	CONSTRAINT ck_stec_login_blocked	CHECK	(blocked IN (''Y'', ''N'')),			' ||
'	CONSTRAINT ck_stec_login_tmp		CHECK	(pw_is_temp IN (''Y'', ''N'')),			' ||
'	CONSTRAINT uq_stec_login UNIQUE (login),	' ||
'	CONSTRAINT fk_stec_login_user
	FOREIGN KEY  (stec_user_id) REFERENCES stec_user (stec_user_id),		' ||
'	CONSTRAINT pk_stec_login_id     
	PRIMARY KEY ( stec_login_id ) 
	ENABLE                     
 )											' 
);


CALL pr_create_if_not_exists('CREATE SEQUENCE sq_stec_login_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');
-- CALL pr_set_startval_for_seq('sq_stec_login_i');

-- DROP TRIGGER  tr_stec_login_biud;
CREATE OR REPLACE TRIGGER tr_stec_login_biud 
BEFORE INSERT OR UPDATE OR DELETE ON stec_login
FOR EACH ROW
BEGIN
	IF (SYS.pkg_stec.fn_my_caller <> ( '<package body ' ||  fn_stec_schema || '.PKG_STEC_ACCOUNT>')) THEN
		RAISE_APPLICATION_ERROR(-20001, 'Cannot insert/update/delete directly');
	END IF;
	
	IF INSERTING THEN
		:NEW.pw_is_temp := (CASE WHEN :NEW.pw IS NULL THEN 'N' ELSE 'Y' END);
		SELECT sq_stec_login_i.NEXTVAL INTO :NEW.stec_login_id FROM DUAL;
	ELSIF UPDATING THEN
		IF  NOT ( 	:NEW.login			= :OLD.login			AND
					:NEW.stec_login_id	= :OLD.stec_login_id	AND
					:NEW.stec_user_id	= :OLD.stec_user_id 		)   THEN 
			RAISE_APPLICATION_ERROR(-20001, 'Do NEVER change login or id-s'); 
		END IF;
		:NEW.pw_is_temp := (CASE WHEN :NEW.pw IS NULL THEN 'N' ELSE 'Y' END);
	END IF;
END;     
/

CREATE OR REPLACE FUNCTION FN_PLC_STEC_LOGIN
(
    p_schema  IN VARCHAR2,
    p_table   IN VARCHAR2
)
RETURN VARCHAR
AS
BEGIN
--  IF (p_schema = USER) THEN
--    RETURN NULL;
--  END IF;
  RETURN '(login IN (USER))';
END;
/

--  begin
--    dbms_rls.drop_policy(
--      object_schema => fn_stec_schema,
--      object_name => 'STEC_LOGIN',
--      policy_name => 'PLC_STEC_LOGIN'
--    );
--  end;
--  /
DECLARE
    ex EXCEPTION; 
    PRAGMA EXCEPTION_INIT ( ex, -28101); 
BEGIN
  sys.dbms_rls.add_policy (
    object_schema     		=> fn_stec_schema,
    object_name       		=> 'STEC_LOGIN',
    policy_name       		=> 'PLC_STEC_LOGIN',
    function_schema   		=> fn_stec_schema,
    policy_function   		=> 'FN_PLC_STEC_LOGIN',
    statement_types   		=> 'INSERT, UPDATE, DELETE',
    update_check      		=> FALSE,
    sec_relevant_cols 		=> 'PW'
--    sec_relevant_cols_opt => DBMS_RLS.ALL_ROWS
    );
EXCEPTION 
    WHEN ex THEN NULL;
END;
/

CREATE OR REPLACE FUNCTION FN_PLC_STEC_LOGIN_S
(
    p_schema  IN VARCHAR2,
    p_table   IN VARCHAR2
)
RETURN VARCHAR
AS
BEGIN
--  IF (p_schema = USER) THEN
--    RETURN NULL;
--  END IF;
  RETURN '(SYS.pkg_stec.fn_my_caller = ( ''<package body '' ||  fn_stec_schema || ''.PKG_STEC_ACCOUNT>''))';
END;
/

--  begin
--    dbms_rls.drop_policy(
--      object_schema => fn_stec_schema,
--      object_name => 'STEC_LOGIN',
--      policy_name => 'PLC_STEC_LOGIN_S'
--    );
--  end;
--  /
DECLARE
    ex EXCEPTION; 
    PRAGMA EXCEPTION_INIT ( ex, -28101); 
BEGIN
  sys.dbms_rls.add_policy (
    object_schema     		=> fn_stec_schema,
    object_name      		=> 'STEC_LOGIN',
    policy_name       		=> 'PLC_STEC_LOGIN_S',
    function_schema   		=> fn_stec_schema,
    policy_function   		=> 'FN_PLC_STEC_LOGIN_S',
    statement_types   		=> 'SELECT',
--    update_check      		=> FALSE,
    sec_relevant_cols		=> 'PW',
    sec_relevant_cols_opt	=> dbms_rls.ALL_ROWS
  );
EXCEPTION
  WHEN ex THEN NULL;
END;
/

--------------------------------------------------------------------------------
