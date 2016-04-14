


create view petrovision.petrovision_vi_sismica_2d_lineas as 
SELECT 
uli, linea, ppe, upe,  crs, largo_km,st_geomFromText('LINESTRING('||array_to_string(array_agg(lon::text||' '||lat::text), ',') ||')',4326)::geometry(Linestring,4326) as geom_line
from petrovision.petrovision_sismica_2d_puntos  
group by uli, linea, ppe, upe,  crs, largo_km 
having count(*) >= 2




