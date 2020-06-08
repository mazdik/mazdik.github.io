/* 
DBMS_SPACE - анализ требования роста сегмента и пространства

пакет DBMS_SPACE включает в себя три основных процедуры: 
UNUSED_SPACE даст информацию о неиспользованном пространстве в сегменте объекта, 
FREE_BLOCKS информацию о количестве свободных блоков в сегменте, 
SPACE_USAGE подробности об использованном пространстве в блоках.
*/

/*
Рекомендации Auto Segment Advisor с командами для выполнения.
Например выводит:
Perform shrink, estimated savings is 102759445 bytes.
alter index "STEVE"."ORDERS_NEW_INDEX" shrink space
*/
select tablespace_name, segment_name, segment_type, partition_name,
recommendations, c1 from
table(dbms_space.asa_recommendations('FALSE', 'FALSE', 'FALSE'));