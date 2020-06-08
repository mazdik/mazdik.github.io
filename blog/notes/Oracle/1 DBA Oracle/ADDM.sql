/*
Автоматический монитор диагностики базы данных (Automatic Database Diagnostic Monitor — ADDM)

В основе этой функциональности лежит новое средство сбора статистики — Automatic Workload Repository 
(AWR — автоматический репозиторий рабочей нагрузки), 
который автоматически собирает и сохраняет важнейшую статистику производительности. AWR сохраняет свои данные в табличном пространстве Sysaux.

Всякий раз, когда AWR делает снимок (по умолчанию ежечасно), процесс MMON указывает ADDM проанализировать интервал между последними двумя снимками AWR. 
Таким образом, по умолчанию ADDM запускается автоматически после получения каждого снимка AWR.
*/

--накопленную временную статистику о различных операциях во всей бд и показывает количество миллисекунд, потраченных бд на определенные операции.
SELECT stat_name, value FROM V$SYS_TIME_MODEL;
SELECT stat_name, value FROM V$SESS_TIME_MODEL;

--Включение ADDM (по умолчанию включен)
STATISTICS_LEVEL=ALL
--или STATISTICS_LEVEL=TYPICAL
CONTROL_MANAGEMENT_PACK_ACCESS=DIAGNOSTIC+TUNING
--Отключается ADDM установкой этого параметра следующим образом:
CONTROL_MANAGEMENT_PACK_ACCESS=NONE

--В следующем примере показано, как выполнить анализ ADDM для базы данных за период между снимками 99 и 120:
BEGIN
DBMS_ADDM.ANALYZE_DB('ADDM_for_8_AM_to_10_AM', 99,120);
END;
--DBMS_ADDM.ANALYZE_DB - в режиме базы данных
--DBMS_ADDM.ANALYZE_INST - в режиме экземпляра
--DBMS_ADDM.ANALYZE_PARTIAL - в частичном режиме

--Отображение отчета ADDM
SELECT DBMS_ADDM.GET_REPORT('ADDM_for_8_AM_to_10_AM') FROM DUAL;

--создать снимок вручную
dbms_workload_repository.create_snapshot();

--получить текстовый отчет с помощью DBMS_ADVISOR
SELECT DBMS_ADVISOR.GET_TASK_REPORT(
task_name, 'TEXT', 'ALL')
FROM dba_advisor_tasks
WHERE task_id=(
SELECT max(t.task_id)
FROM dba_advisor_tasks t, dba_advisor_log l
WHERE t.task_id = l.task_id
AND t.advisor_name='ADDM'
AND l.status= 'COMPLETED');

--Представление DBA_ADVISOR_RECOMMENDATIONS покажет все рекомендации в базе данных.
SELECT * FROM DBA_ADVISOR_RECOMMENDATIONS;
--Представление DBA_ADVISOR_FINDINGS покажет все обнаружения всех советников в базе данных.
SELECT * FROM DBA_ADVISOR_FINDINGS;
--Представление DBA_ADVISOR_RATIONALE покажет обоснования всех рекомендаций.
SELECT * FROM DBA_ADVISOR_RATIONALE;
--Представление DBA_ADVISOR_ACTIONS покажет все действия, которые необходи-мы для реализации рекомендаций ADDM.
SELECT * FROM DBA_ADVISOR_ACTIONS;

--Создание отчетов
$ORACLE_HOME/rdbms/admin/addmrpt.sql
