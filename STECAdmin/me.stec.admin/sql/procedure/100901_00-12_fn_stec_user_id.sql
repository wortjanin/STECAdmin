CREATE OR REPLACE  FUNCTION fn_stec_user_id RETURN INT
AS
	m_id INT;
BEGIN
	IF ('SYS' = USER) THEN
		RETURN NULL;
	END IF;

	SELECT SU.stec_user_id 	INTO m_id 
		FROM stec_user SU, stec_login SL
		WHERE 	SL.login		= USER 				AND
				SL.stec_user_id	= SU.stec_user_id;
	RETURN   m_id;  
END;
/

--------------------------------------------------------------------------------
