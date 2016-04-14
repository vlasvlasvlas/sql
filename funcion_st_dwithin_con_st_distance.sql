
(
select distinct min(ST_Distance(geography(pes.the_geom),geography(pi.the_geom))) as min,pes.gid
from eess.padron_eess pes, eess.pasos_internacionales pi
where st_dwithin(geography(pes.the_geom), geography(pi.the_geom), 100000) 
group by pes.gid) as b
where b.min=ST_Distance(geography(pes.the_geom),geography(pi.the_geom))
and b.gid=pes.gid
group by pi.name,pes.gid
order by 3
)as z


























