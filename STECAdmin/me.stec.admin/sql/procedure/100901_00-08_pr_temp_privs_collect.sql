-- drop procedure pr_temp_privs_collect;
CREATE OR REPLACE PROCEDURE pr_temp_privs_collect AS
BEGIN
  SYS.pkg_stec_temp_privs.pr_collect();
END;
/
----------------------------------------------------------

