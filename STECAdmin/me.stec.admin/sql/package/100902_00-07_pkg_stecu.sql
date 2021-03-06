CREATE OR REPLACE PACKAGE pkg_stecu AS
-- u=util
	FUNCTION INEQ(in_1 IN VARCHAR2, in_2 IN VARCHAR2)	RETURN BOOLEAN;
	FUNCTION INEQ(in_1 IN NUMBER,	in_2 IN NUMBER)		RETURN BOOLEAN;
	FUNCTION INEQ(in_1 IN DATE,		in_2 IN DATE)		RETURN BOOLEAN;
END;
/

CREATE OR REPLACE
PACKAGE BODY pkg_stecu AS

	FUNCTION INEQ(in_1 IN VARCHAR2, in_2 IN VARCHAR2)	RETURN BOOLEAN
	AS
	BEGIN
		RETURN (
			in_1 <> in_2						OR
			in_1 IS NULL AND NOT in_2 IS NULL	OR
			NOT in_1 IS NULL AND in_2 IS NULL 
		);
	END;

	FUNCTION INEQ(in_1 IN NUMBER,	in_2 IN NUMBER)		RETURN BOOLEAN
	AS
	BEGIN
		RETURN (
			in_1 <> in_2						OR
			in_1 IS NULL AND NOT in_2 IS NULL	OR
			NOT in_1 IS NULL AND in_2 IS NULL 
		);
	END;
	
	FUNCTION INEQ(in_1 IN DATE,		in_2 IN DATE)		RETURN BOOLEAN
	AS
	BEGIN
		RETURN (
			in_1 <> in_2						OR
			in_1 IS NULL AND NOT in_2 IS NULL	OR
			NOT in_1 IS NULL AND in_2 IS NULL 
		);
	END;

END;
/
