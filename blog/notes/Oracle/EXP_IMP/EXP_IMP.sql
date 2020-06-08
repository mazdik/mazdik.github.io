/* Экспорт с запросом */
exp USERID=username/pass@SID TABLES=LIDER.event QUERY=\"WHERE date_start >=sysdate-1 and note like '%Oracle%'\" INDEXES=NO GRANTS=NO CONSTRAINTS=NO TRIGGERS=NO STATISTICS=NONE FILE=C:\exp.dat LOG=C:\exp.LOG
--
QUERY=\"WHERE date_start >=sysdate-1 and note like '%Oracle%'\"
В BATнике надо экранировать символы %. Символы экранирования для windows ^ и %
QUERY=\"WHERE date_start >=sysdate-1 and note like '%%Oracle%%'\"

/* Экспорт без строк */
EXP USERID=SYSTEM FILE=FULL_DDL.DMP ROWS=N
/* Импорт как SYSDBA */
IMP USERID='SYS/SYS@HNT as sysdba'

/*
Бывает что при импорте возникает ошибка ограничения внешних ключей (foreign key constraints violations).
Тогда можно импортировать данные в другую таблицу (imp to different table), а точнее в другую схему.
1. Обычный экспорт таблицы
exp USERID=username/pass@SID TABLES=TABLENAME INDEXES=NO GRANTS=NO CONSTRAINTS=NO TRIGGERS=NO STATISTICS=NONE FILE=C:\exp.dat LOG=C:\exp.LOG
2. Импорт в другую схему
imp USERID=username/pass@TEST FILE=C:\exp.dat LOG=C:\imp.LOG ignore=y fromuser=USERNAME touser=USER2
3. Инсерт из импортированной таблицы в существующую по условию что не существует по id. 
insert into USERNAME.TABLENAME (select * from USER2.TABLENAME t where t.ent_id not in (select ent_id from USERNAME.TABLENAME));
*/
