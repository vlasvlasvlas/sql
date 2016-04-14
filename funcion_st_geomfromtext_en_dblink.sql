

CREATE OR REPLACE VIEW hidrocarburos.vi_hidrocarburos_glp_plantas AS 

 SELECT *
   FROM dblink('host=host
                        user=postgres
                        password=postgres
                        dbname=db'::text, '

select 
f.nombre,f.apellido,f.razon_social,f.habilitado,p.*,pr.provincia,d.departamento,po.nombre as localidad,
ST_GeomFromText('||E'\'POINT('||E'\' ||  p.lon ||\' '||E'\'|| p.lat ||'||E'\' ) \''||',4326) as the_geom
from plantas p 
left join form_preinsc f on p.cuit = f.cuit
left join base.provinciasigm pr on p.idprovincia = pr.objectid
left join base.departamentosigm d on p.iddepartamento = d.objectid
left join base.pobladosigm po on p.idpoblado = po.objectid
where p.cuit not in (''-1'',''77777777777'')'::text) b( 

  nombre character varying,
  apellido character varying,
  razon_social character varying,
  habilitado boolean,

  cuit character varying,
  planta character varying,
  idplanta integer,
  direccion character varying,
  idprovincia integer,
  iddepartamento integer,
  idpoblado integer,
  codigopostal character varying,
  lat double precision,
  lon double precision,
  propia boolean,

  provincia character varying,
  departamento character varying,
  localidad character varying,
  the_geom geometry(Point,4326)
  );



