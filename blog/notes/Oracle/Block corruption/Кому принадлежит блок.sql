--Кому принадлежит этот блок
SELECT owner, segment_name, segment_type
FROM dba_extents
WHERE file_id = 7
AND 31391 BETWEEN block_id AND block_id + blocks - 1;

--Кому принадлежит по object_id (ORA-08102: index key not found, obj# 65228, file 5, block 20832)
select substr(object_name,1,30), object_type
from user_objects
where object_id = 65226

--В каком файле
select * from dba_data_files where file_id = 5
