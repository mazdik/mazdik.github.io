--Management Advisory Framework
/*
Советники:
Memory Advisor(Советник памяти)
MTTR Advisor(Советник MTTR)
SQL Tuning Advisor(Советник по настройке SQL)
SQL Access Advisor(Советник по доступу SQL)
Segment Advisor(Советник по сегментам)
Undo Advisor(Советник по отмене)
*/

--Создание задачи
DBMS_ADVISOR.CREATE_TASK('SQL Access Advisor', :task_id, :task_name);
--Установка параметров задачи
DBMS_ADVISOR.SET_TASK_PARAMETER('TEST_TASK', 'VALID_TABLE_LIST', 'SH.SALES, SH.CUSTOMERS');
--Генерация рекомендаций
DBMS_ADVISOR.EXECUTE_TASK('TEST_TASK');
--Просмотр рекомендаций
SELECT rec_id, rank, benefit FROM DBA_ADVISOR_RECOMMENDATIONS WHERE task_name = 'TEST_TASK';

--DBA_ADVISOR_TASKS. Это представление показывает информацию обо всех задачах в базе данных.
SELECT * FROM DBA_ADVISOR_TASKS;
--DBA_ADVISOR_PARAMETERS. Это представление показывает имена и значения всех параметров всех задач советников в базе данных.
SELECT * FROM DBA_ADVISOR_PARAMETERS;
--DBA_ADVISOR_FINDINGS. Это представление показывает обнаружения, найденные каждым советником, включая уровень их влияния.
SELECT * FROM DBA_ADVISOR_FINDINGS;
--DBA_ADVISOR_RECOMENDATIONS. Это представление содержит анализ всех рекомендаций в базе данных.
SELECT * FROM DBA_ADVISOR_RECOMENDATIONS;
--DBA_ADVISOR_ACTIONS. Это представление показывает необходимые действия, ассоциированные с каждой рекомендацией советника.
SELECT * FROM DBA_ADVISOR_ACTIONS;
--DBA_ADVISOR_RATIONALE. Это представление показывает обоснования для всех рекомендаций советника.
SELECT * FROM DBA_ADVISOR_RATIONALE;
