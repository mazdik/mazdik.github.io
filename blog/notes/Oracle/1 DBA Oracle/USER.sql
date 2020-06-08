create user atajsal  identified by atajsal default tablespace PARUS_MAIN temporary tablespace PARUS_TEMP profile DEFAULT;
grant create session to atajsal;
/*
Открытая(open)
Заблокированная(locked)
Утратившая силу(expired)
*/
SELECT * FROM dba_users;

--разблокировать
ALTER USER hr ACCOUNT UNLOCK;

--срок действия пароля 30 дней
ALTER PROFILE test_profile LIMIT PASSWORD_LIFE_TIME 30;
ALTER USER hr PROFILE test_profile;

--Чувствительность пароля к регистру символов в Oracle 11g
SEC_CASE_SENSITIVE_LOGON --по умолчанию значение true

--Файл паролей
REMOTE_LOGIN_PASSWORDFILE --по умолчанию exclusive
/*
NONE. Никакой файл паролей не используется, и база данных разрешает только пользователям, подлинность которых установлена операционной системой
EXCLUSIVE. Только одна база данных может использовать файл паролей
SHARED. В системе создан файл паролей, который может использоваться несколькими базами данных
*/
--при EXCLUSIVE Oracle будет автоматически добавлять пользователей в файл паролей при предоставлении им полномочий SYSDBA и SYSOPER. 
--кому выданы права SYSDBA и SYSOPER
SELECT * FROM v$pwfile_users;

--Каскадное удаление пользователя (удаляются все его объекты)
DROP USER sidney CASCADE; 

--USER DDL
select dbms_metadata.get_ddl('USER', u.username) AS ddl
from   dba_users u
where  u.username = &v_username
union all
select dbms_metadata.get_granted_ddl('TABLESPACE_QUOTA', tq.username) AS ddl
from   dba_ts_quotas tq
where  tq.username = &v_username
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('ROLE_GRANT', rp.grantee) AS ddl
from   dba_role_privs rp
where  rp.grantee = &v_username
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('SYSTEM_GRANT', sp.grantee) AS ddl
from   dba_sys_privs sp
where  sp.grantee = &v_username
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('OBJECT_GRANT', tp.grantee) AS ddl
from   dba_tab_privs tp
where  tp.grantee = &v_username
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('DEFAULT_ROLE', rp.grantee) AS ddl
from   dba_role_privs rp
where  rp.grantee = &v_username
and    rp.default_role = 'YES'
and    rownum = 1
union all
select to_clob('/* Start profile creation script in case they are missing') AS ddl
from   dba_users u
where  u.username = &v_username
and    u.profile <> 'DEFAULT'
and    rownum = 1
union all
select dbms_metadata.get_ddl('PROFILE', u.profile) AS ddl
from   dba_users u
where  u.username = &v_username
and    u.profile <> 'DEFAULT'
union all
select to_clob('End profile creation script */') AS ddl
from   dba_users u
where  u.username = &v_username
and    u.profile <> 'DEFAULT'
and    rownum = 1
