/* 3 подхода */

-- Встроенные представления для запрашивания из запроса
select p.id, c1_sum1, c2_sum2
from р,
(select id, sum (q1) c1 sum1 from c1 group bу id) c1,
(select id, sum (q2) с2 sum2 from с2 group bу id) с2
where р.id = c1.id
and p.id = c2.id

-- Скалярные подзапросы, которые выполняют отдельный запрос для каждой строки
select р.id,
(select sum (q1) from c1 where c1.id = p.id) c1_sum1,
(select sum (q2) from с2 where с2.id = р.id) с2_sum2
from р
where p.name = '1234'

-- Разложение подзапросов с помощью конструкции WIТН
with 
c1_vw as
(select id, sum(q1) c1_sum1 from c1 group bу id),
c2_vw as
(select id, sum(q2) с2_sum2 from с2 group bу id),
c1_с2 as
(select c1.id, c1.c1_sum1, с2.с2_sum2 from c1_vw c1, c2_vw с2 where c1.id = с2.id)
select p.id, c1_sum1, с2_sum2
from р, c1_c2
where p.id = c1_c2.id

/* Блокировка и защелкивание данных */

-- 1. Пессимистическая блокировка
SELECT FOR UPDATE NOWAIT

-- 2. Оптимистическая блокировка
-- Все поля в where со старыми значениями. 
-- Если система сообщит об обновлении одной строки, нам повезло: данные не изменялись в промежутке между моментом их чтения и моментом, когда мы отправляем обновление. 
-- Если мы обновили ноль строк, произошла потеря : кто-то другой изменил данные. 

-- 3. Оптимистическая блокировка с использованием столбца версии
-- Предусматривающая добавление по одному столбцу в каждую таблицу базы данных, которую нужно защитить от потерянных обновлений.
--Обычно такой столбец имеет тип NUMBER или DATE/TIMESTAМP.
last_mod timestamp with time zone default systimestamp not null

update dept set dnarne = upper(:dname), last_mod = systimestamp
where deptno = :deptno
and last_mod = to_timestamp_tz(:last_mod, 'DD-MON-YYYY HH.MI.SSXFF АМ TZR');

-- 4. Оптимистическая блокировка с использованием контрольной суммы
update dept set dname = :dname where deptno = :deptno and ora_hash(dname || '/' || loc) = :hash
-- Виртуальный столбец (Oracle 11) не влечет за собой накладные расходы по хранению. Его значение не вычисляется заранее для сохранения на диске. Вместо этого оно вычисляется при извлечении данных из базы.
alter table dept add hash as (ora_hash(dname || '/' || loc));

--Поиск не индексированных внешних ключей в Oracle
 select table_name, constraint_name,
        cname1 || nvl2(cname2,','||cname2,null) ||
        nvl2(cname3,','||cname3,null) || nvl2(cname4,','||cname4,null) ||
        nvl2(cname5,','||cname5,null) || nvl2(cname6,','||cname6,null) ||
        nvl2(cname7,','||cname7,null) || nvl2(cname8,','||cname8,null)
               columns
     from ( select b.table_name,
                   b.constraint_name,
                   max(decode( position, 1, column_name, null )) cname1,
                   max(decode( position, 2, column_name, null )) cname2,
                   max(decode( position, 3, column_name, null )) cname3,
                   max(decode( position, 4, column_name, null )) cname4,
                   max(decode( position, 5, column_name, null )) cname5,
                   max(decode( position, 6, column_name, null )) cname6,
                   max(decode( position, 7, column_name, null )) cname7,
                   max(decode( position, 8, column_name, null )) cname8,
                   count(*) col_cnt
              from (select substr(table_name,1,30) table_name,
                           substr(constraint_name,1,30) constraint_name,
                           substr(column_name,1,30) column_name,
                           position
                      from user_cons_columns ) a,
                   user_constraints b
             where a.constraint_name = b.constraint_name
               and b.constraint_type = 'R'
             group by b.table_name, b.constraint_name
          ) cons
    where col_cnt > ALL
            ( select count(*)
                from user_ind_columns i
               where i.table_name = cons.table_name
                 and i.column_name in (cname1, cname2, cname3, cname4,
                                       cname5, cname6, cname7, cname8 )
                 and i.column_position <= cons.col_cnt
               group by i.index_name
            )

/*
Плохие привычки в отношении транзакций

1. Фиксация в цикле

- Влияние на производительность
Частая фиксация обычно получается не быстрее - почти всегда быстрее делать работу в единственном операторе SQL.

- Ошибка "snapshot too old"
Давайте теперь рассмотрим вторую причину возникновения у разработчиков соблазна фиксировать обновления в процедурном цикле, 
которая является результатом (ошибочных) попыток экономно расходовать "ограниченный ресурс" (сегменты отката). 
Это проблема конфигурации; вы должны обеспечить наличие достаточного пространства для сегментов отмены, чтобы корректно устанавливать размеры своих
транзакций. Фиксация в цикле, помимо того, что работает медленнее, также часто вызывает ошибку ORA-01555.

2. Использование автоматической фиксации
ODBC и JDBC. Эти АРI ­ интерфейсы выполняют автоматическую фиксацию по умолчанию.
update accounts set balance = balance - 1000 where account_id = 123;
update accounts set balance = balance + 1000 where account_ld = 456;

Если при отправке этих запросов программа применяет АРI-интерфейс ODBC или JDBC, то он (молча) внедряет оператор фиксации после каждого оператора UPDATE. 
Представьте последствия этого, если в системе произойдет отказ после первого UPDATE, но перед вторым. Сумма $1000 будет потеряна!

conn.setAutoCommit(false);

Дело в том, что ODBC проектировали разработчики SQL Server, а эта база данных требует использования очень коротких транзакций из-за своей модели параллелизма 
(операции записи блокируют операции чтения, операции чтения блокируют операции записи, а блокировки являются дефицитным ресурсом).

*/

--Вместо (TRUNC(DATE_COL) вычис­ляеться по 1 разу для каждой строки таблицы и индекс на DATE_COL не используется)
TRUNC(DATE_COL) = TRUNC(SYSDATE)
--Лучше
where date_col >= trunc(sysdate) and date_col < trunc(sysdate+1)


/*
1) Все, что только возможно, должно делаться в одном операторе SQL. Верите или нет, но это возможно почти всегда. 
С течением времени это утверждение становится еще более справедливым. SQL - исключительно мощный язык.
2) Если что-то нельзя выполнить в одном операторе SQL, то это необходимо реализовать на языке PL/SQL с помощью как можно более краткого кода.
Следуйте принципу "больше кода больше ошибок, меньше кода меньше ошибок".
3) Если задачу нельзя решить средствами PL/SQL, попробуйте воспользоваться хранимой процедурой Java. 
Однако после выхода Oracle9i и последующих вер­сий потребность в этом возникает очень редко. 
PL/SQL является полноцен­ным и популярным языком третьего поколения (third-generation programming language - ЗGL).
4) Если задачу не удается решить на языке Java, попробуйте написать внешнюю процедуру С. 
И менно такой подход применяют наиболее часто, когда нужно обеспечить высокую скорость работы п риложения либо использовать API ­
и нтерфейс от независимых разработчиков, реализованный на языке С.
5) Если вы не можете решить задачу с помощью внешней процедуры С, всерьез задумайтесь над тем, если в ней необходимость.
*/