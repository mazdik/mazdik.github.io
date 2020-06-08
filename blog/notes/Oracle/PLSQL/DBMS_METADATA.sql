/* Get DDL */
declare
  table_name        varchar2(40) := 'ARX';
  owner             varchar2(40) := 'ALIOIS';
  new_owner         varchar2(40) := 'DDD';
  new_table_name    varchar2(40) := 'NEW_TABLE';
  v_handle          number;
  v_transhandle     number;
  v_ddl             clob;
begin
  v_handle := dbms_metadata.open('TABLE');

  dbms_metadata.set_filter(v_handle, 'SCHEMA', owner);
  dbms_metadata.set_filter(v_handle, 'NAME', table_name);

  v_transhandle := dbms_metadata.add_transform(v_handle, 'MODIFY');
  -- новое имя схемы     
  dbms_metadata.set_remap_param(v_transhandle,'REMAP_SCHEMA', owner, new_owner);
  -- новое имя таблицы                           
  dbms_metadata.set_remap_param(v_transhandle,'REMAP_NAME', table_name, new_table_name);

  v_transhandle := dbms_metadata.add_transform(v_handle, 'DDL');

  dbms_metadata.set_transform_param(v_transhandle, 'SEGMENT_ATTRIBUTES', false);

  v_ddl := dbms_metadata.fetch_clob(v_handle);
  dbms_metadata.close(v_handle);
  
  dbms_output.put_line(v_ddl);

end;

