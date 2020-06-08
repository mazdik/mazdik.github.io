------------------------ план запроса ------------------------
SELECT * v$sql WHERE sql_text LIKE 'SELECT /*+ ORDERED FIRST_ROWS*/ COUNTER_END%';
select * from v$sql where sql_id = '40mx31kd5kbdx';
select * from v$sql where sql_id = 'cgkdmcdpz88tj';
select operation, options, id, object_name, cost, cardinality, bytes, cpu_cost, io_cost  
from v$sql_plan where sql_id = '40mx31kd5kbdx'

------------------------ DBMS_XPLAN ------------------------
/* Скрипт планов для SQLPUS. Во 2ом запросе используем принудительно индекс */

spool c:/tmp/1.log
set termout off;
set echo on;
set pagesize 0;
set linesize 2000;
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;

explain plan for 
SELECT COUNTER_END FROM (SELECT /*+ ORDERED FIRST_ROWS*/ B.BEGIN_DATE, A.COUNTER_END 
FROM CHEQUE_LINE_F A, CHEQUE_F B 
WHERE A.DOC_ID = :B2 AND A.NOZZLE_ID = :B1 AND A.CHEQUE_ID = B.LINE_ID 
ORDER BY B.BEGIN_DATE DESC) Z WHERE ROWNUM = 1;

select * from table(dbms_xplan.display(null,null,'ALL'));

explain plan for 
SELECT COUNTER_END FROM (SELECT /*+ ORDERED FIRST_ROWS INDEX(A CHEQUE_LINE_F_NOZZLE_ID_FK)*/ 
B.BEGIN_DATE, A.COUNTER_END 
FROM CHEQUE_LINE_F A, CHEQUE_F B 
WHERE A.DOC_ID = :B2 AND A.NOZZLE_ID = :B1 AND A.CHEQUE_ID = B.LINE_ID 
ORDER BY B.BEGIN_DATE DESC) Z WHERE ROWNUM = 1;

select * from table(dbms_xplan.display(null,null,'ALL'));

spool off;

------------------------ PLAN_TABLE ------------------------
--создать таблицу плана
$ORACLE_HOME/rdbms/admin/utlxplan.sql
--Генерация вывода EXPLAIN PLAN
EXPLAIN PLAN
SET statement_id = 'test1'
INTO plan_table
FOR select i.quantity_on_hand FROM oe.inventories i;
--Получение вывода EXPLAIN PLAN
SELECT lpad(' ',level-1)||operation||' '||options||' '||
object_name "Plan"
FROM plan_table
CONNECT BY prior id = parent_id
AND prior statement_id = statement_id
START WITH id = 0 AND statement_id = 'test1'
ORDER BY id;

------------------------ DBMS_SQLTUNE ------------------------
DECLARE
  my_task_name varchar2(30);
  my_sqltext   clob;
  rep_tuning   clob;
BEGIN
  begin
    DBMS_SQLTUNE.DROP_TUNING_TASK('my_sql_tuning_task');
  exception
    when others then
      null;
  end;
  my_sqltext := '
SELECT /*+ ORDERED FIRST_ROWS*/
 counter_end
  FROM (SELECT /*+ ORDERED FIRST_ROWS*/
         B.counter_end
          FROM cheque_f A, cheque_line_f B
         WHERE A.doc_id = 507000000311248
           AND A.line_id = B.cheque_id
           AND B.nozzle_id = 507000000000162
         ORDER BY A.begin_date DESC)
 WHERE ROWNUM = 1';
  MY_TASK_NAME := DBMS_SQLTUNE.CREATE_TUNING_TASK(SQL_TEXT    => my_sqltext,
                                                  TIME_LIMIT  => 60, --задается время выполнения в секундах
                                                  TASK_NAME   => 'my_sql_tuning_task',
                                                  DESCRIPTION => my_task_name,
                                                  SCOPE       => DBMS_SQLTUNE.scope_comprehensive);
  begin
    DBMS_SQLTUNE.EXECUTE_TUNING_TASK('my_sql_tuning_task');
  exception
    when others then
      null;
  end;
END;

--Далее запуск запрос, который выдает на экран текст рекомендаций:
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK('my_sql_tuning_task') FROM DUAL;

------------------------ Примеры ------------------------
EXPLAIN PLAN SET statement_id 'newplan1'
 FOR
 SELECT o.order_id,
 o.order_total,
 c.account_mgr_id
 FROM customers c,
 orders o
 WHERE o.customer_id=c.customer_id
 AND o.order_date > '01-JUL-05';
--план
SELECT STATEMENT
 HASH JOIN   								/* шаг 4 */
	TABLE ACCESS FULL CUSTOMERS   			/* шаг 2 */
	TABLE ACCESS BY INDEX ROWID ORDERS  	/* шаг 3 */
		INDEX RANGE SCAN ORD_ORDER_DATE_IX  /* шаг 1 */
/*
На шаге 1 будет выполняться сканирование диапазона по индексу для таблицы orders с использованием индекса ORD_ORDER_DATE_IX
На шаге 2 к таблице customers будет получаться доступ через операцию полного сканирования таблицы, 
потому что столбец account_manager_id в этой таблице, который являются частью конструкции WHERE, не проиндексирован.
На шаге 3 будет осуществляться доступ к таблице orders через операцию INDEX ROWID с использованием того значения ROWID, которое было получено на предыдущем шаге. 
В результате из этой таблицы будут возвращаться значения столбцов order_id, customer_id и order_total, соответствующие указанной дате.
На шаге 4 строки, полученные из таблицы ordersна шаге 3, будут соединяться со строками, полученными из таблицы customers на шаге 2, 
на основании соблюдения условия WHERE o.customer_id=c.customer_id.
*/
 