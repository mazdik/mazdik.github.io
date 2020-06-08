--Выборка всех синонимов схемы PARUS
select * from all_synonyms a where a.table_owner = 'PARUS'
--по имени
select * from all_synonyms a where a.SYNONYM_NAME = UPPER('PCK_ADM')
--права
SELECT * FROM sys.dba_tab_privs t WHERE t.table_name = UPPER('PCK_ADM')

--создать синонимы всем
declare
begin
for cur in (select object_name from all_objects where owner = 'PARUS') loop
 begin
  execute immediate 'create public synonym '||trim(cur.object_name)||' for '||trim(cur.object_name);
  execute immediate 'grant execute on '||trim(cur.object_name)||' to public';
 exception when OTHERS then
  null;
 end;
end loop;
end;

-- Все невалидные синонимы
select *
  from all_synonyms s
  join all_objects o
    on s.owner = o.owner
   and s.synonym_name = o.object_name
 where o.object_type = 'SYNONYM'
   --and s.owner = user
   and o.status <> 'VALID'


--права public
SELECT * FROM sys.dba_tab_privs WHERE grantee='PUBLIC' and owner='LIDER'

-- Создание синонима
create or replace public synonym P_R_TEST for P_R_TEST;
grant select on P_R_TEST to public;
grant execute on P_R_TEST to public;

-- Gen synonyms
DECLARE
  v_output CLOB := NULL;
BEGIN
  FOR tt IN (SELECT t.owner, t.synonym_name
               FROM dba_synonyms t
              WHERE t.table_owner = 'DB601'
                and t.owner = 'WELLOP601') LOOP
    SELECT DBMS_METADATA.get_ddl('SYNONYM', tt.synonym_name, tt.owner)
      INTO v_output
      FROM DUAL;
    DBMS_OUTPUT.put_line(v_output|| ';');
  END LOOP;
END;

--Удалить все синонимы пользователя
begin
  for cur in (select *
                from dba_synonyms t
               where t.table_owner = 'DB601'
                 and t.owner = 'WELLOP601') loop
    begin
      execute immediate 'drop synonym ' || cur.owner || '.' || cur.synonym_name;
    exception
      when others then
        dbms_output.put_line(rtrim(cur.synonym_name) || ':' || sqlerrm);
    end;
  end loop;
end;

--На какие синонимы ссылаются -- Referenced by
select * from dba_dependencies
where referenced_name = 'FOND' and owner = 'WELLOP601' and referenced_type = 'SYNONYM'
