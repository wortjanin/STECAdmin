
ALTER SESSION SET CURRENT_SCHEMA=SYS;

-- DROP TRIGGER TR_STEC_CLEAR_SESSION_BLOD;
CREATE OR REPLACE TRIGGER TR_STEC_CLEAR_SESSION_BLOD
BEFORE LOGOFF ON DATABASE
DECLARE
  stec_schema STEC_USER.stec.stec_schema%TYPE;
  is_active   CHAR(1) := 'N';
BEGIN
  stec_schema := pkg_stec.fn_schema_4(USER);
  IF stec_schema IS NULL THEN
    RETURN;
  END IF;
  
  EXECUTE IMMEDIATE 'CALL ' || stec_schema || '.pr_clear_session()' ;
  
END;
/

--------------------------------------------------------------------
