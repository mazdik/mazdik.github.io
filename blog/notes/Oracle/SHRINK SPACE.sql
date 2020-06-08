/* 
Почему поиск в таблице с небольшим количеством строк может отнять довольно много времени?
Если в таблице когда-то было большое количество строк, поиск может замедлиться, потому что Oracle должен просмотреть каждый блок, 
в котором когда-либо содержались данные – вплоть до маркера максимального заполнения таблицы (High Water Mark – HWM).
Способы ускорить таблицу:
1. drop and recreate (exp/imp)
2. truncate (exp the data, truncate it, imp the data)
3. alter TABLE move + rebuild indexes
4. SHRINK SPACE появилась в 10G
5. DBMS_REDEFINITION
ALTER TABLE имя_таблицы SHRINK SPACE [COMPACT] [CASCADE];
Задание этой команды без опций приводит к дефрагментации таблицы и уплотнению ее строк. 
Затем HWM корректируется к новой высокой позиции и освобождает высвободившееся пространство.
Опция COMPACT проводит дефрагментацию, но не корректирует HWM.
Опция CASCADE сжимает не только названную таблицу, но и любые зависимые объекты, например, индексы.
Поскольку перемещенные строки будут иметь новый ROWID, 
Вы должны отключить любые триггеры, которые срабатывают на основании ROWID, или они будут выполнены повторно.
Имеются также и другие ограничения: проконсультируйтесь в документации.
*/

--узнать размер таблицы до
select round(bytes /1024/1024, 2) mb
from   dba_segments
WHERE segment_name = upper('zrepl_msg_i');

alter table zrepl_msg_i enable row movement;
ALTER TABLE zrepl_msg_i SHRINK SPACE;
alter table zrepl_msg_i disable row movement;

--узнать размер таблицы после
select round(bytes /1024/1024, 2) mb
from   dba_segments
WHERE segment_name = upper('zrepl_msg_i');
