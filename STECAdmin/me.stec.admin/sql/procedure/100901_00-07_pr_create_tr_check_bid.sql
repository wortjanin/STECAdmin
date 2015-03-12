CREATE OR REPLACE PROCEDURE pr_create_tr_check_bid
  ( in_table_name in VARCHAR2, 
    in_check      in VARCHAR2    
    ) 
AS  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
        EXECUTE IMMEDIATE (
        ' CREATE OR REPLACE TRIGGER tr_' || in_table_name || '_bid 
          BEFORE INSERT OR DELETE ON ' || in_table_name || '
          FOR EACH ROW
          BEGIN
           IF ( NOT (' || in_check || ') )  THEN 
             RAISE_APPLICATION_ERROR(-20010, ''Cannot insert/delete directly''); 
           END IF; 
          END;      '
      );   
END;
/

--------------------------------------------------------------------------------
