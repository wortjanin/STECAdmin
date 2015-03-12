CREATE OR REPLACE PACKAGE pkg_stec_session AS
	FUNCTION  fn_schema				RETURN VARCHAR2;
	FUNCTION  fn_schema_id			RETURN INT;
	FUNCTION  fn_user_id			RETURN INT;
 	FUNCTION  fn_user_accessor_id	RETURN INT;
END;
/

CREATE OR REPLACE
PACKAGE BODY pkg_stec_session AS

	mp_schema		VARCHAR2(30 BYTE)	:= fn_stec_schema;
	mp_schema_id	INT					:= fn_stec_schema_num;
	mp_user_id		INT					:= fn_stec_user_id;
	mp_user_acc_id	INT					:= fn_stec_user_acc_id;
	
	FUNCTION  fn_schema RETURN VARCHAR2
	AS
	BEGIN
		RETURN mp_schema;
	END;

	FUNCTION  fn_schema_id	RETURN INT
	AS
	BEGIN
		RETURN mp_schema_id;
	END;
	
	FUNCTION  fn_user_id RETURN INT
	AS
	BEGIN
		RETURN mp_user_id;
	END;

	FUNCTION  fn_user_accessor_id RETURN INT
	AS
	BEGIN
		RETURN mp_user_acc_id;
	END;

END;
/

--------------------------------------------------------------------------------
