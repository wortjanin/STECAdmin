CREATE OR REPLACE VIEW vw_obj_operation_set AS
SELECT  							
OS.obj_operation_set_id,  			 
OS.constant,						
OS.name								
FROM obj_operation_set OS;

-- select * from vw_obj_operation_set;

--	PROCEDURE pr_oper_set_create_transact(
--		in_obj_operation_set_id		IN obj_operation_set	.obj_operation_set_id	%TYPE,
--		in_constant					IN obj_operation_set	.constant				%TYPE,
--		in_name						IN obj_operation_set	.name					%TYPE
--  	);

--	PROCEDURE pr_oper_set_change_transact(
--		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
--		in_constant_o				IN obj_operation_set	.constant				%TYPE,
--		in_constant_n				IN obj_operation_set	.constant				%TYPE,
--		in_name_o					IN obj_operation_set	.name					%TYPE,
--		in_name_n					IN obj_operation_set	.name					%TYPE
--  	)

--  	PROCEDURE pr_oper_set_drop_transact(
--		in_obj_operation_set_id_o	IN obj_operation_set	.obj_operation_set_id	%TYPE,
--		in_constant_o				IN obj_operation_set	.constant				%TYPE,
--		in_name_o					IN obj_operation_set	.name					%TYPE
--  	);

CREATE OR REPLACE TRIGGER tr_vw_obj_operation_set_iiud
INSTEAD OF INSERT OR UPDATE OR DELETE
ON vw_obj_operation_set
FOR EACH ROW
BEGIN
	IF		INSERTING	THEN
		pkg_stec_operation_set.pr_oper_set_create_transact(/*:NEW.obj_operation_set_id*/ NULL, 
			:NEW.constant, :NEW.name );
	ELSIF	UPDATING	THEN
		pkg_stec_operation_set.pr_oper_set_change_transact( 
		  :OLD.obj_operation_set_id,
	      :OLD.constant, 	:NEW.constant,
	      :OLD.name,		:NEW.name);		
	ELSIF	DELETING	THEN
		pkg_stec_operation_set.pr_oper_set_drop_transact(  :OLD.obj_operation_set_id,
		      :OLD.constant,   :OLD.name);
	END IF;
END;
/


--------------------------------------------------------------------------------
