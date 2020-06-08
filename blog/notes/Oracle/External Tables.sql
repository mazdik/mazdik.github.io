/*
Внешняя таблица в Oracle позволяет читать файл с файловой системы сервера базы данных.
В Oracle 11.2g добавили «Препроцессинг данных внешних таблиц»(для обработки файлов, прежде чем прочитать из внешней таблицы).
*/


--Открыть alert log с помощью внешних таблиц в Oracle

CREATE OR REPLACE DIRECTORY bdump AS 'D:\oracle\product\10.2.0\admin\orcl\bdump';


DROP TABLE alert_log;

CREATE TABLE alert_log (
  line  VARCHAR2(4000)
)
ORGANIZATION EXTERNAL
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY bdump
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE
    BADFILE bdump:'read_alert_%a_%p.bad'
    LOGFILE bdump:'read_alert_%a_%p.log'
    FIELDS TERMINATED BY '~'
    MISSING FIELD VALUES ARE NULL
    (
      line  CHAR(4000)
    )
  )
  LOCATION ('alert_ORCL.log')
)
PARALLEL 1
REJECT LIMIT UNLIMITED
/

select * from ALERT_LOG;

/*
В этом примере открываем файлы Countries1.txt и Countries2.txt. Строки разделенные по NEWLINE, поля разделенные запятыми ','
Содержимое файла Countries1.txt:
ENG,England,English
SCO,Scotland,English
IRE,Ireland,English
WAL,Wales,Welsh
*/
CREATE OR REPLACE DIRECTORY BCP_DIR AS 'D:\bcp';

CREATE TABLE countries_ext (
  country_code      VARCHAR2(5),
  country_name      VARCHAR2(50),
  country_language  VARCHAR2(50)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY BCP_DIR
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
    (
      country_code      CHAR(5),
      country_name      CHAR(50),
      country_language  CHAR(50)
    )
  )
  LOCATION ('Countries1.txt','Countries2.txt')
)
PARALLEL 5
REJECT LIMIT UNLIMITED;
