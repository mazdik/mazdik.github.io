begin
  for cur in (select username from dba_users where username not in ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP')) loop
    dbms_utility.compile_schema(cur.username, FALSE);
  end loop;
end;