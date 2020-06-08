create table table_1(id integer);

begin
 begin
  insert into table_1 values(1);
  savepoint SP1;
  commit;
  insert into table_1 values(2);
  savepoint SP2;
  insert into table_1 values(3);
  savepoint SP3;
  rollback to SP2;
  insert into table_1 values(4);
  savepoint SP4;
  rollback to SP1;  --ORA-01086: savepoint 'SP1' never established in this session or is invalid
 exception 
  when others then
   null;
   rollback to SP4;
 end;
end;

select id from table_1;

/*
В текущей сессии будет 1, 2, 4
Для всех результат: 1
*/