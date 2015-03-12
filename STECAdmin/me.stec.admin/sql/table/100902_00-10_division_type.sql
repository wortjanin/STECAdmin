CALL pr_create_if_not_exists(
'CREATE TABLE				division_type    
 (															' ||
'	division_type_id	INT	NOT NULL,						' ||
'	constant			VARCHAR2(34 BYTE)	NOT NULL,		' ||
'	name				VARCHAR2(32 CHAR)	NOT NULL,		' ||
'	table_name			VARCHAR2(30 BYTE)	NOT NULL,		' ||
'	CONSTRAINT uq_division_type  	UNIQUE (constant),		' ||
'	CONSTRAINT uq_division_type_tb 	UNIQUE (table_name),	' ||
'	CONSTRAINT pk_division_type_id     
	PRIMARY KEY ( division_type_id ) 
	ENABLE                     
 )											' 
);
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_division_type_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');

-- constant
--	DIV_FACULTY
--	DIV_FACULTY_KURS
--	DIV_SPECIALITY
--	DIV_GROUP_UNIVER
--	DIV_GROUP_SOC

CREATE OR REPLACE TRIGGER tr_division_type_biu 
BEFORE INSERT OR UPDATE ON division_type
FOR EACH ROW
DECLARE
  me_obj_name DBA_OBJECTS.OBJECT_NAME%TYPE;
  m_table_name_n division_type.table_name%TYPE := UPPER(:NEW.table_name);
BEGIN
	IF INSERTING OR UPDATING THEN
		SELECT OBJECT_NAME 	INTO me_obj_name
			FROM DBA_OBJECTS DO
				WHERE	fn_stec_schema  = DO.OWNER			AND 
						m_table_name_n	= DO.OBJECT_NAME	AND
						'TABLE'			= DO.OBJECT_TYPE;
	END IF;
-- if the NEW.table_name or NEW.object_type are incorrect, there should be an exception
	IF INSERTING THEN
		IF :NEW.division_type_id IS NULL THEN
			SELECT sq_division_type_i.NEXTVAL INTO :NEW.division_type_id FROM DUAL;
		END IF;
		:NEW.table_name := m_table_name_n;
	ELSIF UPDATING THEN
		:NEW.table_name := m_table_name_n;
	END IF;
END;
/

DECLARE
	m_cnt INT := 0;
BEGIN
	SELECT COUNT(*) INTO m_cnt FROM a_dangerous_object ADO
		WHERE ADO.object_name = 'DIVISION_TYPE' AND ADO.object_type='TB';
	IF m_cnt < 1 THEN
		INSERT 	INTO a_dangerous_object	(object_name, 		object_type, 	description)
		   		VALUES					('DIVISION_TYPE',	'TB',			'Таблица DIVISION_TYPE содержит поле table_name (имя таблицы БД) - имена этих таблиц в БД категорически НЕ рекомендуется изменять');
		COMMIT;
	END IF;
END;
/
-- select * from a_dangerous_object;
	
--------------------------------------------------------------------------------
