--	
--	DECLARE
--		str VARCHAR2(256) := 
--			'GRANT SELECT ON ' || fn_stec_schema || '.something ' || 
--			'TO '|| fn_stec_schema ||'_def';
--	BEGIN
--		pkg_stec_account.pr_role_create(fn_stec_schema || '_def');
--		-- THE NEXT commands are optional
--		pkg_stec_account.pr_role_grant(	REGEXP_REPLACE(str, '.something', '.faculty'));
--		pkg_stec_account.pr_role_grant(	REGEXP_REPLACE(str, '.something', '.speciality'));
--		pkg_stec_account.pr_role_grant(	REGEXP_REPLACE(str, '.something', '.stec_group'));
--		pkg_stec_account.pr_role_grant(	REGEXP_REPLACE(str, '.something', '.stec_user_cat'));
--		pkg_stec_account.pr_role_grant(	REGEXP_REPLACE(str, '.something', '.vw_stec_user'));
--		pkg_stec_account.pr_role_grant(	REGEXP_REPLACE(str, '.something', '.vw_stec_stud'));
--		pkg_stec_account.pr_role_grant(	REGEXP_REPLACE(str, '.something', '.temp_privs'));
--		pkg_stec_account.pr_role_grant(	REGEXP_REPLACE(str, '.something', '.vw_all_tab_columns'));
--		pkg_stec_account.pr_role_grant(
--			REGEXP_REPLACE(
--				REGEXP_REPLACE(str, 'SELECT', 'EXECUTE'),
--	      	'.something', '.pr_temp_privs_collect'    ) );
--	END;
--	/

-----------------------------------------------------------------------------