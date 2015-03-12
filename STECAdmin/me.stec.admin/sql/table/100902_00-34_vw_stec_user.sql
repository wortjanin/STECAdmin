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
L.pw password,							-- #	Пароль,					Password
(case when L.pw IS NULL 
	  then 0 else 1 end) pass_is_temp,	-- #	Пароль временный,		PassIsTemp,		Boolean,	,				true
SU.stec_user_cat_id cat_id,				-- #	ИН Категории,			IdCat 
SUC.name cat							-- #	Категория пользователя,	Cat
FROM stec_user SU, stec_login L, stec_user_cat SUC
WHERE SU.stec_user_id = L.stec_user_id AND SU.stec_user_cat_id = SUC.stec_user_cat_id;

-- select * from vw_stec_user order by stec_user_id;

CREATE OR REPLACE TRIGGER tr_vw_stec_user_ioi
INSTEAD OF INSERT
ON vw_stec_user
FOR EACH ROW
BEGIN
	-- FOR LOADING (to provide original id-s) USE  pkg_stec_account.pr_create directly
	-- Note also, that after all pkg_stec_account.pr_create operations are done,
	-- you should call pkg_stec_account.pr_transaction_finish('Y') to run the actions 
	--
	-- AFTER LOADING do not forget to setup the sq_stec_user_i:
	-- CALL pr_set_startval_for_seq('sq_stec_user_i', stec_user_id_max + 1);
	--
	-- WHEN USING vw_stec_user, pr_commit should be called at the end to run the transaction

	pkg_stec_account.pr_create_transact(:NEW.surname, :NEW.name, :NEW.patronymic, 
  		:NEW.gender, :NEW.password, /*:NEW.stec_user_id*/ NULL,	:NEW.cat_id );
END;
/

CREATE OR REPLACE TRIGGER tr_vw_stec_user_iou
INSTEAD OF UPDATE
ON vw_stec_user
FOR EACH ROW
BEGIN
	pkg_stec_account.pr_change_transact( 
	  :OLD.stec_user_id,
      :OLD.surname, 	:NEW.surname,
      :OLD.name,		:NEW.name,
      :OLD.patronymic,  :NEW.patronymic,
      :OLD.gender,	    :NEW.gender,
      :OLD.password,    :NEW.password,
      :OLD.cat_id,      :NEW.cat_id      );		
--   pkg_stec_account.pr_change(:OLD.stec_user_id, :NEW.surname, :NEW.name, :NEW.patronymic, 
--   		:NEW.gender, pw_changed, pw, :NEW.cat_id);
END;
/

CREATE OR REPLACE TRIGGER tr_vw_stec_user_iod
INSTEAD OF DELETE
ON vw_stec_user
FOR EACH ROW
BEGIN
	pkg_stec_account.pr_drop_transact(  	:OLD.stec_user_id,
	      :OLD.surname,   :OLD.name,    	:OLD.patronymic,
	      :OLD.gender,    :OLD.password,  	:OLD.cat_id);
--  pkg_stec_account.pr_drop(:OLD.stec_user_id);
END;
/

--------------------------------------------------------------------------------