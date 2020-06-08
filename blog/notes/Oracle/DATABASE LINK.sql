select * from dba_db_links;

create database link testlink_db1 connect to system identified by sys
using
	'(DESCRIPTION=
	(ADDRESS=
	(PROTOCOL=TCP)
	(HOST=192.168.2.127)
	(PORT=1521))
	(CONNECT_DATA=
	(SID=MURGB)))';
	
create database link testlink_db2 connect to system identified by sys using '192.168.2.127:1521/MURGB';

select * from v$version@testlink_db1;

drop database link testlink_db1;

-- drop all db_links
begin
  for cur in (select * from dba_db_links) loop
    execute immediate 'drop database link '||cur.DB_LINK;
    end loop;
end;
