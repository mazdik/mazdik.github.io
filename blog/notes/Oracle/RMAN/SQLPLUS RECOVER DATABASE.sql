--1. Немедленно остановите базу данных:
SHUTDOWN ABORT;
--2. Восстановите все файлы данных и удостоверьтесь в том, что все они находятся в оперативном режиме.
--3. Выберите одну из следующих команд RECOVER для выполнения процедуры восстановления, в зависимости от ситуации:

--Восстановление до отмены. 
--Применять архивные журналы повторного выполнения до тех пор, пока процесс восстановления не будет отменен.
RECOVER DATABASE UNTIL CANCEL;

--Восстановление до определенного момента времени в прошлом. 
RECOVER DATABASE UNTIL TIME '2005-06-30:12:00:00';
RECOVER DATABASE UNTIL TIME '2005-06-30:12:00:00' USING BACKUP CONTROLFILE;

--Восстановление до определенного изменения. 
RECOVER DATABASE UNTIL CHANGE 27845;

--4. Поскольку неполное восстановление:
ALTER DATABASE OPEN RESETLOGS;

--recover - команда sqlplus (интерфейс к alter database recover) alter database - чистый SQL

--Пробное восстановление (trial recovery) RECOVER ... TEST
RECOVER DATABASE UNTIL CANCEL TEST;
RECOVER TABLESPACE users TEST;

--допускает обнаружение одного поврежденного блока данных без прерывания процесса восстановления:
RECOVER DATABASE ALLOW 1 CORRUPTION;