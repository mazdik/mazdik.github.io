-- UPSERT (update or insert into a table)

-- MERGE (Oracle)
merge into employee using dual on ( "id"=2097153 )
when matched then update set "last"="smith" , "name"="john"
when not matched then insert ("id","last","name") 
    values ( 2097153,"smith", "john" )


-- INSERT ON CONFLICT (PostgreSQL)
insert into tablename (a, b, c) values (1, 2, 10)
on conflict (a) 
do update set c = excluded.c + 1;
--
insert into {t} (id,col1, col2, col3)
	values (%s, %s, %s, %s)
	on conflict (id)
	do update set
		(col1, col2, col3)
	  = (excluded.col1, excluded.col2, excluded.col3)
