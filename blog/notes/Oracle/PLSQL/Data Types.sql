/* Data Types 

В Oracle 1Og и последующих версиях поддерживаются 3 собственных типа дан­ных, которые подходят для хранения чисел.

NUMBER
BINARY_FLOAT
BINARY_DOUBLE

BINARY_FLOAT
Это собственный, утвержденный IEEE, числовой тип спла­вающей точкой одинарной точности.

BINARY_DOUBLE
Это собственный, утвержденный IEEE, числовой тип с плава­ющей точкой двойной точности.

Тип NUMBER в Oracle имеет значительно более высокую точность, чем ТИПЫ BINARY_FLOAT И BINARY_DOUBLE, но намного мень­ший диапазон значений, чем BINARY_DOUBLE. 
То есть с помощью типа NUMBER можно хранить числа очень точно со многими значащими цифрами, 
но типы BINARY_FLOAT и BINARY_DOUBLE позволяют хранить намного меньшие и большие числа.

типы BINARY_FLOAT и BINARY_DOUBLE не подойдут для финансовых приложений!


В арифметике с плавающей точкой для О.З + O.1 - результат будет чуть больше, чем О.4:
О.Зf + O.1f = 0.40000000600000
Это не ошибка, а способ работы чисел с плавающей точкой IEEE. 
Такая манера функционирования пригодна для решения определенного класса задач, 
но только не для тех, в которых участвуют денежные величины!

*/
-- BINARY_DOUBLE
declare
  temp   number;
  temp_b binary_double;
  val    number := 2.16;
  teint  number := 31.25;
begin
  temp   := teint / 24;
  temp_b := teint / 24;
  dbms_output.put_line(val * temp); -- 2.81249999999999999999999999999999999999
  dbms_output.put_line(val * teint / 24); -- 2.8125
  dbms_output.put_line(val * temp_b); -- 2.81250024E+000

  dbms_output.put_line(round((val * temp), 3)); -- 2.812
  dbms_output.put_line(round((val * teint / 24), 3)); -- 2.813
  dbms_output.put_line(round((val * temp_b), 3)); -- 2.813
end;
