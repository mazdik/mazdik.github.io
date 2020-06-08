set serveroutput on;
/*
Очень опасно! Можно испортить всю базу вместе бэкапами.
Вначале нужно получить старый dbid
select name, dbid from v$database;
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
@DBID.sql
ALTER DATABASE OPEN RESETLOGS;
*/
declare
v_chgdbid   binary_integer;
v_chgdbname binary_integer;
v_skipped   binary_integer;
old_name 	varchar2(20)	:='KAZS';
old_dbid 	number			:=1173654296;
new_name 	varchar2(20)	:='KAZS';
new_dbid 	number			:=1229065292;
begin
  dbms_backup_restore.nidbegin(new_name,old_name,new_dbid,old_dbid,0,0,10);
  dbms_backup_restore.nidprocesscf(
       v_chgdbid,v_chgdbname);
  dbms_output.put_line('ControlFile: ');
  dbms_output.put_line('  => Change Name:'
       ||to_char(v_chgdbname));
  dbms_output.put_line('  => Change DBID:'
       ||to_char(v_chgdbid));
  for i in (select file#,name from v$datafile)
     loop
     dbms_backup_restore.nidprocessdf(i.file#,0,
       v_skipped,v_chgdbid,v_chgdbname);
     dbms_output.put_line('DataFile: '||i.name);
     dbms_output.put_line('  => Skipped:'
       ||to_char(v_skipped));
     dbms_output.put_line('  => Change Name:'
       ||to_char(v_chgdbname));
     dbms_output.put_line('  => Change DBID:'
       ||to_char(v_chgdbid));
     end loop;
  for i in (select file#,name from v$tempfile)
     loop
     dbms_backup_restore.nidprocessdf(i.file#,1,
       v_skipped,v_chgdbid,v_chgdbname);
     dbms_output.put_line('DataFile: '||i.name);
     dbms_output.put_line('  => Skipped:'
       ||to_char(v_skipped));
     dbms_output.put_line('  => Change Name:'
       ||to_char(v_chgdbname));
     dbms_output.put_line('  => Change DBID:'
       ||to_char(v_chgdbid));
     end loop;
  dbms_backup_restore.nidend;
end;
/
