--Существуют 2 основных типа полномочий Oracle: системные и объектные

--Системные
GRANT CREATE SESSION TO hr;
REVOKE DELETE ANY TABLE FROM pasowner;

--Объектные
GRANT DELETE ON bonuses TO hr;
--на уровне столбца
GRANT UPDATE (product_id) ON sales01 TO salapati;
REVOKE UPDATE ON ods_process FROM tester;

--Роли
CREATE ROLE new_dba;
CREATE ROLE clerk IDENTIFIED BY password;
GRANT CONNECT TO new_dba;
GRANT new_dba TO salapati;
DROP ROLE new_dba;

/*
DBA_USERS Предоставляет информацию о пользователях.
DBA_ROLES Отображает все роли в базе данных.
DBA_COL_PRIVS Отображает полномочия, предоставленные на уровне столбцов.
DBA_ROLE_PRIVS Отображает пользователей и их роли.
DBA_SYS_PRIVS Отображает пользователей, которым предоставлены системные полномочия.
DBA_TAB_PRIVS Отображает пользователей и их полномочия в таблицах.
ROLE_ROLE_PRIVS Отображает роли, предоставленные ролям.
ROLE_SYS_PRIVS Отображает системные роли, предоставленные ролям.
ROLE_TAB_PRIVS Отображает табличные полномочия, предоставленные ролям.
SESSION_PRIVS Отображает полномочия, которые в данный момент включены для текущего сеанса.
SESSION_ROLES Отображает роли, которые в данный момент включены для текуще-го сеанса.
*/

grant execute on P_R_MOVE_DATA to WELLOP;
