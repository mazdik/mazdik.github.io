--Oracle REST Data Services (ORDS)
@C:\apex\apex_rest_config.sql
java -jar ords.war install
java -jar ords.war standalone --port 8086 --apex-images C:\apex\images
java -jar ords.war standalone --port 8086 --doc-root C:\www >>log.txt 2>&1

--Обновление ORDS
mkdir -p /u01/ords/conf
--копировать ords/params/ords_params.properties
java -jar ords.war configdir C:\Oracle\ords\config
java -jar ords.war

--The database user for the connection pool named apex_rt, is not authorized to proxy to the schema named TEST
alter user TEST grant connect through APEX_REST_PUBLIC_USER;

/* ORDS примеры */
--Включить rest для схемы
BEGIN
  ORDS.enable_schema(
    p_enabled             => TRUE,
    p_schema              => 'ERA_MER',
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'era_mer',
    p_auto_rest_auth      => FALSE
  );
  COMMIT;
END;
--Включить REST для таблицы
BEGIN
ORDS.ENABLE_OBJECT(p_enabled => TRUE,
				   p_schema => 'CDS',
				   p_object => 'ADDON_COMPONENTS',
				   p_object_type => 'TABLE',
				   p_object_alias => 'addon_components',
				   p_auto_rest_auth => FALSE);
commit;
END;
/* Удаление REST для схемы */
begin
  ORDS.ENABLE_SCHEMA(p_enabled => false);
  ORDS.DROP_REST_FOR_SCHEMA();
  commit;
end;
/* Включение REST для схемы */
begin
  ORDS.ENABLE_SCHEMA(p_enabled => true);
  commit;
end;

--Добавить пользователя ORDS
java -jar ords.war user test_developer "SQL Developer"
--Примеры ORDS
?q={"ENAME":"JONES"}
?q={"ENAME":{"$ne":"SMITH"}}
?q={"$orderby":{"SALARY":"ASC","ENAME":"DESC"}}
?q={"ENAME":"JONES","$orderby":{"EMPNO":"DESC","ENAME":"ASC"}}
?q={"ENAME":{"$eq":"SMITH"},"$orderby":{"EMPNO":"DESC","ENAME":"ASC"}}

--
SELECT id, name, uri_prefix FROM user_ords_modules ORDER BY name;
/
SELECT id, module_id, uri_template FROM user_ords_templates ORDER BY module_id;
/
SELECT id, template_id, source_type, method, source FROM user_ords_handlers ORDER BY id;
/
--Display Enabled Objects
SELECT parsing_schema,
       parsing_object,
       object_alias,
       type,
       status
FROM   user_ords_enabled_objects
ORDER BY 1, 2;

--Узнать версию ORDS
select ords.installed_version from dual

--Простой пример
BEGIN
  ORDS.define_service(
    p_module_name    => 'module1',
    p_base_path      => 'module1/',
    p_pattern        => 'job_state/',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_query,
    p_source         => 'SELECT * FROM JOB_STATE',
    p_items_per_page => 0);
  COMMIT;
END;
--Удалить модуль
BEGIN
ORDS.delete_module('module1');
  COMMIT;
END;

--
BEGIN
  ORDS.define_module(
    p_module_name    => 'module1',
    p_base_path      => 'module1/',
    p_items_per_page => 0);
    
  ORDS.define_template(
   p_module_name    => 'module1',
   p_pattern        => 'metadata/:table');

  ORDS.define_handler(
    p_module_name    => 'module1',
    p_pattern        => 'metadata/:table',
    p_method         => 'GET',
    p_source_type    => ORDS.source_type_plsql,
    p_source         => 'BEGIN PKG_REST.GET_METADATA_JSON(:table); END;',
    p_items_per_page => 0);
    
  COMMIT;
END;

/* ORDS on Tomcat
CATALINA_HOME = C:\apache-tomcat
JAVA_HOME = C:\Program Files\Java\jdk1.8.0_40
%CATALINA_HOME%\bin\startup.bat

How to change Tomcat default port - server.xml

How to disable the Tomcat Access log:
In server.xml сomment 
<!-- <Valve className="org.apache.catalina.valves.AccessLogValve"...

$ mkdir $CATALINA_HOME/webapps/i/
$ cp -R /tmp/apex/images/* $CATALINA_HOME/webapps/i/
$ cp /u01/ords/ords.war $CATALINA_HOME/webapps/
*/
