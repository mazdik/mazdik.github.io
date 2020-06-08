-- Пользователь
CREATE USER 'citybp'@'localhost' IDENTIFIED BY 'citybp';
-- Привелегии
GRANT ALL PRIVILEGES ON `citybp` . * TO 'citybp'@'localhost';

--Импорт:
mysql -uroot -ppicapica l2jdb < l2jdb.sql
/opt/lampp/bin/mysql -uexchangebook -pexchangebook.ru --default_character_set utf8 exchangebook < book.sql
"C:\Program Files (x86)\VertrigoServ\Mysql\bin\mysql" -uroot -pvertrigo --default_character_set utf8 aion < D:\aion7.sql

# Подключение к mysql с коммандной строки
mysql -u USERNAME -p
show databases;
use DBNAME;

# Размер базы данных
SELECT table_schema AS "Database", 
ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)" 
FROM information_schema.TABLES 
GROUP BY table_schema;

-- Размер таблиц (нужно задать database_name)
SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM information_schema.TABLES
WHERE table_schema = "database_name"
ORDER BY (data_length + index_length) DESC;

# where timestamp
select count(*) from tbl_animals_images 
where animal_id in (select id from tbl_animals where create_time < UNIX_TIMESTAMP('2019-01-01'));
