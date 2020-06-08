alter profile ADMIN limit idle_time 90;
alter profile USERS limit idle_time 90;
alter profile DEFAULT limit idle_time 90;

--Когда TRUE изменения профиля вступают в действие
alter system set resource_limit = true scope = both;

--Создание профиля
CREATE PROFILE miser
 LIMIT
 connect_time 120
 failed_login_attempts 3
 idle_time 60;
--Удаление профиля
DROP PROFILE test CASCADE;
--Назначение профиля пользователю
ALTER USER salapati PROFILE test;

--------------------- Database Resource Manager (диспетчер ресурсов бд) ---------------------
DBMS_RESOURCE_MANAGER 
--Этот пакет позволяет создавать планы ресурсов для различных групп потребителей и присваивать планы группам

--Активизация Database Resource Manager
ALTER SYSTEM SET resource_manager_plan=MEMBERSHIP_PLAN;
--Отключение Database Resource Manager
ALTER SYSTEM SET resource_manager_plan='';

--все активные в текущий момент планы ресурсов
SELECT * FROM v$rsrc_plan;
--использования ресурсов группами потребителей
SELECT name,active_sessions,cpu_wait_time, consumed_cpu_time,
current_undo_consumption
FROM v$rsrc_consumer_group;
--все группы потре-бителей ресурсов, присвоенные пользователям или ролям
SELECT * FROM DBA_RSRC_CONSUMER_GROUP_PRIVS
--все планы ресурсов в бд
SELECT * FROM DBA_RSRC_PLANS

-- профили
SELECT * FROM dba_profiles WHERE resource_type = 'PASSWORD';
SELECT * FROM dba_profiles WHERE RESOURCE_NAME = 'PASSWORD_LIFE_TIME';
