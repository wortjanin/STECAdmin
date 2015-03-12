ALTER SESSION SET CURRENT_SCHEMA=SYS;

CREATE OR REPLACE PACKAGE pkg_stec_temp_privs AS
  PROCEDURE pr_collect;
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_stec_temp_privs AS
  
  PROCEDURE pr_collect
  AS PRAGMA AUTONOMOUS_TRANSACTION;
    my_schema STEC_USER.stec.stec_schema%TYPE := SYS.pkg_stec.fn_schema_4(USER);
  BEGIN
    IF my_schema IS NULL THEN
      my_schema := USER;
    END IF;
    
    EXECUTE IMMEDIATE ('TRUNCATE TABLE ' || my_schema || '.temp_privs ');  
    
    EXECUTE IMMEDIATE ('INSERT INTO ' || my_schema || '.temp_privs
		SELECT 
		DTP.TABLE_NAME OBJ,
		DO.OBJECT_TYPE OBJ_TYPE,
		DTP.PRIVILEGE PRIV,
		DTP.GRANTABLE GR
		FROM DBA_TAB_PRIVS DTP, DBA_OBJECTS DO
		WHERE 
			DO.OWNER  		= DTP.OWNER AND
		    DO.OBJECT_NAME 	= DTP.TABLE_NAME AND
		    DTP.OWNER 		= :1 AND
			DTP.GRANTEE IN (
				SELECT DISTINCT
				  GRANTED_ROLE
				FROM
				  (
				  ' || /* THE USERS */ '
				    SELECT 
				      NULL     GRANTEE, 
				      USERNAME GRANTED_ROLE
				    FROM 
				      DBA_USERS
				    WHERE
				      USERNAME = USER
				  ' || /* THE ROLES TO ROLES RELATIONS */ ' 
				  UNION
				    SELECT 
				      GRANTEE,
				      GRANTED_ROLE
				    FROM
				      DBA_ROLE_PRIVS
				  ' || /* THE ROLES TO PRIVILEGE RELATIONS */ ' 
				  UNION
				    SELECT
				      GRANTEE,
				      PRIVILEGE
				    FROM
				      DBA_SYS_PRIVS
				  )
				START WITH GRANTEE IS NULL
				CONNECT BY GRANTEE = PRIOR GRANTED_ROLE
			)') USING my_schema;
    
    COMMIT;
    
    EXCEPTION 
      WHEN OTHERS THEN 
        ROLLBACK;
        RAISE;
  END;
END;
/

--------------------------------------------------------------------------------
