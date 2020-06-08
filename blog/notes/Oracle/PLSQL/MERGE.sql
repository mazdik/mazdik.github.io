----MERGE---
--��������� ��������� ��� �������� ������
--������ ��������, ���� �� ���. ������ �� insert, ���� ���. �� update

MERGE INTO ���_������� ���������_�������
USING (����|�������������|���������) ���������
ON (�������_����������)
WHEN MATCHED THEN 
UPDATE SET
�������1 = ��������,
�������2 = ��������
WHEN NOT MATCHED THEN 
INSERT (������_��������)
VALUES (������_��������);


-------- The MERGE statement merges data between two tables. Using DUAL allows us to use this command.

MERGE INTO Employee USING dual ON ( "id"=2097153 )
WHEN MATCHED THEN UPDATE SET "last"="smith" , "name"="john"
WHEN NOT MATCHED THEN INSERT ("id","last","name") 
    VALUES ( 2097153,"smith", "john" )