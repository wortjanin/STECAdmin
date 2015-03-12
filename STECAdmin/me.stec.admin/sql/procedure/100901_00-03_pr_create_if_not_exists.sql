
-- call pr_create_if_not_exists('create table test_t(num number)');
-- select * from test_t;
-- drop table test_t;

CREATE OR REPLACE PROCEDURE pr_create_if_not_exists
    (in_create_command in CLOB) 
AS  PRAGMA AUTONOMOUS_TRANSACTION;
    exception_exists EXCEPTION; 
    PRAGMA EXCEPTION_INIT ( exception_exists, -00955); 
BEGIN 
    EXECUTE IMMEDIATE (in_create_command);
EXCEPTION 
    WHEN exception_exists THEN NULL;
END;
/

--------------------------------------------------------------------------------
