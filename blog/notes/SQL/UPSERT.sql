-- UPSERT (update or insert into a table)

/* 
1. попытаться выполнить вставку, а при нарушении ограничения первичного ключа обработать исключительную ситуацию и изменить соответствующие данные.
DUP_VAL_ON_INDEX вызывается при попытке сохранить несколько одинаковых значений в колонку таблицы, когда на данную колонку установлен уникальный индекс.
*/

begin
   insert into t (mykey, mystuff) 
      values ('X', 123);
exception
   when dup_val_on_index then
      update t 
      set    mystuff = 123 
      where  mykey = 'X';
end;

-- 2. попытаться изменить данные, проверить значение sql%rowcount и если оно равно 0 - вставить соответствующие данные.

UPDATE tablename
    SET val1 = in_val1,
        val2 = in_val2
    WHERE val3 = in_val3;

IF ( sql%rowcount = 0 )
    THEN
    INSERT INTO tablename
        VALUES (in_val1, in_val2, in_val3);
END IF;


-- 3. merge

MERGE INTO Employee USING dual ON ( "id"=2097153 )
WHEN MATCHED THEN UPDATE SET "last"="smith" , "name"="john"
WHEN NOT MATCHED THEN INSERT ("id","last","name") 
    VALUES ( 2097153,"smith", "john" )
