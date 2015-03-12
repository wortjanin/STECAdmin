--		
-- #	PackageName	me.stec.admin.logic.org
-- #	MakeComboProvider
--
--				dbType											Caption,						Name(1),			jType,	dbLoadInList,	 		dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull
--
--				SchemeName										ClassSummary,					ClassName(1),		,       ,						Scheme.ReadOnly

CALL pr_create_if_not_exists(
'CREATE TABLE	div_faculty_kurs     
 (													' ||  -- #  Факультет,						Faculty,			,	    ,                       true
'	div_faculty_kurs_id	INT	   		NOT NULL,		' ||  -- #  ИН Курса-факультета,			Id
'	div_kurs_id			INT	       	NOT NULL,		' ||  -- #  ИН Курса,						IdKurs
'	div_faculty_id		INT	       	NOT NULL,		' ||  -- #  ИН Факультета,					IdFaculty
'	division_id			INT    		NOT NULL,		' ||  -- #	ИН Подразделения,				IdDivision,			,		false,					true
'	CONSTRAINT fk_div_faculty_kurs_kurs
	FOREIGN KEY  (div_kurs_id)		REFERENCES div_kurs		(div_kurs_id),		' ||
'	CONSTRAINT fk_div_faculty_kurs_faculty
	FOREIGN KEY  (div_faculty_id)	REFERENCES div_faculty	(div_faculty_id),	' ||
'	CONSTRAINT fk_div_facilty_kurs_division
	FOREIGN KEY  (division_id) 		REFERENCES division 	(division_id),		' ||
'	CONSTRAINT pk_div_faculty_kurs_id     
	PRIMARY KEY ( div_faculty_kurs_id ) 
	ENABLE                     
 )											' 
);

-- CALL pr_autoincrement_add_to('div_faculty_kurs');

-- CALL pr_create_tr_division_bid('div_faculty_kurs', 'ST_UNIVER');
CALL pr_create_tr_division_biud('div_faculty_kurs');
-- select * from division_type;
DECLARE
	m_cnt INT := 0;
BEGIN
	SELECT COUNT(*) INTO m_cnt FROM division_type DT WHERE DT.constant='DIV_FACULTY_KURS';
	IF m_cnt < 1 THEN
    INSERT  INTO division_type(division_type_id,  constant,       		name,    				table_name)
            VALUES            (NULL,              'DIV_FACULTY_KURS',  	'Факультетский курс',  	'DIV_FACULTY_KURS');
    COMMIT;
	END IF;
END;
/
--------------------------------------------------------------------------------

