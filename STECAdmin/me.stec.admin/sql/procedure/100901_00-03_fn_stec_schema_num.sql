CREATE OR REPLACE FUNCTION fn_stec_schema_num RETURN INT
AS
	m_result INT;
BEGIN
	SELECT S.stec_id 	INTO m_result FROM STEC_USER.stec S
						WHERE	S.stec_schema=fn_stec_schema;
	RETURN m_result;
END;
/

-- SELECT fn_stec_schema_num FROM DUAL;

--------------------------------------------------------------------------------

