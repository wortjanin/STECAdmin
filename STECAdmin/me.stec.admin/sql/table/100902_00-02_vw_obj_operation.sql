CREATE OR REPLACE VIEW vw_obj_operation AS
SELECT  							
OO.obj_operation_id,  			 
OO.obj_operation_set_id,  			 
OO.object_name,  			 
OO.object_type,  			 
OO.sel,  			 
OO.ins,  			 
OO.upd,  			 
OO.del,  			 
OO.exe  			 
FROM obj_operation OO;

-- select * from vw_obj_operation_set;

--	PROCEDURE pr_oper_create_transact(
--		in_obj_operation_id			IN obj_operation	.obj_operation_id		%TYPE,		
--		in_obj_operation_set_id		IN obj_operation	.obj_operation_set_id	%TYPE,
--		in_object_name				IN obj_operation	.object_name			%TYPE,
--		in_object_type				IN obj_operation	.object_type			%TYPE,
--		in_sel						IN obj_operation	.sel					%TYPE,
--		in_ins						IN obj_operation	.ins					%TYPE,
--		in_upd						IN obj_operation	.upd					%TYPE,
--		in_del						IN obj_operation	.del					%TYPE,
--		in_exe						IN obj_operation	.exe					%TYPE
--	)

--	PROCEDURE pr_oper_change_transact(
--		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
--		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
--		in_object_name_o			IN obj_operation	.object_name			%TYPE,
--		in_object_type_o			IN obj_operation	.object_type			%TYPE,
--		in_sel_o					IN obj_operation	.sel					%TYPE,
--		in_sel_n					IN obj_operation	.sel					%TYPE,
--		in_ins_o					IN obj_operation	.ins					%TYPE,
--		in_ins_n					IN obj_operation	.ins					%TYPE,
--		in_upd_o					IN obj_operation	.upd					%TYPE,
--		in_upd_n					IN obj_operation	.upd					%TYPE,
--		in_del_o					IN obj_operation	.del					%TYPE,
--		in_del_n					IN obj_operation	.del					%TYPE,
--		in_exe_o					IN obj_operation	.exe					%TYPE,
--		in_exe_n					IN obj_operation	.exe					%TYPE
--	)

--	PROCEDURE pr_oper_drop_transact(
--		in_obj_operation_id_o		IN obj_operation	.obj_operation_id		%TYPE,		
--		in_obj_operation_set_id_o	IN obj_operation	.obj_operation_set_id	%TYPE,
--		in_object_name_o			IN obj_operation	.object_name			%TYPE,
--		in_object_type_o			IN obj_operation	.object_type			%TYPE,
--		in_sel_o					IN obj_operation	.sel					%TYPE,
--		in_ins_o					IN obj_operation	.ins					%TYPE,
--		in_upd_o					IN obj_operation	.upd					%TYPE,
--		in_del_o					IN obj_operation	.del					%TYPE,
--		in_exe_o					IN obj_operation	.exe					%TYPE
--	);  	

CREATE OR REPLACE TRIGGER tr_vw_obj_operation_iiud
INSTEAD OF INSERT OR UPDATE OR DELETE
ON vw_obj_operation
FOR EACH ROW
BEGIN
	IF		INSERTING	THEN
		pkg_stec_operation_set.pr_oper_create_transact(/*:NEW.obj_operation_id*/ NULL, 
			:NEW.obj_operation_set_id,	:NEW.object_name,	:NEW.object_type,
			:NEW.sel,	:NEW.ins,	:NEW.upd,	:NEW.del,	:NEW.exe );
	ELSIF	UPDATING	THEN
		pkg_stec_operation_set.pr_oper_change_transact( 
		  :OLD.obj_operation_id,
		  :OLD.obj_operation_set_id,
		  :OLD.object_name,
		  :OLD.object_type,
	      :OLD.sel, 	:NEW.sel,
	      :OLD.ins, 	:NEW.ins,
	      :OLD.upd, 	:NEW.upd,
	      :OLD.del, 	:NEW.del,
	      :OLD.exe,		:NEW.exe	);		
	ELSIF	DELETING	THEN
		pkg_stec_operation_set.pr_oper_drop_transact(:OLD.obj_operation_id, 
			:OLD.obj_operation_set_id,	:OLD.object_name,	:OLD.object_type,
			:OLD.sel,	:OLD.ins,	:OLD.upd,	:OLD.del,	:OLD.exe );
	END IF;
END;
/

--------------------------------------------------------------------------------
