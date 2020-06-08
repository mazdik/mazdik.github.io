STARTUP NOMOUNT;
CREATE CONTROLFILE REUSE DATABASE "FRS" RESETLOGS  NOARCHIVELOG
--CREATE CONTROLFILE SET DATABASE "FRS" RESETLOGS  NOARCHIVELOG
--CREATE CONTROLFILE SET DATABASE "FRS" NORESETLOGS  NOARCHIVELOG
    MAXLOGFILES 5
    MAXLOGMEMBERS 3
    MAXDATAFILES 254
    MAXINSTANCES 1
    MAXLOGHISTORY 584
LOGFILE
  GROUP 1 'I:\FRS\REDO01.LOG'  SIZE 50M,
  GROUP 2 'I:\FRS\REDO02.LOG'  SIZE 50M,
  GROUP 3 'I:\FRS\REDO03.LOG'  SIZE 50M
DATAFILE
  'I:\FRS\SYSTEM.DAT',
  'I:\FRS\PARUS_UNDO.DAT',
  'I:\FRS\SYSAUX.DAT',
  'I:\FRS\PARUS_INDEX.DAT',
  'I:\FRS\PARUS_LOB.DAT',
  'I:\FRS\PARUS_MAIN.DAT'
CHARACTER SET CL8MSWIN1251;
RECOVER DATABASE
ALTER DATABASE OPEN RESETLOGS;
--ALTER DATABASE OPEN NORESETLOGS;
ALTER TABLESPACE "PARUS_TEMP" ADD TEMPFILE 'I:\FRS\PARUS_TEMP.DAT' SIZE 50M REUSE AUTOEXTEND ON NEXT 5120K MAXSIZE UNLIMITED;
