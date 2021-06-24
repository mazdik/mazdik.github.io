-- 1 способ
select summa1-summa2 as summa from
(select nvl(sum(s.pay_sum),0) summa1, max(l.in_document) docrn1
 from bankdocs b, doclinks l, bankdocspec s, dictoper d
      where b.rn = l.out_document
      and l.in_document = 318090915
      and b.rn = s.prn
      and exists (select null from doclinks where in_document = b.rn and out_unitcode = 'EconomicOperations')
      and b.type_oper = d.rn
      and d.factret_sign <> 1 ) sql1
LEFT OUTER JOIN 
( select nvl(sum(s.pay_sum),0) summa2, max(l.in_document) docrn2
 from bankdocs b, doclinks l, bankdocspec s, dictoper d
      where b.rn = l.out_document
      and l.in_document = 318090915
      and b.rn = s.prn
      and exists (select null from doclinks where in_document = b.rn and out_unitcode = 'EconomicOperations')
      and b.type_oper = d.rn
      and d.factret_sign=1) sql2
 ON sql1.docrn1=sql2.docrn2

-- 2 способ
select
(select nvl(sum(s.pay_sum),0) summa1
 from bankdocs b, doclinks l, bankdocspec s, dictoper d
      where b.rn = l.out_document
      and l.in_document = 318090915
      and b.rn = s.prn
      and exists (select null from doclinks where in_document = b.rn and out_unitcode = 'EconomicOperations')
      and b.type_oper = d.rn
      and d.factret_sign <> 1)
 - 
(select nvl(sum(s.pay_sum),0) summa2
 from bankdocs b, doclinks l, bankdocspec s, dictoper d
      where b.rn = l.out_document
      and l.in_document = 318090915
      and b.rn = s.prn
      and exists (select null from doclinks where in_document = b.rn and out_unitcode = 'EconomicOperations')
      and b.type_oper = d.rn
      and d.factret_sign = 1)
 as summa
 from dual;
 