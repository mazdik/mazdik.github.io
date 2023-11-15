/*
1) inner join
необходим для получения только тех строк, для которых существует соответствие записей главной таблицы и присоединяемой. 
Иными словами условие condition должно выполняться всегда.

2) outer join
В свою очередь, outer join может быть left, right и full (слово outer обычно опускается).

3) cross join
Этот тип join еще называют декартовым произведением (на английском - cartesian product).
*/

left outer join 
T_NAME  T_NICK    
res1    user3     
res2    user1 
res3    (null)    
res5    user3 
  
right outer join
T_NAME  T_NICK    
res2    user1     
res1    user3     
res5    user3     
(null)  user4 

full outer join (также можно union двух запросов left outer join и right outer join)
T_NAME  T_NICK    
res1     user3     
res2     user1     
res3     (null)    
res5     user3     
(null)   user4 
