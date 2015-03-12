CREATE OR REPLACE FUNCTION fn_num(in_string VARCHAR2) RETURN VARCHAR2
AS
BEGIN
	RETURN (CASE WHEN in_string IS NULL THEN 'NULL' ELSE  in_string END);
END;
/

--------------------------------------------------------------------------------
