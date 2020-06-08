--Список constraint'ов, ссылающихся на таблицу
SELECT * FROM DBA_CONSTRAINTS DC
WHERE DC.CONSTRAINT_TYPE = 'R'
AND DC.R_CONSTRAINT_NAME IN
    (SELECT DC1.CONSTRAINT_NAME
     FROM DBA_CONSTRAINTS DC1
     WHERE DC1.CONSTRAINT_TYPE IN ('P','U')
     AND UPPER(DC1.TABLE_NAME) = UPPER('KAZS_CHEQUE_PARAMS'));
/*
CONSTRAINT_TYPE (from 11gR2 docs)
C - Check constraint on a table
P - Primary key
U - Unique key
R - Referential integrity
V - With check option, on a view
O - With read only, on a view
H - Hash expression
F - Constraint that involves a REF column
S - Supplemental logging
*/

--Какие объекты базы данных зависят от Foo_t?
SELECT name, type
FROM all_dependencies
WHERE owner = USER
AND referenced_name='FOO_T';

/*
Ограничения целостности 5 типов:
1. ограничения первичного ключа;
2. ограничения NOT NULL;
3. проверочные ограничения;
4. ограничения уникальности;
5. ссылочные ограничения целостности

Отключаются ограничения двумя способами: 
DISABLE VALIDATE(отключить с проверкой)
DISABLE NO VALIDATE (отключить без проверки)
ENABLE VALIDATE
ENABLE NO VALIDATE

Немедленные ограничения
NOT DEFFERABLE(не откладывая) - по умолчанию
Отложенные ограничения
DEFERRABLE INITIALLY DEFERRED
DEFERRABLE INITIALLY IMMEDIATE 
*/

--Выключенные FK
select * from dba_constraints t where t.status='DISABLED' and t.constraint_type='R' and t.owner='LIDER'
