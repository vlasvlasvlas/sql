select 
gid,departamen as departamento,provincia,cabecera,fuente,
ST_XMin(the_geom) longmax,
ST_XMax(the_geom) as longmin,
ST_YMin(the_geom) as latmax,
ST_YMax(the_geom) as latmin
from ign.ign_departamentos 
where gid != 1
