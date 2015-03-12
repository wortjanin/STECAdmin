CREATE OR REPLACE PROCEDURE pr_drop_if_exists
    (in_drop_command in VARCHAR2) 
AS  PRAGMA AUTONOMOUS_TRANSACTION;
  u_name USER_OBJECTS.OBJECT_NAME%TYPE;
  o_sum INT;
BEGIN 
  u_name := UPPER(REGEXP_REPLACE(REGEXP_REPLACE( TRIM(in_drop_command), 
            '[[:space:]]+', ' '),
            '(.*) (.*) (.*)', '\3'));
  SELECT SUM(CNT) INTO o_sum FROM 
  ((SELECT COUNT(*) CNT FROM USER_OBJECTS WHERE OBJECT_NAME = u_name) UNION
  (SELECT COUNT(*) CNT FROM USER_TABLES WHERE TABLE_NAME = u_name) ) ;
  
  IF  (0 = o_sum)  THEN
    RETURN;
  END IF;
  
  EXECUTE IMMEDIATE (in_drop_command);
END;
/

--------------------------------------------------------------------------------
