/*
Степень параллелизма(для которой по умолчанию устанавливается значение 1) 
указывает, какое количество каналов RMAN разрешено открывать при выполнении резервного копирования или восстановления. 
Чем выше степень параллелизма, тем мень-ше времени будет уходить на резервное копирование или восстановление.
*/

RMAN> CONFIGURE DEVICE TYPE DISK PARALLELISM 4;


CONFIGURE DEFAULT DEVICE TYPE TO disk;        --# backup goes to disk
CONFIGURE DEVICE TYPE disk PARALLELISM 2;     --# two channels used in in parallel
CONFIGURE CHANNEL 1 DEVICE TYPE DISK FORMAT '/disk1/%U' --# 1st channel to disk1 
CONFIGURE CHANNEL 2 DEVICE TYPE DISK FORMAT '/disk2/%U' --# 2nd channel to disk2
BACKUP DATABASE; --# backup - first channel goes to disk1 and second to disk2