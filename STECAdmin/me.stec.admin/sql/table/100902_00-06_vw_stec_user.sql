--	
-- #	PackageName		me.stec.admin.logic.user
--
-- #	Sequence		sq_stec_user_i	
--
--												Caption,				Name(1),		jType,		dbLoadInList, 	dbReadOnly,		    dbSaveOnly,     dbIsCombo,		dbIsNotNull,	isMinMax
--
--					   SchemeName				ClassSummary,			ClassName(1),	,       	,				Scheme.ReadOnly

CREATE OR REPLACE VIEW vw_stec_user AS
SELECT  								-- #	Пользователь,			StecUser,		,			,				true
SU.stec_user_id,  						-- #	ИН Пользователя,		Id 
SU.surname,								-- #	Фамилия,				Surname
SU.name,								-- #	Имя,					Name
SU.patronymic,							-- #	Отчество,				Patronymic 
SU.gender,								-- #	Пол,					Gender
L.login, 								-- #	Логин,					Login
L.pw,									-- #	Пароль,					Password
L.pw_is_temp,							-- #	Пароль временный,		PassIsTemp,		Boolean,	,				true
L.blocked,								-- #	Аккаунт заблокирован,	Blocked							
SU.stec_user_cat_id cat_id,				-- #	ИН Категории,			IdCat 
SUC.name cat,							-- #	Категория пользователя,	Cat
SU.stec_accessor_id
FROM stec_user SU, stec_login L, stec_user_cat SUC
WHERE SU.stec_user_id = L.stec_user_id AND SU.stec_user_cat_id = SUC.stec_user_cat_id;

-- select * from vw_stec_user order by stec_user_id;

--	PROCEDURE pr_create_transact(
--			in_stec_user_id		IN	stec_user	.stec_user_id		%TYPE,
--			in_stec_accessor_id	IN	stec_user	.stec_accessor_id	%TYPE,
--			in_surname    		IN  stec_user	.surname			%TYPE,
--			in_name       		IN  stec_user	.name				%TYPE,
--			in_patronymic 		IN  stec_user	.patronymic			%TYPE,
--			in_gender     		IN  stec_user	.gender				%TYPE,
--			in_stec_user_cat_id	IN	stec_user	.stec_user_cat_id	%TYPE,
--			in_pw		   		IN  stec_login	.pw					%TYPE,
--			in_blocked			IN	stec_login	.blocked			%TYPE
--			)

--	PROCEDURE pr_change_transact(
--			in_stec_user_id_o 		IN  stec_user	.stec_user_id		%TYPE,
--			in_stec_accessor_id_o	IN  stec_user	.stec_accessor_id	%TYPE,
--			in_surname_o      		IN  stec_user	.surname			%TYPE,
--			in_surname_n     		IN  stec_user	.surname			%TYPE,
--			in_name_o         		IN  stec_user	.name				%TYPE,
--			in_name_n         		IN  stec_user	.name				%TYPE,
--			in_patronymic_o   		IN  stec_user	.patronymic			%TYPE,
--			in_patronymic_n   		IN  stec_user	.patronymic			%TYPE,
--			in_gender_o       		IN  stec_user	.gender				%TYPE,
--			in_gender_n       		IN  stec_user	.gender				%TYPE,
--			in_stec_user_cat_id_o	IN	stec_user	.stec_user_cat_id	%TYPE,
--			in_stec_user_cat_id_n	IN	stec_user	.stec_user_cat_id	%TYPE,
--			in_pw_o			   		IN  stec_login	.pw					%TYPE,
--			in_pw_n		     		IN  stec_login	.pw					%TYPE,
--			in_blocked_o			IN	stec_login	.blocked			%TYPE,
--			in_blocked_n			IN	stec_login	.blocked			%TYPE
--		)

--	PROCEDURE pr_drop_transact(
--			in_stec_user_id_o  		IN stec_user	.stec_user_id		%TYPE,
--			in_stec_accessor_id_o	IN stec_user	.stec_accessor_id	%TYPE,
--			in_surname_o     		IN stec_user	.surname			%TYPE,
--			in_name_o     			IN stec_user	.name				%TYPE,
--			in_patronymic_o   		IN stec_user	.patronymic			%TYPE,
--			in_gender_o     		IN stec_user	.gender				%TYPE,
--			in_stec_user_cat_id_o	IN stec_user	.stec_user_cat_id	%TYPE,
--			in_password_o     		IN stec_login	.pw					%TYPE,
--			in_blocked_o			IN stec_login	.blocked			%TYPE
--		)
CREATE OR REPLACE TRIGGER tr_vw_stec_user_iiud
INSTEAD OF INSERT OR UPDATE OR DELETE
ON vw_stec_user
FOR EACH ROW
BEGIN
	-- FOR LOADING (to provide original id-s) USE  pkg_stec_account.pr_create_transact directly
	-- Note also, that after all pkg_stec_account.pr_create_transact operations are done,
	-- you should call pr_commit to run the actions 
	--
	-- AFTER LOADING do not forget to setup the sq_stec_user_i:
	-- CALL pr_set_startval_for_seq('sq_stec_user_i', stec_user_id_max + 1);
	--
	-- WHEN USING vw_stec_user, pr_commit should be called at the end to run the transaction
	IF		INSERTING	THEN
		pkg_stec_account.pr_create_transact(/*:NEW.stec_user_id*/ NULL, /*:NEW.stec_accessor_id*/ NULL, 
			:NEW.surname, :NEW.name, :NEW.patronymic, 
	  		:NEW.gender, nvl(:NEW.cat_id, 0), :NEW.pw, nvl(:NEW.blocked, 'Y') );
	ELSIF	UPDATING	THEN
		pkg_stec_account.pr_change_transact( 
		  :OLD.stec_user_id,
		  :OLD.stec_accessor_id,
	      :OLD.surname, 	:NEW.surname,
	      :OLD.name,		:NEW.name,
	      :OLD.patronymic,  :NEW.patronymic,
	      :OLD.gender,	    :NEW.gender,
	      :OLD.cat_id,      :NEW.cat_id,
	      :OLD.pw,    		:NEW.pw,
	      :OLD.blocked,		:NEW.blocked);		
	ELSIF	DELETING	THEN
		pkg_stec_account.pr_drop_transact(  :OLD.stec_user_id,	:OLD.stec_accessor_id,
		      :OLD.surname,   :OLD.name,    :OLD.patronymic,
		      :OLD.gender,    :OLD.cat_id, 	:OLD.pw,		:OLD.blocked);
	END IF;
END;
/

--------------------------------------------------------------------------------
