CREATE OR REPLACE PROCEDURE pr_create_tr_division_bid
  ( in_table_name IN VARCHAR2) 
AS  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
        EXECUTE IMMEDIATE (
        ' CREATE OR REPLACE TRIGGER tr_' || in_table_name || '_bi 
          BEFORE INSERT ON ' || in_table_name || '
          FOR EACH ROW
		  DECLARE
		   	me_div_type_id		division_type.division_type_id%TYPE;
          BEGIN
           	SELECT DT.division_type_id 	INTO me_div_type_id 
								FROM 	division_type DT
								WHERE DT.table_name=''' || UPPER(in_table_name) || ''';
			
			INSERT 	INTO	division(division_id, 	division_type_id, 	division_parent_id) 
					VALUES			(NULL,			me_div_type_id,		NULL);
			SELECT sq_division_i.CURRVAL INTO :NEW.division_id FROM DUAL; 

          END;      '
      );
      BEGIN
       EXECUTE IMMEDIATE (
        ' CREATE OR REPLACE TRIGGER tr_' || in_table_name || '_bd 
          BEFORE DELETE ON ' || in_table_name || '
          FOR EACH ROW
		  BEGIN
			DELETE 	FROM division D 
					WHERE D.division_id = :OLD.division_id;
		  END;      '
      );   
      
      EXCEPTION
        WHEN OTHERS THEN
          pr_drop_if_exists ('DROP TRIGGER tr_' || in_table_name || '_bi ');
          RAISE;
     
      END;
      
END;
/
----------------------------------------------------------
