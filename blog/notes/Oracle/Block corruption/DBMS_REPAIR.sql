-- Создание таблицы для восстановления
BEGIN
DBMS_REPAIR.ADMIN_TABLES (
     TABLE_NAME => 'REPAIR_TABLE',
     TABLE_TYPE => dbms_repair.repair_table,
     ACTION     => dbms_repair.create_action,
     TABLESPACE => 'PARUS_MAIN');
END;
/

-- Поиск разрушенных объектов
-- выведет количество number corrupt: 1
declare
rpr_count int;
begin
rpr_count := 0;
dbms_repair.check_object (
schema_name => 'PARUS',
object_name => 'PUBTURNS',
repair_table_name => 'REPAIR_TABLE',
corrupt_count => rpr_count);
dbms_output.put_line('repair count: ' || to_char(rpr_count));
end;
/

-- просмотреть таблицу для восстановления
select object_name, block_id, corrupt_type, marked_corrupt,
corrupt_description, repair_description
from repair_table;

/

-- Исправление повреждений
-- выведет количество num fix: 1
DECLARE num_fix INT;
BEGIN 
num_fix := 0;
DBMS_REPAIR.FIX_CORRUPT_BLOCKS (
     SCHEMA_NAME => 'PARUS',
     OBJECT_NAME=> 'PUBTURNS',
     OBJECT_TYPE => dbms_repair.table_object,
     REPAIR_TABLE_NAME => 'REPAIR_TABLE',
     FIX_COUNT=> num_fix);
DBMS_OUTPUT.PUT_LINE('num fix: ' || TO_CHAR(num_fix));
END;
/


-- пропускать поврежденные блоки
BEGIN
DBMS_REPAIR.SKIP_CORRUPT_BLOCKS (
     SCHEMA_NAME => 'PARUS',
     OBJECT_NAME => 'PUBTURNS',
     OBJECT_TYPE => dbms_repair.table_object,
     FLAGS => dbms_repair.skip_flag);
END;
/

-- просмотреть пропущенные поврежденные блоки
SELECT OWNER, TABLE_NAME, SKIP_CORRUPT FROM DBA_TABLES
    WHERE OWNER = 'PARUS'
	AND SKIP_CORRUPT='ENABLED';