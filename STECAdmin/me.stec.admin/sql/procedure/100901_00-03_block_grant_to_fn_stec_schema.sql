BEGIN
  EXECUTE IMMEDIATE ('GRANT UNLIMITED TABLESPACE TO '               || fn_stec_schema);
  EXECUTE IMMEDIATE ('GRANT EXECUTE ON SYS.DBMS_LOCK TO '           || fn_stec_schema);
  EXECUTE IMMEDIATE ('GRANT SELECT ON SYS.DBA_USERS TO '            || fn_stec_schema);
  EXECUTE IMMEDIATE ('GRANT SELECT ON SYS.DBA_OBJECTS TO '          || fn_stec_schema);
  
  EXECUTE IMMEDIATE ('GRANT EXECUTE ON SYS.pkg_stec TO '            || fn_stec_schema);
  EXECUTE IMMEDIATE ('GRANT EXECUTE ON SYS.pkg_stec_temp_privs TO ' || fn_stec_schema || ' WITH GRANT OPTION ');
  EXECUTE IMMEDIATE ('GRANT SELECT  ON STEC_USER.stec TO '          || fn_stec_schema);
END;
/
DECLARE
 m_cnt INT := 0;
BEGIN
  SELECT COUNT(*) INTO m_cnt FROM STEC_USER.stec S WHERE S.stec_schema = fn_stec_schema;
  IF m_cnt < 1 THEN
    INSERT INTO  STEC_USER.stec(stec_schema) VALUES (fn_stec_schema);
    COMMIT;
  END IF;
END;
/
-- SELECT * FROM STEC_USER.stec;

--------------------------------------------------------------------------------
