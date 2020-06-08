@echo off

if (%1)==() goto INFO
if NOT (%2)==(F) if NOT (%2)==(I) if NOT (%2)==(A) goto INFO
set ORACLE_SID=%1%
set BCK_MODE=%2%

rem Режим бекапа
if %BCK_MODE%==F goto BACKUP_F
if %BCK_MODE%==I goto BACKUP_I
if %BCK_MODE%==A goto ARCH

rem Подсовываем скрипты рману в зависимости от режима
:BACKUP_F
set CMDFILE=D:\backup\scripts\backup_full.sql
set LOGFILE=d:\backup\backup_full.log
goto EXEC

:BACKUP_I
set CMDFILE=D:\backup\scripts\backup_full_i.sql
set LOGFILE=d:\backup\backup_full_i.log
goto EXEC

:ARCH
set CMDFILE=D:\backup\scripts\backup_arch.sql
set LOGFILE=d:\backup\backup_arch.log
goto EXEC

:EXEC
rem Запуск рерзервного копирования с проверкой успешности
rman target SYS/master nocatalog cmdfile=%CMDFILE% msglog=%LOGFILE%
if ERRORLEVEL 0 echo Successful backup >> %LOGFILE%
rem Копируем в сетевую папку если нужно
goto END

:INFO
echo Введите ORACLE_SID, Backup mode
echo Backup Mode: F=Full, I=Incremental, A=Archivelogs
goto END

:END
@echo on

