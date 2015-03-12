CREATE OR REPLACE VIEW vw_all_tab_columns AS
SELECT
TABLE_NAME, 
COLUMN_NAME, 
DATA_TYPE,
(CASE WHEN 0 = CHAR_LENGTH THEN DATA_LENGTH ELSE CHAR_LENGTH END) char_length, 
NULLABLE 
FROM ALL_TAB_COLUMNS 
WHERE OWNER = fn_stec_schema;
-- select * from vw_all_tab_columns;
--------------------------------------------------------------------------------
