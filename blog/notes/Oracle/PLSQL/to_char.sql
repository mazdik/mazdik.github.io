select rtrim(to_char(1.123, 'fm99990d999'), '.,')  from Dual;
--1,123

select rtrim(to_char(1.000, 'fm99990d999'), '.,')  from Dual;
--1

/*
FM - Returns a value with no leading or trailing blanks. из строки удаляются все лишние нули и пробелы
D - Returns in the specified position the decimal character, which is the current value of the NLS_NUMERIC_CHARACTER parameter. 
The default is a period (.). Restriction: You can specify only one decimal character in a number format model.
десятичный разделитель (например, точка), определяемый в локальном контексте.
*/

alter session set nls_numeric_characters='.,';
--результат: 18.5
alter session set nls_numeric_characters=',.';
TO_CHAR(sr.temperature, '99G999D99', 'NLS_NUMERIC_CHARACTERS = '',.'''),
--результат: 18,50
