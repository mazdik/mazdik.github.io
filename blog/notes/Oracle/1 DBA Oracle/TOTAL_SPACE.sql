SELECT DISTINCT a.tablespace_name,
            sum(a.bytes)/1024/1024 CurMb,
            sum(decode(b.maxextend, null, a.bytes/1024/1024, b.maxextend*(SELECT value FROM v$parameter WHERE name='db_block_size')/1024/1024)) MaxMb,
            round(100*(sum(a.bytes)/1024/1024 - round(c.free/1024/1024))/(sum(decode(b.maxextend, null, a.bytes/1024/1024, b.maxextend*(SELECT value FROM v$parameter WHERE name='db_block_size')/1024/1024)))) UPercent,
            (sum(a.bytes)/1024/1024 - round(c.free/1024/1024)) TotalUsed,
            round((sum(decode(b.maxextend, null, a.bytes/1024/1024, b.maxextend*(SELECT value FROM v$parameter WHERE name='db_block_size')/1024/1024)) - (sum(a.bytes)/1024/1024 - round(c.Free/1024/1024))),2) TotalFree 
FROM dba_data_files a,
   sys.filext$ b,
   (SELECT d.tablespace_name , sum(nvl(c.bytes,0)) free
     FROM dba_tablespaces d,dba_free_space c
     WHERE d.tablespace_name = c.tablespace_name(+) 
     GROUP BY d.tablespace_name) c
WHERE a.file_id = b.file#(+)
    AND a.tablespace_name = c.tablespace_name  
GROUP BY a.tablespace_name,
       c.free/1024