-- Состояние логов
select group#, bytes, status from v$log;

    GROUP#      BYTES STATUS
---------- ---------- ----------------
         1   52428800 ACTIVE
         2   52428800 ACTIVE
         3   52428800 CURRENT
		 
-- Файлы redo логов.
select group#, member from v$logfile;

    GROUP# MEMBER
---------- ----------------------------------------
         3 I:\MTSZN\REDO03.LOG
         2 I:\MTSZN\REDO02.LOG
         1 I:\MTSZN\REDO01.LOG
		 
-- Создадим новую группу логов по 100M
alter database add logfile group 4 'I:\MTSZN\REDO04.LOG' size 100M;
alter database add logfile group 5 'I:\MTSZN\REDO05.LOG' size 100M;
alter database add logfile group 6 'I:\MTSZN\REDO06.LOG' size 100M;


-- Чтобы активным был лог из вновь созданных групп.
alter system switch logfile;

-- Удаляем лишние логи
alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;


ERROR at line 1:
ORA-01624: log 3 needed for crash recovery of instance oradb (thread 1)
ORA-00312: online log 3 thread 1: 'I:\MTSZN\REDO03.LOG'
-- При удалении последнего лога как раз случилась ситуация, когда удалить лог невозможно, 
-- т.к. данные из него ещё не сброшены в файлы данных. Сделать это принудительно можно командой
alter system checkpoint;
-- После чего смело повторяем попытку.
alter database drop logfile group 3;

-- Теперь можно удалить лишние файлы операционной системы.
D:\> del I:\MTSZN\REDO01.LOG
D:\> del I:\MTSZN\REDO02.LOG
D:\> del I:\MTSZN\REDO03.LOG  

-- для добавления в существующую группу
ALTER DATABASE ADD LOGFILE MEMBER 'I:\MTSZN\REDO07.LOG' TO GROUP 4;

-- удаление члена группы
ALTER DATABASE DROP LOGFILE MEMBER 'I:\MTSZN\REDO07.LOG';

-- переименование
ALTER DATABASE RENAME FILE 'C:\MTSZN\REDO1.LOG' TO 'I:\MTSZN\REDO1.LOG';

