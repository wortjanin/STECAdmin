--		
-- #	PackageName me.stec.admin.logic.user
--							dbType									Caption,						Name(1),		jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--							SchemeName								ClassSummary,					ClassName(1),	,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE				stec_user    
 (														' ||  -- #  Персональная информация,		StecUser,		,	    ,                       true
'	stec_user_id		INT	        		NOT NULL,	' ||  -- #  ИН Пользователя,				Id
'	surname				VARCHAR2(32 CHAR)	NOT NULL,	' ||  -- #	Фамилия,						Surname
'	name				VARCHAR2(32 CHAR)	NOT NULL,	' ||  -- #	Имя,							Name
'	patronymic			VARCHAR2(32 CHAR)	NOT NULL,	' ||  -- #	Отчество,						Patronymic
'	gender				CHAR(1 BYTE)		NOT NULL,	' ||  -- #	Пол,							Gender
'	stec_user_cat_id	INT	        		NOT NULL,	' ||  -- #  ИН Категории,					IdStecUserCat
'	stec_accessor_id	INT	        		NOT NULL,	' ||  -- #	ИН Аксессора,					IdAccessor,			,		false,					true
'	CONSTRAINT ck_stec_user_gender CHECK (gender IN (''M'', ''W'')),			' ||
'	CONSTRAINT fk_stec_user_acc_id
	FOREIGN KEY (stec_accessor_id) REFERENCES stec_accessor (stec_accessor_id),	' ||
'	CONSTRAINT fk_stec_user_cat_id
	FOREIGN KEY (stec_user_cat_id) REFERENCES stec_user_cat (stec_user_cat_id),	' ||
'	CONSTRAINT pk_stec_user_id     
	PRIMARY KEY ( stec_user_id ) 
	ENABLE                     
 )											' 
);
 -- абвгдеёжабвгдеёжабвгдеёжабвгдеёж
 -- Салтыков-Щедринычаускас
 
-- CALL pr_drop_if_exists ('DROP SEQUENCE sq_stec_user_i ');
CALL pr_create_if_not_exists('CREATE SEQUENCE sq_stec_user_i START WITH 1 INCREMENT BY 1 NOMAXVALUE ');

CREATE OR REPLACE TRIGGER tr_stec_user_biud 
BEFORE INSERT OR UPDATE OR DELETE ON stec_user
FOR EACH ROW
DECLARE
	m_tp_id stec_accessor_type.stec_accessor_type_id%TYPE;
BEGIN
	IF ( NOT (SYS.pkg_stec.fn_my_caller IN ( '<package body ' || fn_stec_schema || '.PKG_STEC_ACCOUNT>')) )  THEN 
		RAISE_APPLICATION_ERROR(-20001, 'Cannot insert/update/delete directly'); 
	END IF;
	
	IF    INSERTING THEN

		SELECT SAT.stec_accessor_type_id 	INTO m_tp_id FROM stec_accessor_type SAT
											WHERE SAT.constant = 'SAT_USER';
		INSERT INTO stec_accessor(stec_accessor_id, 		stec_accessor_type_id) 
		VALUES					 (:NEW.stec_accessor_id,	m_tp_id);
		IF :NEW.stec_accessor_id IS NULL THEN
			SELECT sq_stec_accessor_i.CURRVAL INTO :NEW.stec_accessor_id FROM DUAL;
		END IF;
		IF :NEW.stec_user_id IS NULL THEN
			SELECT sq_stec_user_i.NEXTVAL INTO :NEW.stec_user_id FROM DUAL;
		END IF;

	ELSIF UPDATING THEN

		IF (:OLD.stec_user_id		<> :NEW.stec_user_id 		OR
			:OLD.stec_accessor_id 	<> :NEW.stec_accessor_id		) THEN
			RAISE_APPLICATION_ERROR(-20001, 'You cannot change stec_user_id or stec_accessor_id');
		END IF;

	ELSIF DELETING THEN
		
    	DELETE FROM stec_accessor SA WHERE SA.stec_accessor_id = :OLD.stec_accessor_id;
	
 	END IF;

END;
/
--------------------------------------------------------------------------------
