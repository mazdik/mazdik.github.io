--корзина
SELECT * FROM DBA_RECYCLEBIN;
--SQL*Plus
SHOW RECYCLEBIN;
--Oracle 10.2 параметр инициализации RECYCLEBIN для отключения функции Flashback Drop

--Восстановление удаленной таблицы
FLASHBACK TABLE persons TO BEFORE DROP;
FLASHBACK TABLE "BIN$xTMPjHZ6SG+1xnDIaR9E+g==$0" TO BEFORE DROP RENAME TO NEW_PERSONS;

--удалить из корзины все объекты, которые являются частью табличного пространства:
PURGE TABLESPACE users;
--удалить из корзины, которые принадлежат запустившему их пользователю
PURGE RECYCLEBIN;
--удалить все из корзины под SYSDBA
PURGE DBA_RECYCLEBIN;
/*
И, наконец, не следует забывать о том, что Oracle может автоматически удалять объекты из корзины в случае нехватки пространства.
*/

--очистка корзины
begin
  for cur in (
    select decode(partition_name, null,
               segment_name,
               segment_name || ':' || partition_name) objectname,
           segment_type object_type,
           owner,
           tablespace_name,
           header_block
    from   dba_segments
    where  tablespace_name = 'AUDIT_KERNEL' and
           segment_name like 'BIN$%'
       ) loop
       execute immediate 'purge table '|| cur.owner ||'."'|| cur.objectname||'"';
       end loop;
  
end;
