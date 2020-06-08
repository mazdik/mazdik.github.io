/*
1) inner join
��������� ��� ��������� ������ ��� �����, ��� ������� ���������� ������������ ������� ������� ������� � ��������������. 
����� ������� ������� condition ������ ����������� ������.

2) outer join
� ���� �������, outer join ����� ���� left, right � full (����� outer ������ ����������).

3) cross join
���� ��� join ��� �������� ���������� ������������� (�� ���������� - cartesian product).

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

full outer join (����� ����� union ���� �������� left outer join � right outer join)
T_NAME  T_NICK    
res1     user3     
res2     user1     
res3     (null)    
res5     user3     
(null)   user4 

