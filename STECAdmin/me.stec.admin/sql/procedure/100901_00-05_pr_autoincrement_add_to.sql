-- NOTE! table <in_table_name> MUST contain a field <in_table_name>_id of a NUMBER type (INT, INTEGER, NUMBER, etc)
 
CREATE OR REPLACE PROCEDURE pr_autoincrement_add_to
    (	in_table_name			IN VARCHAR2,
    	in_ignore_not_null_pk	IN CHAR DEFAULT 'N',
    	in_start_inc			IN INT DEFAULT 1,
    	in_check_on_insert		IN VARCHAR DEFAULT NULL,
    	in_code					IN VARCHAR2 DEFAULT NULL
    ) 
AS PRAGMA AUTONOMOUS_TRANSACTION;
	s_head VARCHAR2(512):= 
		' CREATE OR REPLACE TRIGGER tr_' || in_table_name || '_i ' ||
        ' BEFORE INSERT ON ' || in_table_name ||
        ' FOR EACH ROW ';

BEGIN
	pr_drop_if_exists ('DROP SEQUENCE sq_' || in_table_name  || '_i ');
    pr_create_if_not_exists('CREATE SEQUENCE sq_' || in_table_name  || '_i START WITH ' || in_start_inc || ' INCREMENT BY 1 NOMAXVALUE ');

    IF 'N' <> in_ignore_not_null_pk THEN
      BEGIN
        EXECUTE IMMEDIATE (
          s_head		||
          ' BEGIN ' 	||
          (CASE WHEN (in_check_on_insert IS NULL) THEN ' ' ELSE
          ' 	IF ( NOT (' || in_check_on_insert || ') ) THEN ' ||
          '		RAISE_APPLICATION_ERROR(-20011, ''Cannot insert, FALSE == ( in_check_on_insert ), see tr_' || in_table_name  || '_i trigger ''); ' ||
          '	END IF; ' 
          END) ||
  -- if we plan to load data from old database we normally would like to use the original ID numbers 
  -- (when we recreate the trigger and sequence (above) we do not need this checks on production, 
  --  as we do not plan to load massive data from the out any more with the demand to preserve IDs)
--          ' 	IF :NEW.' || in_table_name || '_id IS NULL THEN ' ||
          ' 		
          SELECT sq_' || in_table_name || '_i.NEXTVAL INTO :NEW.' || in_table_name || '_id FROM DUAL; 
          ' ||
--          ' 	END IF; ' ||
        ' 	' || (CASE WHEN (in_code IS NULL) THEN ' ' ELSE in_code END) ||
          ' END; '
        );   
        EXCEPTION
          WHEN OTHERS THEN
            pr_drop_if_exists ('DROP SEQUENCE sq_' || in_table_name  || '_i ');
            RAISE;
      END;
	    RETURN;
	END IF;
	
    BEGIN
      EXECUTE IMMEDIATE (
        s_head		||
        ' BEGIN ' 	||
        (CASE WHEN (in_check_on_insert IS NULL) THEN ' ' ELSE
        ' 	IF ( NOT (' || in_check_on_insert || ') ) THEN ' ||
   	    '		RAISE_APPLICATION_ERROR(-20011, ''Cannot insert, FALSE == ( in_check_on_insert ), see tr_' || in_table_name  || '_i trigger ''); ' ||
       	'	END IF; ' 
       	END) ||
-- if we plan to load data from old database we normally would like to use the original ID numbers 
-- (when we recreate the trigger and sequence (above) we do not need this checks on production, 
--  as we do not plan to load massive data from the out any more with the demand to preserve IDs)
        ' 	IF :NEW.' || in_table_name || '_id IS NULL THEN ' ||
        ' 		SELECT sq_' || in_table_name || '_i.NEXTVAL INTO :NEW.' || in_table_name || '_id FROM DUAL; ' ||
        ' 	END IF; ' ||
	    ' 	' || (CASE WHEN (in_code IS NULL) THEN ' ' ELSE in_code END) ||
        ' END; '
      );   
      EXCEPTION
        WHEN OTHERS THEN
          pr_drop_if_exists ('DROP SEQUENCE sq_' || in_table_name  || '_i ');
          RAISE;
    END;
END;
/
--EXAMPLE: CALL pr_autoincrement_add_to('faculty');

--------------------------------------------------------------------------------
