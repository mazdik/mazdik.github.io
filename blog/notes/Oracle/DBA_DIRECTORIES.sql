SELECT * FROM DBA_DIRECTORIES;

SELECT grantor, grantee, table_schema, table_name, privilege
FROM all_tab_privs
WHERE table_name = 'DMPDIR';

DROP DIRECTORY DMPDIR;


CREATE OR REPLACE DIRECTORY RMAN_LOB_DIR AS 'C:\FRA\RMAN';

GRANT READ, WRITE ON DIRECTORY RMAN_LOB_DIR TO sys;
GRANT READ, WRITE ON DIRECTORY RMAN_LOB_DIR TO system;