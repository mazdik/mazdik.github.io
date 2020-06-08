/*
Базовые компоненты Scheduler
Scheduler состоит из 5 базовых компонентов — заданий (jobs), расписаний (schedules), программ (programs), событий (events) и цепочек (chains).

Типы запланированных заданий:
Задания базы данных (JOB_TYPE => PLSQL_BLOCK или STORED_PROCEDURE)
Задания-цепочки (JOB_TYPE => CHAIN)
Внешние задания (JOB_TYPE => EXECUTABLE)
Отсоединенные задания (DETACHED => TRUE)
Легковесные задания (LIGHTWEIGHT)

Расширенные компоненты Scheduler:
Классы заданий (DBMS_SCHEDULER.CREATE_JOB_CLASS)
Окна (DBMS_SCHEDULER.CREATE_WINDOW)
Группы окон (DBMS_SCHEDULER.CREATE_WINDOW_GROUP)
*/
select * from DBA_SCHEDULER_JOBS t where t.JOB_NAME='GATHER_STATS_JOB';
select * from DBA_SCHEDULER_RUNNING_JOBS;
select * from DBA_SCHEDULER_SCHEDULES;
select * from DBA_SCHEDULER_JOB_RUN_DETAILS t where t.JOB_NAME='GATHER_STATS_JOB';
select * from DBA_SCHEDULER_JOB_LOG t where t.JOB_NAME='GATHER_STATS_JOB' order by t.LOG_DATE desc

--Автоматизированные задачи обслуживания в oracle 11g
SELECT * FROM DBA_AUTOTASK_JOB_HISTORY ORDER BY WINDOW_START_TIME DESC 
SELECT * FROM DBA_AUTOTASK_CLIENT_HISTORY ORDER BY WINDOW_START_TIME DESC 

SELECT a.job_name,
       a.enabled,
       c.window_name,
       c.schedule_name,
       c.start_date,
       c.repeat_interval
  FROM dba_scheduler_jobs             a,
       dba_scheduler_wingroup_members b,
       dba_scheduler_windows          c
 WHERE job_name = 'GATHER_STATS_JOB'
   AND a.schedule_name = b.window_group_name
   AND b.window_name = c.window_name;

--Включить
DBMS_SCHEDULER.ENABLE('TEST_JOB1');
--Отключить
DBMS_SCHEDULER.DISABLE('TEST_JOB1');
--Удалить
DBMS_SCHEDULER.DROP_JOB( JOB_NAME => 'TEST_JOB1');
--Запустить вручную
DBMS_SCHEDULER.RUN_JOB('TEST_JOB1');
--Остановить задание
DBMS_SCHEDULER.STOP_JOB('TEST_JOB1');
--Установка атрибутов. 
--Изменить приоритет. Значение приоритета задания по умолчанию равно 3.
DBMS_SCHEDULER.SET_ATTRIBUTE(
NAME   => 'TEST_JOB1',
ATTRIBUTE  => 'JOB_PRIORITY',
VALUE  => 1);
--Очистка атрибута
DBMS_SCHEDULER.SET_ATTRIBUTE_NULL('TEST_JOB1', 'COMMENTS');
-- Очистка журналов задания.
DBMS_SCHEDULER.PURGE_LOG(JOB_NAME => 'TEST_JOB1');
-- Очистка журналов всех заданий
DBMS_SCHEDULER.PURGE_LOG;

/*
Автоматизированные задачи обслуживания в oracle 11g
Automatic Optimizer Statistics Collection (Автоматический сбор статистики оптимизатора);
Automatic Segment Advisor (Автоматический советник по сегментам);
Automatic SQL Tuning Advisor (Автоматический советник по настройке SQL).
*/
SELECT client_name, status FROM DBA_AUTOTASK_OPERATION;
SELECT client_name, status, attributes, window_group,service_name FROM DBA_AUTOTASK_CLIENT;

/*
MAINTENANCE_WINDOW_GROUP в oracle 11g новые окна:
MONDAY_WINDOW— начинается в 10 вечера в понедельник и заканчивается в 2 ночи;
TUESDAY_WINDOW— начинается в 10 вечера во вторник и заканчивается в 2 ночи;
WEDNESDAY_WINDOW— начинается в 10 вечера в среду и заканчивается в 2 ночи;
THURSDAY_WINDOW— начинается в 10 вечера в четверг и заканчивается в 2 ночи;
FRIDAY_WINDOW— начинается в 10 вечера в пятницу и заканчивается в 2 ночи;
SATURDAY_WINDOW— начинается в 6 утра в субботу и заканчивается в 2 ночи;
SUNDAY_WINDOW— начинается в 6 утра в воскресенье и заканчивается в 2 ночи.
*/

--Сформировать тестовое расписание
DECLARE
   l_start_date    TIMESTAMP;
   l_next_date     TIMESTAMP;
   l_return_date   TIMESTAMP; 
BEGIN
   l_start_date := TRUNC (SYSTIMESTAMP);
   l_return_date := l_start_date;
   FOR ctr IN 1 .. 10
   LOOP
      dbms_scheduler.evaluate_calendar_string
                       ('FREQ=MONTHLY;INTERVAL=2',
                        l_start_date,
                        l_return_date,
                        l_next_date);
      DBMS_OUTPUT.put_line ('Next Run on: ' || TO_CHAR (l_next_date, 'mm/dd/yyyy hh24:mi:ss'));
      l_return_date := l_next_date;
   END LOOP;
END;

-- job_queue_processes
select * from v$parameter t where t.NAME='job_queue_processes'
alter system set job_queue_processes=10 scope=both;

/* JOB */
--Run on the last day of every month.
FREQ=MONTHLY; BYMONTHDAY=-1;
--Run on the 29th day of every month:
FREQ=MONTHLY; BYMONTHDAY=29;

