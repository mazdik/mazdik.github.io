-- Проверка пригодности таблицы
begin
SYS.DBMS_REDEFINITION.CAN_REDEF_TABLE('LIDER', 'CHEQUE_LINE_PAYMENT');
end;

-- Создание временной таблицы c CTAS
CREATE TABLE CHEQUE_LINE_PAYMENT2 AS SELECT * FROM CHEQUE_LINE_PAYMENT;  

-- Запуск процесса онлайнового переопределения
begin
SYS.DBMS_REDEFINITION.START_REDEF_TABLE('LIDER', 'CHEQUE_LINE_PAYMENT', 'CHEQUE_LINE_PAYMENT2');  
end;

--С помощью следующего запроса убедитесь, что промежуточная и главная таблицы имеют одинаковое количество строк:
SELECT COUNT(*) FROM CHEQUE_LINE_PAYMENT;
SELECT COUNT(*) FROM CHEQUE_LINE_PAYMENT2;

-- Копирование зависимых объектов
DECLARE
  l_num_errors PLS_INTEGER;
begin
  DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS(
    uname             => 'LIDER',
    orig_table        => 'CHEQUE_LINE_PAYMENT',
    int_table         => 'CHEQUE_LINE_PAYMENT2',
    copy_indexes      => DBMS_REDEFINITION.CONS_ORIG_PARAMS, -- Non-Default
    copy_triggers     => TRUE,  -- Default
    copy_constraints  => TRUE,  -- Default
    copy_privileges   => TRUE,  -- Default
    ignore_errors     => TRUE,  -- Default-FALSE
    num_errors        => l_num_errors); 
  DBMS_OUTPUT.put_line('l_num_errors=' || l_num_errors);
end;

-- Проверка ошибок
select object_name, base_table_name, ddl_txt from DBA_REDEFINITION_ERRORS;

-- Синхронизация промежуточной и исходной таблиц
begin
SYS.DBMS_REDEFINITION.SYNC_INTERIM_TABLE('LIDER', 'CHEQUE_LINE_PAYMENT', 'CHEQUE_LINE_PAYMENT2');  
end;

/* После этой команды FINISH_REDEF_TABLE появляются невалидные объекты */
-- Завершение процесса переопределения
begin
SYS.DBMS_REDEFINITION.FINISH_REDEF_TABLE('LIDER', 'CHEQUE_LINE_PAYMENT', 'CHEQUE_LINE_PAYMENT2');  
end;

-- временную таблицу можно уничтожить
DROP TABLE CHEQUE_LINE_PAYMENT2 PURGE;


-- Recompile
begin
dbms_utility.compile_schema('LIDER',FALSE);
dbms_utility.compile_schema('PUBLIC',FALSE);
end;

-- Если вы увидите какие-либо существенные ошибки во время описанного процесса, переопределение легко прервать
DBMS_REDEFINITION.ABORT_REDEF_TABLE;
