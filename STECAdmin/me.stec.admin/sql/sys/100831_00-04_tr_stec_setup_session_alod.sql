ALTER SESSION SET CURRENT_SCHEMA=SYS;

-- DROP TRIGGER TR_STEC_SETUP_SESSION_ALOD;
CREATE OR REPLACE TRIGGER TR_STEC_SETUP_SESSION_ALOD
AFTER LOGON ON DATABASE
DECLARE
  stec_schema STEC_USER.stec.stec_schema%TYPE;
BEGIN
  stec_schema := pkg_stec.fn_schema_4(USER);
  IF stec_schema IS NULL THEN
    RETURN;
  END IF;
  
  EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA=' || stec_schema;
END;
/

--------------------------------------------------------------------

