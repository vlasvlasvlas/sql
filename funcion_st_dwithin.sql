create table pruebas.inti_eess_sep2011_anexo as (


select distinct *
from pruebas.inti_eess_sep2011
where cod_eess not in 
(
select distinct cod_eess::integer
from pruebas.inti_eess_sep2011 as inti, pruebas.hidrocarburos_eess2011 as hidro

where 
st_dwithin(geography(ST_SetSRID(ST_Point(inti.long, inti.lat),4326)), geography(hidro.the_geom), 70)
and
hidro.cuit=inti.cuit
--and hidro.operador = inti.petrolera

)
order by cod_eess




)