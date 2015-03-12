-- truncate table stec_user_cat;
-- select * from stec_user_cat;
DECLARE 
  m_cnt INT := 0;
BEGIN
  SELECT COUNT(*) INTO m_cnt FROM stec_user_cat SUC WHERE SUC.constant IN ('UCAT_STUDENT','UCAT_ADMIN','UCAT_EMPLOEE');
  IF m_cnt < 1 THEN
    pr_set_startval_for_seq('sq_stec_user_cat_i', 0);
    INSERT INTO stec_user_cat(stec_user_cat_id, constant, name) VALUES(0, 'UCAT_STUDENT',       'Студент');
    INSERT INTO stec_user_cat(stec_user_cat_id, constant, name) VALUES(1, 'UCAT_ADMIN',         'Администратор');
    INSERT INTO stec_user_cat(stec_user_cat_id, constant, name) VALUES(2, 'UCAT_EMPLOEE',       'Работник');
    pr_set_startval_for_seq('sq_stec_user_cat_i', 3);
    COMMIT;
  END IF;
END;
/

--------------------------------------------------------------------------
