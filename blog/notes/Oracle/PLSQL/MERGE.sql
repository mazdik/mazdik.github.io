----MERGE---
--Позволяет вставлять или изменять строки
--делает проверку, если не сущ. запись то insert, если сущ. то update

MERGE INTO имя_таблицы псевдоним_таблицы
USING (табл|представление|подзапрос) псевдоним
ON (условие_соелинения)
WHEN MATCHED THEN 
UPDATE SET
столбец1 = значение,
столбец2 = значение
WHEN NOT MATCHED THEN 
INSERT (список_столбцов)
VALUES (список_столбцов);


-------- The MERGE statement merges data between two tables. Using DUAL allows us to use this command.

MERGE INTO Employee USING dual ON ( "id"=2097153 )
WHEN MATCHED THEN UPDATE SET "last"="smith" , "name"="john"
WHEN NOT MATCHED THEN INSERT ("id","last","name") 
    VALUES ( 2097153,"smith", "john" )