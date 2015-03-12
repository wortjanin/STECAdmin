-- TRUNCATE TABLE stec_accessor_type;
-- SELECT * FROM stec_accessor_type;
DECLARE
  m_cnt INT :=0;
BEGIN
  SELECT COUNT(*) INTO m_cnt FROM stec_accessor_type SAT WHERE SAT.constant IN ('SAT_USER', 'SAT_ROLE');
  IF m_cnt < 1 THEN
    INSERT INTO stec_accessor_type(constant, name) VALUES('SAT_USER',	'Пользователь');
    INSERT INTO stec_accessor_type(constant, name) VALUES('SAT_ROLE',	'Роль');
    COMMIT;
  END IF;
END;
/

--------------------------------------------------------------------------
