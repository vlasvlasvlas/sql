



select SUBSTR("codigoradio",1,5) as cod_depto,sum(o97) as suma
from indec.indec_datos_poblacion
group by cod_depto
order by  cod_depto

