-- NOTE:	the commands from scripts in the sys folder should be executed under SYS dba user.
--			They are for:
--
--				1) 	to provide restricted rights on role and user management for STEC_SCHEME_NAME  
--
--				2) 	to make a stec user to see the STEC scheme (he/she has account in) 
--			   		right after login automatically
--
-- NOTE ALSO: 	there are some commented out pseudo-commands, 
-- 				so use the step-by-step method and read comments for a guidance
--				(	some other comments are for a clear or other purpose, 
-- 					not for to execute them immediately  )
--
------------------------------------------------------------------------------------
-- CREATE USER STEC_USER ....
ALTER SESSION SET CURRENT_SCHEMA=STEC_USER;
-- NOTE: STEC_USER is a reserved scheme name for STEC System

-- DROP TABLE stec;
CREATE TABLE				stec     
 (															
	stec_id		      INT  	      	NOT NULL,
	stec_schema     VARCHAR2(30)	NOT NULL,
	CONSTRAINT ck_stec_id		CHECK	(stec_id >= 0 AND stec_id <= 99999),			
	CONSTRAINT uq_stec_schmema UNIQUE (stec_schema),
	CONSTRAINT pk_stec_id     
	PRIMARY KEY ( stec_id ) 
	ENABLE                     
 );											 
 GRANT UNLIMITED TABLESPACE to STEC_USER;
 -- DROP SEQUENCE sq_stec_i;
 CREATE SEQUENCE sq_stec_i START WITH 1 INCREMENT BY 1 NOMAXVALUE;
 -- DROP TRIGGER tr_stec_biud;
 CREATE OR REPLACE TRIGGER tr_stec_biud  
 BEFORE INSERT OR UPDATE OR DELETE ON stec 
 FOR EACH ROW 
 BEGIN
  IF INSERTING THEN				 
    SELECT sq_stec_i.NEXTVAL INTO :NEW.stec_id FROM DUAL;  
  ELSIF UPDATING THEN
 	RAISE_APPLICATION_ERROR(-20011, '
DO NEVER change the record (NEITHER the stec_schema name, NOR the stec_id number)
');
  ELSIF DELETING THEN
 	RAISE_APPLICATION_ERROR(-20011, '
DO NEVER delete stec record 
(if you still need TO DELETE it, 
1.	back up the database
2.	REVOKE CREATE SESSION from the stec_schema users
3.	disconnect all users of the stec_schema,
4.	delete all records of vw_stec_user of the stec schema
5.	delete all records of vw_stec_role of the stec schema
6.	delete all records of vw_obj_operation_set of the stec schema
7.	drop the stec_schema USER
8.	DISABLE THIS TRIGGER
9.	DELETE the record
10.	???
11.	ENABLE THIS TRIGGER
)');
  END IF;
 END;  
 /
 
 -- DROP TABLE stec_user;
 CREATE TABLE				stec_user     
 (															
	stec_user_id	INT   	      NOT NULL,
	login         VARCHAR2(30)	NOT NULL,
	stec_id			  INT  	      	NOT NULL,
	CONSTRAINT fk_stec_user_stec_id
	FOREIGN KEY (stec_id)	REFERENCES stec	(stec_id),	
  CONSTRAINT uq_login   UNIQUE (login),
	CONSTRAINT pk_stec_user_id     
	PRIMARY KEY ( stec_user_id ) 
	ENABLE                     
 );	
 -- DROP SEQUENCE sq_stec_user_i;
 CREATE SEQUENCE sq_stec_user_i START WITH 1 INCREMENT BY 1 NOMAXVALUE;
 -- DROP TRIGGER tr_stec_user_i;
 CREATE OR REPLACE TRIGGER tr_stec_user_biu  
 BEFORE INSERT OR UPDATE ON stec_user 
 FOR EACH ROW 
 BEGIN
  IF INSERTING THEN
	  IF :NEW.stec_user_id IS NULL THEN
	    SELECT sq_stec_user_i.NEXTVAL INTO :NEW.stec_user_id FROM DUAL;  
	  END IF;
  ELSIF UPDATING THEN
      IF (  :NEW.login <> :OLD.login  )  THEN 
        RAISE_APPLICATION_ERROR(-20011, 'DO NEVER change login!!!'); 
      END IF; 
  END IF;
 END;  
 /

 -- DROP TABLE stec_role;
 CREATE TABLE				stec_role     
 (															
	stec_role_id	INT   	      NOT NULL,
	role_name     VARCHAR2(30)	NOT NULL,
	stec_id			  INT  	      	NOT NULL,
	CONSTRAINT fk_stec_role_stec_id
	FOREIGN KEY (stec_id)	REFERENCES stec	(stec_id),	
  CONSTRAINT uq_role_name   UNIQUE (role_name),
	CONSTRAINT pk_stec_role_id     
	PRIMARY KEY ( stec_role_id ) 
	ENABLE                     
 );	
 -- DROP SEQUENCE sq_stec_role_i;
 CREATE SEQUENCE sq_stec_role_i START WITH 1 INCREMENT BY 1 NOMAXVALUE;
 -- DROP TRIGGER tr_stec_role_i;
 CREATE OR REPLACE TRIGGER tr_stec_role_biu  
 BEFORE INSERT ON stec_role 
 FOR EACH ROW 
 BEGIN
  IF INSERTING THEN
	  IF :NEW.stec_role_id IS NULL THEN
	    SELECT sq_stec_role_i.NEXTVAL INTO :NEW.stec_role_id FROM DUAL;  
	  END IF;
  ELSIF UPDATING THEN
      IF (  :NEW.role_name <> :OLD.role_name  )  THEN 
        RAISE_APPLICATION_ERROR(-20011, 'DO NEVER change role_name'); 
      END IF; 
  END IF;
 END;  
 /

 
ALTER SESSION SET CURRENT_SCHEMA=SYS;
-- INSERT INTO STEC_USER.stec_user(stec_user_id, login, stec_id) VALUES(NULL, 'USER1', 1);
-- SELECT * FROM STEC_USER.stec_user;
-- TRUNCATE TABLE STEC_USER.stec_user;
-- COMMIT;

------------------------------------------------------------------------------------
