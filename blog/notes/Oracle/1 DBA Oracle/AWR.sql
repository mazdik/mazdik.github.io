--Автоматический репозиторий рабочей нагрузки (Automatic Workload Repository — AWR)

--создать снимок вручную
BEGIN
DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT();
END;

--удалить все снимки, идентификаторы которых попадают в диапазон от 40 до 60
BEGIN
DBMS_WORKLOAD_REPOSITORY.DROP_SNAPSHOT_RANGE(
low_snap_id => 40,
high_snap_id => 60, 
dbid => 2210828132);
END;

--Настройки
BEGIN
DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(
RETENTION => 43200,
INTERVAL => 30,
DBID => 3310949047);
END;

/*
AWR по умолчанию запускается каждый час, и статистика AWR сохраняется по умолчанию в течение 8 дней.
RETENTION - по умолчанию 8 дней
INTERVAL - по умолчанию 60 минут
В случае установки интервала снимков в ноль AWR прекратит собирать данные снимков. 
Разумеется, это пагубно скажется на работе ADDM, SQL Tunung Advisor, Undo Advisor и Segment Advisor, поскольку все они зависят от данных AWR.
*/

--Создание отчетов AWR
$ORACLE_HOME/rdbms/admin/awrrpt.sql
DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEST 
DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML

--Представление DBA_HIST_SNAPSHOT показывает все снимки, сохраненные в AWR.
SELECT * FROM DBA_HIST_SNAPSHOT;
--Представление DBA_HIST_WR_CONTROL показывает все управляющие настройки AWR.
SELECT * FROM DBA_HIST_WR_CONTROL;
--Представление DBA_HOST_BASELINE показывает базовые линии с их идентификаторами начального и конечного снимков.
SELECT * FROM DBA_HOST_BASELINE;
