CREATE OR REPLACE PROCEDURE pr_create_tr_division_biud
  ( in_table_name IN VARCHAR2) 
AS  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
        EXECUTE IMMEDIATE (
        ' CREATE OR REPLACE TRIGGER tr_' || in_table_name || '_biud 
          BEFORE INSERT OR UPDATE OR DELETE ON ' || in_table_name || '
          FOR EACH ROW
		  DECLARE
		   	m_div_type_id		division_type.division_type_id%TYPE;
          BEGIN
			IF		INSERTING THEN
	           	SELECT DT.division_type_id 	INTO m_div_type_id 
									FROM 	division_type DT
									WHERE DT.table_name=''' || UPPER(in_table_name) || ''';
				
				INSERT 	INTO	division(division_type_id, 	parent_division_id) 
						VALUES			(m_div_type_id,		NULL);
				SELECT sq_division_i.CURRVAL INTO :NEW.division_id FROM DUAL; 
				IF :NEW.' || in_table_name || '_id IS NULL THEN
					SELECT sq_' || in_table_name || '_i.NEXTVAL INTO :NEW.' || in_table_name || '_id FROM DUAL;
				END IF;
			ELSIF	UPDATING THEN
				NULL;
			ELSIF	DELETING THEN
				DELETE 	FROM division D 
						WHERE D.division_id = :OLD.division_id;
			END IF;
			
          END;      '
      );
END;
/
--------------------------------------------------------------------------------
