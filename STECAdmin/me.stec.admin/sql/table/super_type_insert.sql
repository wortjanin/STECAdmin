-- truncate table super_type;
-- select * from super_type;
BEGIN
	INSERT INTO super_type(super_type_id, constant, name) VALUES(1, 'ST_UNIVER',       'Университет');
	INSERT INTO super_type(super_type_id, constant, name) VALUES(2, 'ST_WORK',         'Работа');
	COMMIT;
END;
/

--------------------------------------------------------------------------