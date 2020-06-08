--ORA-01652: unable to extend temp segment by 128 in tablespace TEMP

SELECT file_name, bytes, status, autoextensible FROM dba_temp_files
--autoextensible=NO 
alter database tempfile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\KAZS\TEMP01.DBF' autoextend on next 10M maxsize 1G;
alter database tempfile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\KAZS\TEMP01.DBF' resize 1G;

--Listing of temp segments
SELECT A.tablespace_name tablespace, D.mb_total,
SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free
FROM v$sort_segment A,
(
SELECT B.name, C.block_size, SUM (C.bytes) / 1024 / 1024 mb_total
FROM v$tablespace B, v$tempfile C
WHERE B.ts#= C.ts#
GROUP BY B.name, C.block_size
) D
WHERE A.tablespace_name = D.name
GROUP by A.tablespace_name, D.mb_total;


--Temp segment usage per session
SELECT S.sid || ',' || S.serial# sid_serial, S.username, S.osuser, P.spid, S.module,
P.program, SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
COUNT(*) statements
FROM v$sort_usage T, v$session S, dba_tablespaces TBS, v$process P
WHERE T.session_addr = S.saddr
AND S.paddr = P.addr
AND T.tablespace = TBS.tablespace_name
GROUP BY S.sid, S.serial#, S.username, S.osuser, P.spid, S.module,
P.program, TBS.block_size, T.tablespace
ORDER BY sid_serial;