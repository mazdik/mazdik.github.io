--Детальный контроль доступа (fine-grained access control — FGAC)
--DBMS_RLS(RLS — row-level security(безопасность на уровне строк))

-- функция генерирует предикаты динамического доступа к таблице
FUNCTION empnum_sec (A1 VARCHAR2, A2 VARCHAR2)
RETURN varchar2
IS
d_predicate varchar2 (2000);
BEGIN
d_predicate:= 'employee_id =
SYS_CONTEXT("EMPLOYEE_INFO","EMP_NUM")';
RETURN d_predicate;
END empnum_sec;
--создать политику безопасности 
BEGIN
dbms_rls.add_policy
(object_schema  => 'hr',
object_name  => 'employees',
policy_name  => 'manager_policy',
function_schema  => 'hr',
policy_function => 'empnum_sec',
statement_types => 'select');
END;
--проверить успешность создания новой политики
SELECT object_name, policy_name, sel, ins, upd, del, enable FROM all_policies;
