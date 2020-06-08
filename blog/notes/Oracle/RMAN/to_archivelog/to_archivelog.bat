@echo off
chcp 1251
sqlplus /nolog @to_archivelog.sql > to_archivelog.log
rename to_archivelog.sql to_archivelog_.sql