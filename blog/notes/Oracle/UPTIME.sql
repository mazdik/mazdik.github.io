-- 1 - Query v_$instance to get the uptime
SELECT host_name, 
       instance_name,
       TO_CHAR(startup_time, 'DD-MM-YYYY HH24:MI:SS') startup_time,
       FLOOR(sysdate-startup_time) days
FROM   sys.v_$instance;

-- 2 - Query v$session to get database uptime
SELECT TO_CHAR(logon_time, 'DD-MM-YYYY HH24:MI:SS')
FROM v$session 
WHERE program LIKE '%PMON%'