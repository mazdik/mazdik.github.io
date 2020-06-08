--тбс
CREATE TABLESPACE RMAN_TBS DATAFILE 'D:\app\oradata\apex\rman_tbs01.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

--Создание схемы каталога восстановления
CREATE USER RMAN IDENTIFIED BY rman
  TEMPORARY TABLESPACE temp
  DEFAULT TABLESPACE RMAN_TBS
  QUOTA UNLIMITED ON RMAN_TBS

--Выдача необходимых привилегий
GRANT RECOVERY_CATALOG_OWNER TO rman;

--Подключение к RMAN
rman catalog rman/rman@apex target rman/rman@apex 

--Создание каталога восстановления
RMAN> CREATE CATALOG;

--Регистрация базы данных
RMAN> REGISTER DATABASE;

--Ресинхронизация каталога
RMAN> RESYNC CATALOG;

--Удаление каталога
RMAN> DROP CATALOG;

--номер версии схемы ка-талога восстановления
SQL> SELECT * FROM rcver;
