/*
Выполнение внешних задач из БД Oracle 10

Для Windows:
1. Служба OracleJobScheduler%ORACLE_SID% должна быть запущена.
2. Служба должна быть запущена с учетной записью (В свойствах службы -> вход в систему -> пользователь-пароль)

*/

GRANT CREATE JOB TO LIDER;
GRANT CREATE EXTERNAL JOB TO LIDER;


-- cmd с параметрами
begin
 dbms_scheduler.create_job('myjob',
   job_action=>'C:\WINDOWS\SYSTEM32\CMD.EXE',
   number_of_arguments=>3,
   job_type=>'executable', 
   enabled=>false,
   auto_drop => false
   );
 dbms_scheduler.set_job_argument_value('myjob',1,'/q');
 dbms_scheduler.set_job_argument_value('myjob',2,'/c');
 dbms_scheduler.set_job_argument_value('myjob',3,'D:\TEST.BAT');
 dbms_scheduler.enable('myjob');
 end;
 
--или без параметров
begin
 dbms_scheduler.create_job('myjob',
   job_action=>'D:\test.bat > null',
   job_type=>'executable', 
   enabled=>false,
   auto_drop => false
   );
end;

--запустить задачу
begin
DBMS_SCHEDULER.RUN_JOB('myjob');
end;