ALTER DATABASE BACKUP CONTROLFILE TO TRACE as 'D:\ctlbackup';

/*
ORA-00227: в управляющем файле обнаружен поврежденный блок: (блок 3, число блоков 1)
ORA-00202: управляющий файл: 'D:\ORADATA\ORCL\CONTROL03.CTL'

Решил так:
SHUTDOWN IMMEDIATE;
удалил CONTROL03.CTL, скопировал CONTROL02.CTL и переименовал в CONTROL03.CTL
STARTUP;
*/

/* Как отключить управляющий файл */

alter system set control_files
= 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\CONTROL01.CTL'
, 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\CONTROL02.CTL'
scope=spfile;

--shutdown database
--startup database

/* Как добавить еще файлы (скопировал и переименовал один из существующих) */

alter system set control_files
= 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\CONTROL01.CTL'
, 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\CONTROL02.CTL'
, 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\CONTROL03.CTL'
scope=spfile;

--shutdown database
--startup database


select * from v$controlfile;
