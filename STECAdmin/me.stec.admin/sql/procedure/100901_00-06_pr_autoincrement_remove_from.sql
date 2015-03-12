CREATE OR REPLACE PROCEDURE pr_autoincrement_remove_from
    (in_table_name in VARCHAR2) 
AS PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    pr_drop_if_exists ('DROP SEQUENCE sq_' || in_table_name  || '_i ');
    BEGIN
      pr_drop_if_exists ('DROP TRIGGER tr_' || in_table_name || '_i ' );
      EXCEPTION
        WHEN OTHERS THEN
          pr_create_if_not_exists('CREATE SEQUENCE sq_' || in_table_name  || '_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');
          RAISE;
    END;
END;
/

--------------------------------------------------------------------------------
