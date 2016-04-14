

select 

(
(replace(replace(magnitud,',','.'),'-','0')::double precision) / (profundidad_km)
)*100 as valor,

* 
from inpres.inpres_sismos_historicos
where
(replace(replace(magnitud,',','.'),'-','0')::double precision)  > 0

