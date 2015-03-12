--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_stec_schema RETURN VARCHAR2
AS
BEGIN
  RETURN REGEXP_SUBSTR(			
  			REGEXP_SUBSTR(
  				DBMS_UTILITY.FORMAT_CALL_STACK, 
  				'[^[:space:]]+.FN_STEC_SCHEMA' ), 
  			'[^.]+');
END;
/
-- SELECT fn_stec_schema FROM DUAL;

--------------------------------------------------------------------------------
