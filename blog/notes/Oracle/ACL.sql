Установка прав доступа ACL для Oracle 11g
-- создание списка доступа к установке соединения (на этом этапе сразу добавляется первый пользователь USER1)
EXECUTE DBMS_NETWORK_ACL_ADMIN.CREATE_ACL('acl_for_sendmail.xml', 'ACL for sending mail', 'USER1', TRUE, 'connect');
-- задается адрес сервера и порт, куда идет подключение (localhost:465)
EXECUTE DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL('acl_for_sendmail.xml', 'smtp.mail.ru', 25);
EXECUTE DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL('acl_for_sendmail.xml', '*', 25);
commit;
 
-- добавление еще одного пользователя (USER2) в созданный список
EXECUTE DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE('acl_for_sendmail.xml', 'USER2', TRUE, 'connect');
commit;
 
-- проверка, что только что созданный список появился в БД
SELECT host, lower_port, upper_port, acl FROM dba_network_acls
-- просмотр списка пользователей, добавленных в список
select acl, principal, privilege, is_grant, invert from dba_network_acl_privileges
 
-- удалить весь список можно следующей командой
EXECUTE DBMS_NETWORK_ACL_ADMIN.DROP_ACL('acl_for_sendmail.xml');
commit;

---------
begin
DBMS_NETWORK_ACL_ADMIN.CREATE_ACL('acl_for_sendmail.xml', 'ACL for sending mail', 'LIDER', TRUE, 'connect');
DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL('acl_for_sendmail.xml', '*', 25);
end;

/* ACL to allow access to the LDAP serve */
BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
    acl          => 'ldap_acl_file.xml', 
    description  => 'ACL to grant access to LDAP server',
    principal    => 'APEX_050100',
    is_grant     => TRUE, 
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl         => 'ldap_acl_file.xml',
    host        => 'nis.local', 
    lower_port  => 389,
    upper_port  => NULL);
-- добавление еще одного пользователя в созданный список
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE (
    acl          => 'ldap_acl_file.xml', 
    principal    => 'ERA_MER',
    is_grant     => TRUE, 
    privilege    => 'connect');
  COMMIT;
END;
