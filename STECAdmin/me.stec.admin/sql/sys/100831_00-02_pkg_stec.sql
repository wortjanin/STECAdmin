ALTER SESSION SET CURRENT_SCHEMA=SYS;

CREATE OR REPLACE PACKAGE pkg_stec AS
  
  FUNCTION  fn_my_caller						RETURN VARCHAR2;
  FUNCTION	fn_rand_pw							RETURN VARCHAR2;
  FUNCTION  fn_schema_4(in_user IN VARCHAR2)	RETURN VARCHAR2;

  PROCEDURE pr_user_create(in_user IN VARCHAR2, in_password IN VARCHAR2);
  PROCEDURE pr_user_drop(in_user IN VARCHAR2);
  PROCEDURE pr_user_alter(in_user IN VARCHAR2, in_password IN VARCHAR2);
  
  PROCEDURE pr_role_create(in_role IN VARCHAR2);
  PROCEDURE pr_role_drop(in_role IN VARCHAR2);
  PROCEDURE pr_role_grant(in_grant_expr IN VARCHAR2);

END;
/
CREATE OR REPLACE PACKAGE BODY pkg_stec AS
  s_user_name_rexp  CONSTANT VARCHAR2(32) := '^([A-Z][A-Z0-9_]{1,29})$';
  s_pass_word_rexp  CONSTANT VARCHAR2(64) := '^([a-zA-Z][a-zA-Z0-9_$#]{9,29})$';
  s_err_input       CONSTANT VARCHAR2(16) := 'Invalid input';
  s_err_user        CONSTANT VARCHAR2(16) := 'Invalid user';
  s_caller_rexp     CONSTANT VARCHAR2(64) := '<package body ([^[:space:]]+).PKG_STEC_ACCOUNT>';
  s_grant_SIUD_rx   CONSTANT VARCHAR2(512) :=
                  '(GRANT|REVOKE)[[:space:]]+' || 
                  '(SELECT|INSERT|UPDATE|DELETE|EXECUTE)[[:space:]]*[,]*[[:space:]]*' || 
                  '(SELECT|INSERT|UPDATE|DELETE)*[[:space:]]*[,]*[[:space:]]*' || 
                  '(SELECT|INSERT|UPDATE|DELETE)*[[:space:]]*[,]*[[:space:]]*' || 
                  '(SELECT|INSERT|UPDATE|DELETE)*[[:space:]]*[,]*[[:space:]]*' || 
                  '[[:space:]]+ON[[:space:]]+([^[:space:];]+)[.][^[:space:];]+[[:space:]]+' || 
                  '(TO|FROM)[[:space:]]+([^[:space:];]+)';
  s_grant_role_to_whom_rx CONSTANT VARCHAR2(256) := 
                  '(GRANT|REVOKE)[[:space:]]+([^[:space:];]+)[[:space:]]+(TO|FROM)[[:space:]]+' || 
                  '([^[:space:];]+)([[:space:]]+WITH[[:space:]]+(GRANT|ADMIN)[[:space:]]+OPTION)*';
  s_grant_connect_to_whom_rx CONSTANT VARCHAR2(256) :=
  				  '(GRANT|REVOKE)[[:space:]]+CREATE[[:space:]]+SESSION[[:space:]]+(TO|FROM)[[:space:]]+' ||
  				  '([^[:space:];]+)([[:space:]]+WITH[[:space:]]+(GRANT|ADMIN)[[:space:]]+OPTION)*';
  				  
  FUNCTION fn_my_caller RETURN VARCHAR2
  AS
  BEGIN
    RETURN 
  --  dbms_utility.format_call_stack;
      '<' || 
      REGEXP_REPLACE(
        REGEXP_REPLACE(
          REGEXP_SUBSTR(
            REGEXP_SUBSTR(
              DBMS_UTILITY.FORMAT_CALL_STACK,
              '[^[:space:]]+.PKG_STEC'      || CHR(10) || 
              '[[:print:]]+'                || CHR(10) || 
              '[[:print:]]+'                || CHR(10)     ),
            CHR(10) || '[[:print:]]+$'),
          CHR(10) || '[^[:space:]]+[[:space:]]+[[:digit:]]+[[:space:]]+', ''),
        '[[:space:]]+', ' ') 
      || '>';
  END;

  FUNCTION fn_rand_pw RETURN VARCHAR2
  AS
  BEGIN
   RETURN   DBMS_RANDOM.STRING('A', 1) || 
            TRANSLATE(DBMS_RANDOM.STRING('x', DBMS_RANDOM.VALUE(11, 29)),
                      DBMS_RANDOM.STRING('x', 29),
                      '_#$abcdefghijklmnopqrstuvwxyz');  
  END;

  PROCEDURE my_pr_user_drop(IN_USER IN VARCHAR2)
  AS PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    EXECUTE IMMEDIATE ('DROP USER ' || IN_USER);
  END;

  PROCEDURE my_pr_user_create(
  	IN_USER IN VARCHAR2, 
  	in_password IN VARCHAR2, 
  	in_table_space IN VARCHAR2,
  	in_temp_space IN VARCHAR2	
  ) AS PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
        EXECUTE IMMEDIATE ( 
                            ' CREATE USER '				|| IN_USER			||
                            ' IDENTIFIED BY '   		|| in_password		||
                            ' DEFAULT TABLESPACE ' 		|| in_table_space	||
                            ' TEMPORARY TABLESPACE ' 	|| in_temp_space		);
--  CREATE USER stec_user IDENTIFIED BY 123 
--  DEFAULT TABLESPACE TS_STEC_USER
--  TEMPORARY TABLESPACE TEMP;
                            
--        EXECUTE IMMEDIATE ( 
--                            ' GRANT CREATE SESSION TO ' || IN_USER ||
--                            ' IDENTIFIED BY '           || in_password);
  END;
  
  -- do not expose my_fn_schema_4 function
  FUNCTION my_fn_schema_4(IN_USER IN VARCHAR2)  RETURN VARCHAR2
  AS
    cnt INT;
    my_stec_id STEC_USER.stec.stec_id%TYPE;
    CURSOR  cur_sys_stec IS
            SELECT stec_schema, stec_id
            FROM STEC_USER.stec;
  BEGIN

      IF IN_USER LIKE 'SYS' THEN
        RETURN NULL;
      END IF;
    
      FOR sys_stec_rec IN cur_sys_stec  LOOP
        SELECT COUNT(*) INTO cnt FROM DBA_USERS WHERE ROWNUM = 1 AND USERNAME LIKE sys_stec_rec.stec_schema; 
        CONTINUE WHEN 0 = cnt;
        
        IF IN_USER LIKE sys_stec_rec.stec_schema THEN
          RETURN NULL;
        END IF;
        
        SELECT COUNT(*) INTO cnt FROM STEC_USER.stec_user SU 
                        WHERE ROWNUM = 1 AND 
                              SU.stec_id = sys_stec_rec.stec_id AND 
                              SU.login LIKE IN_USER; 
        CONTINUE WHEN 0 = cnt;
        
        RETURN sys_stec_rec.stec_schema;
      END LOOP;
      
      RETURN NULL;
  END;

  FUNCTION fn_schema_4(in_user IN VARCHAR2)  RETURN VARCHAR2 AS
      my_user STEC_USER.stec_user.login%TYPE := UPPER(in_user);
  BEGIN
      IF NOT REGEXP_LIKE(my_user,    s_user_name_rexp) THEN
        RETURN NULL;
      END IF;
      
      RETURN my_fn_schema_4(my_user);      
  END;
  
  PROCEDURE pr_user_create(in_user IN VARCHAR2, in_password IN VARCHAR2) 
  AS PRAGMA AUTONOMOUS_TRANSACTION;
    my_user STEC_USER.stec_user.login%TYPE := UPPER(in_user);
    my_stec_schema  STEC_USER.stec.stec_schema%TYPE;
    my_stec_id      STEC_USER.stec.stec_id%TYPE;
    my_ts_def		VARCHAR2(30 BYTE);
    my_ts_tmp		VARCHAR2(30 BYTE);
    cnt INT;
  BEGIN
    IF NOT (REGEXP_LIKE(my_user,      s_user_name_rexp) AND 
            REGEXP_LIKE(in_password,  s_pass_word_rexp)      ) THEN
       RAISE_APPLICATION_ERROR(-20001, s_err_input);
    END IF;
    
    SELECT COUNT(*) INTO cnt FROM SYS.DBA_USERS WHERE USERNAME LIKE my_user;
    IF cnt > 0 THEN 
      RAISE_APPLICATION_ERROR(-20002, s_err_user);  
    END IF;
    
    --   s_caller_rexp     CONSTANT VARCHAR2(64) := '<package body ([^[:space:]]+).PKG_STEC_ACCOUNT>';
    my_stec_schema := REGEXP_REPLACE(fn_my_caller, s_caller_rexp, '\1');
    SELECT SS.stec_id INTO my_stec_id FROM STEC_USER.stec SS WHERE SS.stec_schema LIKE my_stec_schema;
    
	SELECT 		DEFAULT_TABLESPACE,	TEMPORARY_TABLESPACE
		INTO	my_ts_def,			my_ts_tmp
		FROM DBA_USERS
		WHERE USERNAME = my_stec_schema;
    
    INSERT INTO STEC_USER.stec_user(stec_user_id, login, stec_id) VALUES(NULL, my_user, my_stec_id);
    
    my_pr_user_create(my_user, in_password, my_ts_def, my_ts_tmp);
       
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END;
  
  PROCEDURE pr_user_drop(in_user IN VARCHAR2) 
  AS  PRAGMA AUTONOMOUS_TRANSACTION;
    my_user STEC_USER.stec_user.login%TYPE := UPPER(in_user);
    my_stec_schema  STEC_USER.stec.stec_schema%TYPE;
    my_stec_user_id STEC_USER.stec_user.stec_user_id%TYPE;
  BEGIN
    IF NOT REGEXP_LIKE(my_user,    s_user_name_rexp) THEN
       RAISE_APPLICATION_ERROR(-20001, s_err_input);
    END IF;

    --   s_caller_rexp     CONSTANT VARCHAR2(64) := '<package body ([^[:space:]]+).PKG_STEC_ACCOUNT>';
    my_stec_schema := my_fn_schema_4(my_user);
    IF  (my_stec_schema IS NULL ) OR 
        (NOT my_stec_schema LIKE REGEXP_REPLACE(fn_my_caller, s_caller_rexp, '\1')     ) THEN
       RAISE_APPLICATION_ERROR(-20002, s_err_user);
    END IF;

    SELECT SU.stec_user_id INTO my_stec_user_id FROM STEC_USER.stec_user SU WHERE SU.login LIKE my_user; 
    DELETE FROM STEC_USER.stec_user SU WHERE SU.stec_user_id = my_stec_user_id;
    my_pr_user_drop(my_user);
    
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END;
  
  PROCEDURE pr_user_alter(in_user IN VARCHAR2, in_password IN VARCHAR2)
  AS PRAGMA AUTONOMOUS_TRANSACTION;
    my_user STEC_USER.stec_user.login%TYPE := UPPER(in_user);
    my_stec_schema  STEC_USER.stec.stec_schema%TYPE;
  BEGIN
    IF NOT REGEXP_LIKE(my_user,    s_user_name_rexp) THEN
       RAISE_APPLICATION_ERROR(-20001, s_err_input);
    END IF;

    --   s_caller_rexp     CONSTANT VARCHAR2(64) := '<package body ([^[:space:]]+).PKG_STEC_ACCOUNT>';
    my_stec_schema := my_fn_schema_4(my_user);
    IF  (my_stec_schema IS NULL ) OR 
        (NOT my_stec_schema LIKE REGEXP_REPLACE(fn_my_caller, s_caller_rexp, '\1')     ) THEN
       RAISE_APPLICATION_ERROR(-20002, s_err_user);
    END IF;

    EXECUTE IMMEDIATE ('ALTER USER ' || my_user || ' IDENTIFIED BY ' || in_password);
    
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END;

  PROCEDURE my_pr_role_create(in_role IN VARCHAR2)
  AS PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE ' || in_role;
  END;

  PROCEDURE my_pr_role_drop(in_role IN VARCHAR2)
  AS PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE ' || in_role;
  END;

  PROCEDURE pr_role_create(in_role IN VARCHAR2)
  AS PRAGMA AUTONOMOUS_TRANSACTION;
    my_role STEC_USER.stec_role.role_name%TYPE := UPPER(in_role);
    --   s_caller_rexp     CONSTANT VARCHAR2(64) := '<package body ([^[:space:]]+).PKG_STEC_ACCOUNT>';
    my_stec_schema  STEC_USER.stec.stec_schema%TYPE := REGEXP_REPLACE(fn_my_caller, s_caller_rexp, '\1');
    my_stec_id      STEC_USER.stec.stec_id%TYPE;
  BEGIN
    IF NOT REGEXP_LIKE(my_role,    s_user_name_rexp) THEN
       RAISE_APPLICATION_ERROR(-20001, s_err_input);
    END IF;
    
    SELECT SS.stec_id INTO my_stec_id FROM STEC_USER.stec SS WHERE SS.stec_schema LIKE my_stec_schema;
    INSERT INTO STEC_USER.stec_role(stec_role_id, role_name, stec_id) VALUES(NULL, my_role, my_stec_id);
    my_pr_role_create(my_role);

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
    
  END;
  
  PROCEDURE pr_role_drop(in_role IN VARCHAR2)
  AS PRAGMA AUTONOMOUS_TRANSACTION;
    my_role STEC_USER.stec_role.role_name%TYPE := UPPER(in_role);
    --   s_caller_rexp     CONSTANT VARCHAR2(64) := '<package body ([^[:space:]]+).PKG_STEC_ACCOUNT>';
    my_stec_schema  STEC_USER.stec.stec_schema%TYPE := REGEXP_REPLACE(fn_my_caller, s_caller_rexp, '\1');
    my_stec_id      STEC_USER.stec.stec_id%TYPE;
    my_stec_role_id STEC_USER.stec_role.stec_role_id%TYPE;
  BEGIN
    IF NOT REGEXP_LIKE(my_role,    s_user_name_rexp) THEN
       RAISE_APPLICATION_ERROR(-20001, s_err_input);
    END IF;
    
    SELECT SS.stec_id INTO my_stec_id FROM STEC_USER.stec SS 
                      WHERE SS.stec_schema LIKE my_stec_schema;
    SELECT SR.stec_role_id  INTO my_stec_role_id FROM STEC_USER.stec_role SR 
                            WHERE SR.role_name LIKE my_role; 
    
    my_pr_role_drop(my_role);
    DELETE FROM STEC_USER.stec_role SR WHERE SR.stec_role_id = my_stec_role_id;
    
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
    
  END;

  PROCEDURE pr_role_grant(in_grant_expr IN VARCHAR2)
  AS PRAGMA AUTONOMOUS_TRANSACTION;
    --    s_grant_SIUD_rx   CONSTANT VARCHAR2(512) :=
    --                    '(GRANT|REVOKE)[[:space:]]+' || 
    --                    '(SELECT|INSERT|UPDATE|DELETE|EXECUTE)[[:space:]]*[,]*[[:space:]]*' || 
    --                    '(SELECT|INSERT|UPDATE|DELETE)*[[:space:]]*[,]*[[:space:]]*' || 
    --                    '(SELECT|INSERT|UPDATE|DELETE)*[[:space:]]*[,]*[[:space:]]*' || 
    --                    '(SELECT|INSERT|UPDATE|DELETE)*[[:space:]]*[,]*[[:space:]]*' || 
    --                    '[[:space:]]+ON[[:space:]]+([^[:space:];]+)[.][^[:space:];]+[[:space:]]+' || 
    --                    '(TO|FROM)[[:space:]]+([^[:space:];]+)';
    --    s_grant_role_to_whom_rx CONSTANT VARCHAR2(256) := 
    --                    '(GRANT|REVOKE)[[:space:]]+([^[:space:];]+)[[:space:]]+(TO|FROM)[[:space:]]+' || 
    --                    '([^[:space:];]+)([[:space:]]+WITH[[:space:]]+(GRANT|ADMIN)[[:space:]]+OPTION)*';
    --   s_caller_rexp     CONSTANT VARCHAR2(64) := '<package body ([^[:space:]]+).PKG_STEC_ACCOUNT>';
	--	 s_grant_connect_to_whom_rx CONSTANT VARCHAR2(256) :=
	--	  				  '(GRANT|REVOKE)[[:space:]]+CREATE[[:space:]]+SESSION[[:space:]]+(TO|FROM)[[:space:]]+' ||
	--	  				  '([^[:space:];]+)([[:space:]]+WITH[[:space:]]+(GRANT|ADMIN)[[:space:]]+OPTION)*';
    my_stec_schema  STEC_USER.stec.stec_schema%TYPE := REGEXP_REPLACE(fn_my_caller, s_caller_rexp, '\1');
    my_role         STEC_USER.stec_role.role_name%TYPE;
    my_login        STEC_USER.stec_user.login%TYPE;
    my_stec_id      STEC_USER.stec.stec_id%TYPE;
    my_stec_role_id STEC_USER.stec_role.stec_role_id%TYPE;
    my_stec_user_id STEC_USER.stec_user.stec_user_id%TYPE;
    invalid_input EXCEPTION;
  BEGIN
    SELECT SS.stec_id INTO my_stec_id FROM STEC_USER.stec SS WHERE SS.stec_schema = my_stec_schema;
    IF REGEXP_LIKE(UPPER(TRIM(in_grant_expr)), s_grant_role_to_whom_rx) THEN
      my_role   := REGEXP_REPLACE(UPPER(TRIM(in_grant_expr)), s_grant_role_to_whom_rx, '\2');
      my_login  := REGEXP_REPLACE(UPPER(TRIM(in_grant_expr)), s_grant_role_to_whom_rx, '\4');
      SELECT SR.stec_role_id  INTO my_stec_role_id FROM STEC_USER.stec_role SR 
                              WHERE SR.stec_id = my_stec_id AND
                                    SR.role_name = my_role; 
      SELECT COUNT(*)  INTO my_stec_user_id FROM STEC_USER.stec_user SU 
                              WHERE SU.stec_id	= my_stec_id AND
                                    SU.login	= my_login; 
      IF 0 = my_stec_user_id THEN
        SELECT SR.stec_role_id  INTO my_stec_role_id FROM STEC_USER.stec_role SR 
                                WHERE SR.stec_id	= my_stec_id AND
                                      SR.role_name	= my_login; 
      END IF;

      EXECUTE IMMEDIATE in_grant_expr;
      COMMIT;
      RETURN;
    END IF;

    IF  REGEXP_LIKE(UPPER(TRIM(in_grant_expr)), s_grant_SIUD_rx)                               AND 
        REGEXP_REPLACE(UPPER(TRIM(in_grant_expr)), s_grant_SIUD_rx, '\6') LIKE my_stec_schema
    THEN
      my_role         := REGEXP_REPLACE(UPPER(TRIM(in_grant_expr)), s_grant_SIUD_rx, '\8');
      
      SELECT COUNT(*) INTO my_stec_role_id
                        FROM STEC_USER.stec_role SR 
                        WHERE   SR.stec_id = my_stec_id AND
                                SR.role_name = my_role; 
      IF 0 = my_stec_role_id THEN
        SELECT SU.stec_user_id INTO my_stec_user_id
	                       FROM STEC_USER.stec_user SU 
    	                   WHERE   SU.stec_id = my_stec_id AND
        	                       SU.login = my_role; 
      END IF;
      
      EXECUTE IMMEDIATE in_grant_expr;
      COMMIT;
      RETURN;
    END IF;
    
    IF REGEXP_LIKE(UPPER(TRIM(in_grant_expr)), s_grant_connect_to_whom_rx) THEN
      my_login  := REGEXP_REPLACE(UPPER(TRIM(in_grant_expr)), s_grant_connect_to_whom_rx, '\3');
      SELECT SU.stec_user_id  INTO my_stec_user_id FROM STEC_USER.stec_user SU 
                              WHERE SU.stec_id	= my_stec_id AND
                                    SU.login	= my_login;
                                    
	  EXECUTE IMMEDIATE in_grant_expr;
      COMMIT;
      RETURN;
    END IF;
    
    RAISE_APPLICATION_ERROR(-20001, s_err_input);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END;

END;
/
-----------------------------------------------------------------------------------
