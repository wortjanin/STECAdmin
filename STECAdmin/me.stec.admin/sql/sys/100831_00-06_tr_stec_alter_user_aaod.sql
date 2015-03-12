ALTER SESSION SET CURRENT_SCHEMA=SYS;
  
-- SET SERVEROUTPUT ON;
  
-- DROP TRIGGER TR_STEC_ALTER_USER_AAOD;
CREATE OR REPLACE TRIGGER TR_STEC_ALTER_USER_AAOD
AFTER ALTER ON DATABASE
DECLARE PRAGMA AUTONOMOUS_TRANSACTION;
  stec_schema STEC_USER.stec.stec_schema%TYPE;
  sql_text ora_name_list_t;
  stmt VARCHAR2(4000) := '';
  n number;
BEGIN
  IF (ora_dict_obj_type = 'USER') THEN
    stec_schema := pkg_stec.fn_schema_4(ora_dict_obj_name);
    IF stec_schema IS NULL THEN  RETURN; END IF;
--		dbms_output.put_line(pkg_stec.fn_my_caller);
    IF pkg_stec.fn_my_caller = '<package body SYS.PKG_STEC>' THEN RETURN; END IF;

    n:=ora_sql_txt(sql_text);
    if ( n is null ) then
      stmt := 'null statement';
    else
      for i in 1..n loop
        stmt:=substr(stmt || ' ' || sql_text(i),1,4000);
      end loop;
    end if;
    
    IF NOT UPPER(stmt) LIKE '%IDENTIFIED%' THEN
      RETURN;
    END IF;
    
    RAISE_APPLICATION_ERROR(-20001, 'You cannot alter user directly, use UPDATE vw_stec_user for that');
  END IF;
EXCEPTION
  WHEN OTHERS THEN 
    ROLLBACK; 
    RAISE;
END;
/


--	SELECT * FROM STEC_PETRSU.vw_stec_user where login like 'INTELLEKTIS';
--	UPDATE STEC_PETRSU.vw_stec_user SET password='-1'  where login like 'INTELLEKTIS';
--	ALTER USER INTELLEKTIS IDENTIFIED BY MY_super_PASS###;

----------------------------------------------------------------------------------------