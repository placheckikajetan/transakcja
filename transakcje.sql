
select 
row_number() over(order by cl.id,ca.id) as ID_ubezpieczenia,
cl.id as ID_klienta,
ca.id as ID_samochodu,
case 
when ca.rok>=2000 and ca.rok<=2015 then 2500
when ca.rok between 1980 and 1999 then 2200
when ca.rok between 1940 and 1979 then 1300
else 3000
end as cena_bazowa_zl,
round(
(case 
when ca.rok>=2000 and ca.rok<=2015 then 2500
when ca.rok between 1980 and 1999 then 2200
when ca.rok between 1940 and 1979 then 1300
else 3000
end)
*(1-if(cl.country in('Polska','Chiny','Poland','China'),0.3,0)+if(cl.email like '%apple%',0.4,0))
*(1-(0.05*((select count(*) from cars where client_id=cl.id)-1)))
,2) as cena_koncowa_zl
from cars ca
join clients cl on ca.client_id=cl.id;
