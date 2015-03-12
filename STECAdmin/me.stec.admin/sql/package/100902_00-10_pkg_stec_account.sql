CREATE OR REPLACE PACKAGE pkg_stec_account AS
-- RULE: DO NOT ALLOW USERS to use it directly!
-- Use this package directly ONLY ON THE DATA LOADING
-- or in other packages, functions, procedures, and triggers
-- (Ignoranse of this rule can lead to serious sequrity damage of the system)
	PROCEDURE pr_lock;

	PROCEDURE pr_lock_release;
	
	-- pr_create is for internal use!
	PROCEDURE pr_create(
		in_stec_user_id			IN	stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id		IN	stec_user	.stec_accessor_id	%TYPE DEFAULT NULL,
		in_surname    			IN  stec_user	.surname			%TYPE,
		in_name       			IN  stec_user	.name				%TYPE,
		in_patronymic 			IN  stec_user	.patronymic			%TYPE,
		in_gender     			IN  stec_user	.gender				%TYPE,
		in_stec_user_cat_id		IN	stec_user	.stec_user_cat_id	%TYPE DEFAULT 0,
		in_pw		   			IN  stec_login	.pw					%TYPE DEFAULT NULL,
		in_blocked				IN	stec_login	.blocked			%TYPE DEFAULT 'Y'
	);
	PROCEDURE pr_create_transact(
		in_stec_user_id			IN	stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id		IN	stec_user	.stec_accessor_id	%TYPE DEFAULT NULL,
		in_surname    			IN  stec_user	.surname			%TYPE,
		in_name       			IN  stec_user	.name				%TYPE,
		in_patronymic 			IN  stec_user	.patronymic			%TYPE,
		in_gender     			IN  stec_user	.gender				%TYPE,
		in_stec_user_cat_id		IN	stec_user	.stec_user_cat_id	%TYPE DEFAULT 0,
		in_pw		   			IN  stec_login	.pw					%TYPE DEFAULT NULL,
		in_blocked				IN	stec_login	.blocked			%TYPE DEFAULT 'Y'
	);

	-- pr_change is for internal use!
	PROCEDURE pr_change(
		in_stec_user_id_o 		IN  stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id_o	IN  stec_user	.stec_accessor_id	%TYPE,
		in_surname_n      		IN  stec_user	.surname			%TYPE,
		in_name_n         		IN  stec_user	.name				%TYPE,
		in_patronymic_n   		IN  stec_user	.patronymic			%TYPE,
		in_gender_n       		IN  stec_user	.gender				%TYPE,
		in_stec_user_cat_id_n	IN	stec_user	.stec_user_cat_id	%TYPE,
		in_pw_o			   		IN  stec_login	.pw					%TYPE,
		in_pw_n		     		IN  stec_login	.pw					%TYPE,
		in_blocked_o			IN	stec_login	.blocked			%TYPE,
		in_blocked_n			IN	stec_login	.blocked			%TYPE
    );	
	PROCEDURE pr_change_transact(
		in_stec_user_id_o 		IN  stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id_o	IN  stec_user	.stec_accessor_id	%TYPE,
		in_surname_o      		IN  stec_user	.surname			%TYPE,
		in_surname_n     		IN  stec_user	.surname			%TYPE,
		in_name_o         		IN  stec_user	.name				%TYPE,
		in_name_n         		IN  stec_user	.name				%TYPE,
		in_patronymic_o   		IN  stec_user	.patronymic			%TYPE,
		in_patronymic_n   		IN  stec_user	.patronymic			%TYPE,
		in_gender_o       		IN  stec_user	.gender				%TYPE,
		in_gender_n       		IN  stec_user	.gender				%TYPE,
		in_stec_user_cat_id_o	IN	stec_user	.stec_user_cat_id	%TYPE,
		in_stec_user_cat_id_n	IN	stec_user	.stec_user_cat_id	%TYPE,
		in_pw_o			   		IN  stec_login	.pw					%TYPE,
		in_pw_n		     		IN  stec_login	.pw					%TYPE,
		in_blocked_o			IN	stec_login	.blocked			%TYPE,
		in_blocked_n			IN	stec_login	.blocked			%TYPE
	);	
--	PROCEDURE pr_change_transact(
--		in_U_o					IN  stec_user	%ROWTYPE,
--		in_U_n					IN  stec_user	%ROWTYPE,
--		in_L_o					IN  stec_login	%ROWTYPE,
--		in_L_n					IN  stec_login	%ROWTYPE
--	);

	-- pr_drop is for internal use!
	PROCEDURE pr_drop(
		in_stec_user_id			IN stec_user	.stec_user_id		%TYPE
	);
	PROCEDURE pr_drop_transact(
		in_stec_user_id_o  		IN stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id_o	IN stec_user	.stec_accessor_id	%TYPE,
		in_surname_o     		IN stec_user	.surname			%TYPE,
		in_name_o     			IN stec_user	.name				%TYPE,
		in_patronymic_o   		IN stec_user	.patronymic			%TYPE,
		in_gender_o     		IN stec_user	.gender				%TYPE,
		in_stec_user_cat_id_o	IN stec_user	.stec_user_cat_id	%TYPE,
		in_pw_o		     		IN stec_login	.pw					%TYPE,
		in_blocked_o			IN stec_login	.blocked			%TYPE
	);	
--	PROCEDURE pr_drop_transact(
--		in_U_o					IN  stec_user	%ROWTYPE,
--		in_L_o					IN  stec_login	%ROWTYPE
--	);
    
	PROCEDURE pr_ora_role_create(in_role		IN VARCHAR2);
	PROCEDURE pr_ora_role_drop	(in_role		IN VARCHAR2);
	PROCEDURE pr_ora_grant		(in_grant_expr	IN VARCHAR2);
  
END;
/


CREATE OR REPLACE
PACKAGE BODY pkg_stec_account AS
-- RULE: DO NOT ALLOW USERS to use it directly!
-- Use this package directly ONLY ON THE DATA LOADING
-- or in other packages, functions, procedures, and triggers
-- (Ignoranse of this rule can lead to serious sequrity damage of the system)

--------------------------------------------------------------------------------
------------------------------PRIVATE_PART--------------------------------------
--------------------------------------------------------------------------------
	lock_exists		EXCEPTION;
	s_lock_exists	CONSTANT VARCHAR(1024) := '
Создание/изменение/удаление пользователя уже выполняется в другом сеансе.
Повторите попытку через 1 минуту.
В случае проблем обратитесь к Администратору Системы.
';
	
	mp_stec_user_id	stec_user.stec_user_id%TYPE := NULL;

	mp_lock_id   	INT				:= NULL;
	mp_db_lock_id 	VARCHAR2(128)	:= NULL;

	mp_schema		CONSTANT VARCHAR2(30)					:= fn_stec_schema;

	s_err_input CONSTANT VARCHAR2(1024) := 
'Неверные входные данные. Они должны удовлетворять следующим условиям:
Фамилия:    [А-Я][-а-яА-Я]{0,31} 			Пример: Салтыков-Щедринычаускас
Имя:        [-а-яА-Я]{1,32} 				Пример: Иосиф
Отчество:   [-а-яА-Я]{1,32} 				Пример: Станиславович
Пол:        (M|W)           				Пример: M (латинская)
Пароль:     [a-zA-Z][a-zA-Z0-9_$#]{9,29} 	Пример: AtSt2tdsRwe1#3a4 
';


  
  PROCEDURE pr_lock_release
	AS
		code      	NUMBER;
	BEGIN
		IF NOT mp_db_lock_id IS NULL THEN	    
		    code := DBMS_LOCK.RELEASE(mp_db_lock_id);
		    mp_db_lock_id :=NULL;
		END IF;

		mp_stec_user_id := NULL;
		
	    mp_lock_id := NULL;
	END;

  
	-- a local (fn_stec_schema) lock
	PROCEDURE pr_lock	
	AS			
		code	      	NUMBER;
	BEGIN
		IF (NOT mp_lock_id IS NULL) THEN
			RETURN;
		END IF;
		
		BEGIN
			pkg_stec_transact.pr_start('CALL pkg_stec_account.pr_lock_release()');
		EXCEPTION
			WHEN OTHERS THEN
				mp_lock_id := NULL;
				RAISE lock_exists;
		END;
		mp_lock_id := 1;
	END;

	-- a global database lock - is necessary to calculate unique login for the created user
	PROCEDURE pr_lock_db	
	AS			
		code	      	NUMBER;
	    lock_name		VARCHAR2(128) := 'pkg_stec_account';
	BEGIN
		IF NOT mp_db_lock_id IS NULL THEN
			RETURN;
		END IF;

		pr_lock();
		
		DBMS_LOCK.ALLOCATE_UNIQUE(lock_name, mp_db_lock_id); 
		code := DBMS_LOCK.REQUEST(mp_db_lock_id, DBMS_LOCK.X_MODE);

		IF 0 <> code THEN
	      BEGIN  pkg_stec_transact.pr_complete('N');
	      EXCEPTION WHEN OTHERS THEN NULL; END;
	      RAISE lock_exists;
		END IF;

	END;
	
------------pr_rus_surnamenp_2_eng_upper----------------------------------------
  PROCEDURE pr_rus_surnamenp_2_eng_upper(
      in_rus_surnamenp    IN  stec_user.surname%TYPE,
      out_eng_surnamenp   OUT stec_login.login%TYPE
      ) 
  AS
    ABC1 CONSTANT VARCHAR2(64) := 'ABVGDEEZIYKLMNOPRSTUF';
    ABV1 CONSTANT VARCHAR2(64) := 'АБВГДЕЁЗИЙКЛМНОПРСТУФ';
    ABC2 CONSTANT VARCHAR2(64) := 'ZH KH TS CH SH SHCH   Y   E  YU YA _ ';
    ABV2 CONSTANT VARCHAR2(64) := 'Ж  Х  Ц  Ч  Ш  Щ    Ъ Ы Ь Э  Ю  Я  - ';
    in_ru_surnamenp stec_user.surname%TYPE := REPLACE(REPLACE(UPPER(in_rus_surnamenp), 'ЬЁ', 'ЙО'), 'ЬЕ', 'ЙЕ');
    out_ch  VARCHAR2(4);
    pos     INT;
    j       INT := LENGTH(in_rus_surnamenp)-1;
    max_i   INT;
  BEGIN
    out_eng_surnamenp := NULL;
    SELECT MIN(x) INTO max_i FROM (SELECT LENGTH(in_ru_surnamenp)-2 x FROM DUAL UNION SELECT 24 x FROM DUAL);
    FOR i IN 1..max_i LOOP
      out_ch  := SUBSTRC(in_ru_surnamenp, i, 1);
      pos     := INSTRC(ABV1, out_ch, 1, 1);
      IF 0 = pos THEN
        out_ch := REGEXP_SUBSTR(ABC2, '[^[:space:]]*', INSTRC(ABV2, out_ch, 1, 1));
        IF(LENGTH(out_ch) + LENGTH(out_eng_surnamenp)) > 24 THEN EXIT; END IF;
        out_eng_surnamenp := out_eng_surnamenp || out_ch;
      ELSE
        IF(1 + LENGTH(out_eng_surnamenp)) > 24 THEN EXIT; END IF;
        out_eng_surnamenp := out_eng_surnamenp || SUBSTRC(ABC1, pos, 1);
      END IF;
    END LOOP;
    max_i := LENGTH(in_ru_surnamenp) + 1; 
    LOOP 
      out_ch  := SUBSTRC(in_ru_surnamenp, j, 1);
      pos     := INSTRC(ABV1, out_ch, 1, 1);
      IF 0 = pos THEN
        out_eng_surnamenp := out_eng_surnamenp || SUBSTRC(ABC2, INSTRC(ABV2, out_ch, 1, 1), 1);
      ELSE
        out_eng_surnamenp := out_eng_surnamenp || SUBSTRC(ABC1, pos, 1);
      END IF;
    j := j + 1; IF max_i = j THEN EXIT; END IF; END LOOP;
  END;

------------pr_set_next_login---------------------------------------------------

  PROCEDURE pr_set_next_login(
    in_out_login     IN OUT stec_login.login%TYPE
    )
  AS
    u_name VARCHAR2(64);
    no_dig VARCHAR2(64);
  BEGIN
      SELECT U_NAME INTO u_name FROM ( 
        SELECT USERNAME || 0 U_NAME FROM SYS.DBA_USERS 
        WHERE REGEXP_LIKE(USERNAME || 0, '^' || in_out_login || '[[:digit:]]+')
        ORDER BY TO_NUMBER(REGEXP_SUBSTR(USERNAME || 0, '[[:digit:]]+')) DESC
      ) WHERE ROWNUM <=1;

      no_dig    := REGEXP_SUBSTR(u_name, '[^[:digit:]]+');
      in_out_login := '' || ((TO_NUMBER(REGEXP_SUBSTR(u_name, '[[:digit:]]+'))/10) + 1);
      IF(LENGTH(no_dig) + LENGTH(in_out_login) > 30) THEN
        IF(LENGTH(no_dig) < 4) THEN 
          RAISE_APPLICATION_ERROR(-20210, 
'Не возможно создать аккаунт для данного пользователя. 
Обратитесь к Администратору Системы за помощью.
');      
        END IF;
        in_out_login := SUBSTRC(no_dig, 1, LENGTH(no_dig)-3) || SUBSTRC(no_dig, LENGTH(no_dig)-1, 2);
        pr_set_next_login(in_out_login);
      ELSE
        in_out_login := no_dig || in_out_login;
      END IF;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

-----------fn_is_correct--------------------------------------------------------
  FUNCTION fn_is_correct(
      in_surname    IN  stec_user.surname%TYPE,
      in_name       IN  stec_user.name%TYPE,
      in_patronymic IN  stec_user.patronymic%TYPE,
      in_gender     IN  stec_user.gender%TYPE
  ) RETURN BOOLEAN
  AS
  BEGIN
    RETURN
      REGEXP_LIKE(in_surname,     '^([А-ЯЁ][-а-яА-ЯёЁ]{0,31})$')  AND
      REGEXP_LIKE(in_name,        '^([-а-яА-ЯёЁ]{1,32})$')  AND
      REGEXP_LIKE(in_patronymic,  '^([-а-яА-ЯёЁ]{1,32})$')  AND
      REGEXP_LIKE(in_gender,      '^(M|W)$');  
  END;

  FUNCTION fn_is_correct(
      in_password   IN  stec_login.pw%TYPE
  ) RETURN BOOLEAN
  AS
  BEGIN
    RETURN
      REGEXP_LIKE(in_password,    '^([a-zA-Z][a-zA-Z0-9_$#]{9,29})$') OR in_password IS NULL;  
  END;

--------------------------------------------------------------------------------
-------------------------------PUBLIC_PART--------------------------------------
--------------------------------------------------------------------------------
------------  pr_create  -------------------------------------------------------
	PROCEDURE pr_create(
		in_stec_user_id			IN	stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id		IN	stec_user	.stec_accessor_id	%TYPE DEFAULT NULL,
		in_surname    			IN  stec_user	.surname			%TYPE,
		in_name       			IN  stec_user	.name				%TYPE,
		in_patronymic 			IN  stec_user	.patronymic			%TYPE,
		in_gender     			IN  stec_user	.gender				%TYPE,
		in_stec_user_cat_id		IN	stec_user	.stec_user_cat_id	%TYPE DEFAULT 0,
		in_pw		   			IN  stec_login	.pw					%TYPE DEFAULT NULL,
		in_blocked				IN	stec_login	.blocked			%TYPE DEFAULT 'Y'
	) AS  PRAGMA AUTONOMOUS_TRANSACTION;
		m_user_id   stec_user.stec_user_id%TYPE;
		u_name    VARCHAR2(64);
      
		m_out_login   stec_login.login%TYPE;
		m_pw		  stec_login.pw%TYPE;
		-- lock_name must NOT contain fn_stec_schema as CREATE USER command affects all the oracle database
		inval_input EXCEPTION;
	BEGIN
	    IF (NOT fn_is_correct(in_surname,
	                          in_name,
	                          in_patronymic,
	                          in_gender)      OR
	        NOT fn_is_correct(in_pw)
	      ) THEN
	      RAISE inval_input;
	    END IF;

	    pr_rus_surnamenp_2_eng_upper(in_surname || SUBSTRC(in_name, 1, 1) || SUBSTRC(in_patronymic, 1, 1), 
	    	m_out_login);
		pr_set_next_login(m_out_login);
	  
		INSERT 	INTO stec_user (stec_user_id,		surname,    name,		patronymic,     
								gender, 	stec_user_cat_id,		stec_accessor_id) 
				VALUES         (in_stec_user_id,	in_surname, in_name,	in_patronymic,  
								in_gender,	in_stec_user_cat_id,	in_stec_accessor_id);
		IF in_stec_user_id IS NULL THEN
			SELECT sq_stec_user_i.CURRVAL INTO m_user_id FROM DUAL;
		ELSE
			m_user_id := in_stec_user_id;	
		END IF;
		      
		IF in_pw IS NULL THEN
			m_pw := SYS.pkg_stec.fn_rand_pw();
			INSERT 	INTO stec_login     (stec_login_id, stec_user_id,	login, 			pw,		blocked)
					VALUES 	       		(NULL,          m_user_id,      m_out_login, 	m_pw,	in_blocked);
		ELSE
			m_pw := in_pw;
			IF NOT fn_is_correct(m_pw) THEN RAISE inval_input; END IF; 
			INSERT 	INTO stec_login     (stec_login_id, stec_user_id, 	login, 			blocked)
					VALUES         		(NULL,          m_user_id,      m_out_login,	in_blocked);
		END IF;
		SYS.pkg_stec.pr_user_create(m_out_login, m_pw);
		BEGIN
--			SYS.pkg_stec.pr_role_grant('GRANT '|| mp_schema || '_PUB TO ' || m_out_login);
			IF 'N' = in_blocked THEN
				SYS.pkg_stec.pr_role_grant('GRANT CREATE SESSION TO ' || m_out_login);
			END IF;
		EXCEPTION
			WHEN OTHERS THEN
				SYS.pkg_stec.pr_user_drop(m_out_login);
				RAISE;
		END;
		
		COMMIT;
	EXCEPTION
		WHEN inval_input THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20001, s_err_input);
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;

	PROCEDURE pr_create_transact(
		in_stec_user_id		IN	stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id	IN	stec_user	.stec_accessor_id	%TYPE,
		in_surname    		IN  stec_user	.surname			%TYPE,
		in_name       		IN  stec_user	.name				%TYPE,
		in_patronymic 		IN  stec_user	.patronymic			%TYPE,
		in_gender     		IN  stec_user	.gender				%TYPE,
		in_stec_user_cat_id	IN	stec_user	.stec_user_cat_id	%TYPE,
		in_pw		   		IN  stec_login	.pw					%TYPE,
		in_blocked			IN	stec_login	.blocked			%TYPE
	) AS  PRAGMA AUTONOMOUS_TRANSACTION;
		m_id		stec_user.stec_user_id%TYPE;
	    m_cmd_cmt	a_transaction.cmd_commit%TYPE;
	    m_cmd_rlb	a_transaction.cmd_rollback%TYPE;
	BEGIN
		pr_lock_db();
		IF in_stec_user_id IS NULL THEN
			IF mp_stec_user_id IS NULL THEN
				SELECT MAX(SU.stec_user_id) INTO mp_stec_user_id FROM stec_user SU;
				IF mp_stec_user_id IS NULL THEN
					mp_stec_user_id := 1;
				ELSE
					mp_stec_user_id := mp_stec_user_id + 1;
				END IF;
			ELSE
				mp_stec_user_id := mp_stec_user_id + 1;
			END IF;
			pr_set_startval_for_seq('sq_stec_user_i', mp_stec_user_id);
			m_id := mp_stec_user_id;
		ELSE
			m_id := in_stec_user_id;
		END IF;

		m_cmd_cmt := 
	     	'CALL pkg_stec_account.pr_create('
				|| fn_num(m_id) || ', ' || fn_num(in_stec_accessor_id) || ', '
				|| fn_str(in_surname) || ', '|| fn_str(in_name) || ', '	|| fn_str(in_patronymic) || ', '
				|| fn_str(in_gender) || ', '|| fn_num(in_stec_user_cat_id)|| ', '
				|| fn_str(in_pw) || ', ' || fn_str(in_blocked) || ')';
	    m_cmd_rlb := 
	    	'CALL pkg_stec_account.pr_drop('|| fn_num(m_id) || ')';
	    	
		pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;

------------  pr_change  -------------------------------------------------------
-- CALL pkg_stec_account.pr_change(2, 48930, 'Д', 'Евгений', 'Васильевич', 'M', 0, NULL, 'MY_super_PASS###', 'N', 'N')
-- CALL pkg_stec_account.pr_change(2, 48930, 'Д', 'Евгений', 'Васильевич', 'M', 0, NULL, '-1', 'N', 'N');
	PROCEDURE pr_change(
		in_stec_user_id_o 		IN  stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id_o	IN  stec_user	.stec_accessor_id	%TYPE,
		in_surname_n      		IN  stec_user	.surname			%TYPE,
		in_name_n         		IN  stec_user	.name				%TYPE,
		in_patronymic_n   		IN  stec_user	.patronymic			%TYPE,
		in_gender_n       		IN  stec_user	.gender				%TYPE,
		in_stec_user_cat_id_n	IN	stec_user	.stec_user_cat_id	%TYPE,
		in_pw_o			   		IN  stec_login	.pw					%TYPE,
		in_pw_n		     		IN  stec_login	.pw					%TYPE,
		in_blocked_o			IN	stec_login	.blocked			%TYPE,
		in_blocked_n			IN	stec_login	.blocked			%TYPE
    ) AS PRAGMA AUTONOMOUS_TRANSACTION;
		inval_input 	EXCEPTION;
		m_login   		stec_login	.login	%TYPE;
		m_pw			stec_login	.pw		%TYPE;
		m_old_pw  		stec_login	.pw		%TYPE;
		m_pw_changed	BOOLEAN;
		m_blk			CHAR(1) := (CASE WHEN in_pw_n = '-1' THEN 'Y' ELSE 'N' END);
	BEGIN
		IF (NOT fn_is_correct(	in_surname_n,
								in_name_n,
                          		in_patronymic_n,
                          		in_gender_n)                          		
		) THEN
			RAISE inval_input;
		END IF;

		SELECT L.login, L.pw INTO m_login, m_old_pw FROM stec_login L 
			WHERE L.stec_user_id = in_stec_user_id_o;
		IF in_blocked_o <> in_blocked_n THEN
			IF 'N' = in_blocked_n THEN
				SYS.pkg_stec.pr_role_grant('GRANT CREATE SESSION TO ' || m_login);
			ELSE
				SYS.pkg_stec.pr_role_grant('REVOKE CREATE SESSION FROM ' || m_login);
			END IF;
		END IF;
		BEGIN
			IF pkg_stecu.ineq(in_pw_o, in_pw_n) THEN
		    	-- set temporary random password and remember it (below) on server for further sending to user.
				m_pw := (CASE WHEN in_pw_n = '-1' THEN SYS.pkg_stec.fn_rand_pw ELSE in_pw_n END);
				-- ??? check hashes of real old pw and real new pw, if equal => not changed => generate exception
				-- ???;
				IF fn_is_correct(m_pw) THEN 
				    UPDATE stec_login L SET L.pw = (CASE WHEN in_pw_n = '-1' THEN m_pw ELSE NULL END)	
				    	WHERE 	L	.stec_user_id		= in_stec_user_id_o;
			        SYS.pkg_stec.pr_user_alter(m_login, m_pw);
				ELSE
					RAISE inval_input; 
				END IF;
			END IF;
				
			UPDATE stec_user SU 
				SET SU.surname     		= in_surname_n,
		    		SU.name        		= in_name_n,
		    		SU.patronymic  		= in_patronymic_n,
			    	SU.gender      		= in_gender_n,
			    	SU.stec_user_cat_id = in_stec_user_cat_id_n
				WHERE SU.stec_user_id 	= in_stec_user_id_o;
        
      		UPDATE stec_login SL
        		SET SL.blocked			= in_blocked_n
        		WHERE SL.stec_user_id	= in_stec_user_id_o;
		EXCEPTION
			WHEN OTHERS THEN
				IF in_blocked_o <> in_blocked_n THEN
					IF 'Y' = in_blocked_n THEN
						SYS.pkg_stec.pr_role_grant('GRANT CREATE SESSION TO ' || m_login);
					ELSE
						SYS.pkg_stec.pr_role_grant('REVOKE CREATE SESSION FROM ' || m_login);
					END IF;
				END IF;
				RAISE;
		END;
		COMMIT;
	EXCEPTION
    	WHEN inval_input THEN 
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20001, s_err_input); 
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;

	PROCEDURE pr_change_transact(
		in_stec_user_id_o 		IN  stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id_o	IN  stec_user	.stec_accessor_id	%TYPE,
		in_surname_o      		IN  stec_user	.surname			%TYPE,
		in_surname_n     		IN  stec_user	.surname			%TYPE,
		in_name_o         		IN  stec_user	.name				%TYPE,
		in_name_n         		IN  stec_user	.name				%TYPE,
		in_patronymic_o   		IN  stec_user	.patronymic			%TYPE,
		in_patronymic_n   		IN  stec_user	.patronymic			%TYPE,
		in_gender_o       		IN  stec_user	.gender				%TYPE,
		in_gender_n       		IN  stec_user	.gender				%TYPE,
		in_stec_user_cat_id_o	IN	stec_user	.stec_user_cat_id	%TYPE,
		in_stec_user_cat_id_n	IN	stec_user	.stec_user_cat_id	%TYPE,
		in_pw_o			   		IN  stec_login	.pw					%TYPE,
		in_pw_n		     		IN  stec_login	.pw					%TYPE,
		in_blocked_o			IN	stec_login	.blocked			%TYPE,
		in_blocked_n			IN	stec_login	.blocked			%TYPE
	) AS PRAGMA AUTONOMOUS_TRANSACTION;
		pw          stec_login.pw%TYPE;
		m_cmd_cmt  a_transaction.cmd_commit%TYPE;
		m_cmd_rlb  a_transaction.cmd_rollback%TYPE;
		m_blk		CHAR(1) := (CASE WHEN in_pw_n = '-1' THEN 'Y' ELSE 'N' END);
	BEGIN
		pr_lock();
	
		m_cmd_cmt := 
			'CALL pkg_stec_account.pr_change('
				|| fn_num(in_stec_user_id_o) || ', ' || fn_num(in_stec_accessor_id_o) || ', '
				|| fn_str(in_surname_n) || ', '|| fn_str(in_name_n) || ', ' || fn_str(in_patronymic_n) || ', '
				|| fn_str(in_gender_n) || ', '|| fn_num(in_stec_user_cat_id_n) || ', '
				|| fn_str(in_pw_o) 		|| ', '|| fn_str(in_pw_n) || ', '
				|| fn_str(in_blocked_o) 	|| ', '|| fn_str(in_blocked_n) || ')';
		
		m_cmd_rlb := 
			'CALL pkg_stec_account.pr_change('
				|| fn_num(in_stec_user_id_o) || ', ' || fn_num(in_stec_accessor_id_o) || ', '
				|| fn_str(in_surname_o) || ', '|| fn_str(in_name_o) || ', ' || fn_str(in_patronymic_o) || ', '
				|| fn_str(in_gender_o) || ', '|| fn_num(in_stec_user_cat_id_o) || ', '
				|| 'NULL, NULL, '
				|| fn_str(in_blocked_n) 	|| ', '|| fn_str(in_blocked_o) || ')';
		-- this is correct!: || 'NULL, NULL, '		
		-- cause we do not want to change  the pw on rollback		
		pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);

		IF pkg_stecu.ineq(in_pw_o, in_pw_n) THEN
		    UPDATE vw_division_access DA
		    	SET DA	.temp_login_block = m_blk
		    	WHERE	DA	.stec_accessor_id	= in_stec_accessor_id_o;
			UPDATE vw_stec_role_user SRU
		    	SET SRU	.temp_login_block = m_blk
		    	WHERE 	SRU	.stec_user_id		= in_stec_user_id_o;
		END IF;
		
		COMMIT;
  EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
  END;
  
------------  pr_drop  ---------------------------------------------------------
	PROCEDURE pr_drop(
		in_stec_user_id			IN stec_user	.stec_user_id		%TYPE
	) AS  PRAGMA AUTONOMOUS_TRANSACTION;
		u_name stec_login.login%TYPE;
	BEGIN
		SELECT L.login INTO u_name FROM stec_login L WHERE  L.stec_user_id = in_stec_user_id;
		DELETE FROM stec_login L   		WHERE L 	.stec_user_id = in_stec_user_id;
		DELETE FROM stec_user SU  		WHERE SU	.stec_user_id = in_stec_user_id;
		SYS.pkg_stec.pr_user_drop(u_name);
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE;
	END;

--	PROCEDURE pr_drop_transact(
--		in_U_o					IN  stec_user	%ROWTYPE,
--		in_L_o					IN  stec_login	%ROWTYPE
--	)
	PROCEDURE pr_drop_transact(
		in_stec_user_id_o  		IN stec_user	.stec_user_id		%TYPE,
		in_stec_accessor_id_o	IN stec_user	.stec_accessor_id	%TYPE,
		in_surname_o     		IN stec_user	.surname			%TYPE,
		in_name_o     			IN stec_user	.name				%TYPE,
		in_patronymic_o   		IN stec_user	.patronymic			%TYPE,
		in_gender_o     		IN stec_user	.gender				%TYPE,
		in_stec_user_cat_id_o	IN stec_user	.stec_user_cat_id	%TYPE,
		in_pw_o		     		IN stec_login	.pw					%TYPE,
		in_blocked_o			IN stec_login	.blocked			%TYPE
	) AS  PRAGMA AUTONOMOUS_TRANSACTION;
    	u_name stec_login.login%TYPE;
	    m_cmd_cmt  a_transaction.cmd_commit%TYPE;
	    m_cmd_rlb  a_transaction.cmd_rollback%TYPE;
	BEGIN
		pr_lock();
		
	    m_cmd_cmt :=
			'CALL pkg_stec_account.pr_drop('|| fn_num(in_stec_user_id_o) || ')';
		m_cmd_rlb :=
			'CALL pkg_stec_account.pr_create('
				|| fn_num(in_stec_user_id_o) || ', ' || fn_num(in_stec_accessor_id_o) || ', '
				|| fn_str(in_surname_o) || ', '|| fn_str(in_name_o) || ', '	|| fn_str(in_patronymic_o) || ', '
				|| fn_str(in_gender_o) || ', ' || fn_num(in_stec_user_cat_id_o) || ', '
				|| fn_str(in_pw_o) || fn_str(in_blocked_o) || ')';
		-- actually, we cannot put back old password if it has been changed by user, 
		-- so, in this case, we will get a user account with a new random password (not so bad though) 
				
		pkg_stec_transact.pr_add_operation(m_cmd_cmt, m_cmd_rlb);
		COMMIT;
	EXCEPTION
		WHEN lock_exists THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20002, s_lock_exists);
		WHEN OTHERS THEN
			ROLLBACK;
			pkg_stec_transact.pr_complete('N');
			RAISE;
	END;
  

	PROCEDURE pr_ora_role_create(in_role IN VARCHAR2)
	AS  PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		SYS.pkg_stec.pr_role_create(in_role);
	END;
  
	PROCEDURE pr_ora_role_drop(in_role IN VARCHAR2)
	AS  PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		SYS.pkg_stec.pr_role_drop(in_role);
	END;

	PROCEDURE pr_ora_grant(in_grant_expr IN VARCHAR2)
	AS  PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		SYS.pkg_stec.pr_role_grant(in_grant_expr);
	END;

END;
/

--------------------------------------------------------------------------------

