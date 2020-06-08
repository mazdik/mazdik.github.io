SELECT DECODE(value, NULL, 'PFILE', 'SPFILE') "Init File Type" 
FROM sys.v_$parameter WHERE name = 'spfile';


SELECT * FROM sys.v_$parameter WHERE name = 'spfile';

create pfile from spfile;
create spfile from pfile;

--создание из памяти, пригодится в случае утраты текущего файла параметров
CREATE PFILE FROM MEMORY;
CREATE SPFILE FROM MEMORY;

--покажет текущие настройки, действующие для запущенного экземпляра
SELECT name, value FROM V$PARAMETER;
--настройки, которые сохранены на диске, и с которыми экземпляр запустится при стартапе.
SELECT name, value FROM V$SPPARAMETER;